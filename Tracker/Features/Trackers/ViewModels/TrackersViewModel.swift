import UIKit

enum PlaceholderState {
    case noTrackersForDate
    case searchNotFound
    case filterNotFound
    case hidden
}

final class TrackersViewModel {
    // MARK: - Bindings
    var onCategorizedTrackersChanged: (([TrackerCategoryViewModel]) -> Void)?
    var onPlaceholderVisibilityChanged: ((Bool) -> Void)?
    var onPlaceholderStateChanged: ((PlaceholderState) -> Void)?
    var onDateChanged: ((Date) -> Void)?
    
    // MARK: - State
    private var currentDate: Date = Date()
    private var allTrackers: [Tracker] = []
    private var trackerIndex: [UUID: Int] = [:]
    private var searchText: String = ""
    private var currentFilter: TrackerFilter = .all
    private var visibleCategories: [TrackerCategoryViewModel] = []
    private let trackerService: TrackerServiceProtocol
    private var searchWorkItem: DispatchWorkItem?
    
    // MARK: - Caching
    private var cachedFilteredTrackers: [TrackerCellViewModel]?
    private var lastFilterState: (date: Date, search: String, filter: TrackerFilter)?
    
    // MARK: - Init
    init(trackerService: TrackerServiceProtocol) {
        self.trackerService = trackerService
        loadFilterState()
    }
    
    // MARK: - Public API
    func load() {
        allTrackers = trackerService.fetchAllTrackers()
        rebuildTrackerIndex()
        clearCache()
        filterTrackers(for: currentDate)
    }
    
    func changeDate(to date: Date) {
        onDateChanged?(date)
        filterTrackers(for: date)
    }
    
    func toggleTracker(withId trackerId: UUID) {
        guard let index = trackerIndex[trackerId],
              let tracker = tracker(at: index),
              currentDate <= Date() else { return }
        
        if trackerService.isCompleted(on: currentDate, tracker: tracker) {
            trackerService.removeRecord(for: tracker, on: currentDate)
        } else {
            trackerService.addRecord(for: tracker, on: currentDate)
        }
        
        clearCache()
        filterTrackers(for: currentDate)
    }
    
    func addTracker(_ tracker: Tracker) {
        trackerService.addTracker(tracker)
        load()
    }
    
    
    func updateTracker(_ tracker: Tracker) {
        trackerService.updateTracker(tracker)
        if let index = trackerIndex[tracker.id] {
            allTrackers[index] = tracker
        }
        updateVisibleCategories()
    }
    
    func deleteTracker(_ tracker: Tracker) {
        trackerService.deleteTracker(tracker)
        if let index = trackerIndex[tracker.id] {
            allTrackers.remove(at: index)
            rebuildTrackerIndex()
        }
        updateVisibleCategories()
    }
    
    func togglePin(for trackerId: UUID) {
        guard let index = trackerIndex[trackerId],
              let tracker = tracker(at: index) else { return }
        
        let updatedTracker = createUpdatedTracker(tracker, isPinned: !tracker.isPinned)
        allTrackers[index] = updatedTracker
        updateVisibleCategories()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.trackerService.updateTracker(updatedTracker)
        }
    }
    
    func applySearch(_ text: String) {
        searchText = text
        
        if text.isEmpty {
            searchWorkItem?.cancel()
            updateVisibleCategories()
            return
        }
        
        searchWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.updateVisibleCategories()
        }
        searchWorkItem = workItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() + UIConstants.Layout.searchDebounceDelay, execute: workItem)
    }
    
    func clearSearch() {
        searchText = ""
        searchWorkItem?.cancel()
        updateVisibleCategories()
    }
    
    func applyFilter(_ filter: TrackerFilter) {
        currentFilter = filter
        saveFilterState()
        
        if filter == .today {
            let today = Date()
            onDateChanged?(today)
            currentDate = today
        }
        
        updateVisibleCategories()
    }
    
    // MARK: - Public Getters
    var allTrackersList: [Tracker] {
        return allTrackers
    }
    
    var visibleCategoriesList: [TrackerCategoryViewModel] {
        return visibleCategories
    }
    
    var currentFilterState: TrackerFilter {
        return currentFilter
    }
    
    var isFilterActive: Bool {
        return currentFilter != .all && currentFilter != .today
    }
    
    var selectedDate: Date {
        return currentDate
    }
    
    // MARK: - Helpers
    private func filterTrackers(for date: Date) {
        currentDate = date
        updateVisibleCategories()
    }
    
    private func updateVisibleCategories() {
        let currentState = (date: currentDate, search: searchText, filter: currentFilter)
        if let lastState = lastFilterState,
           lastState.date == currentState.date,
           lastState.search == currentState.search,
           lastState.filter == currentState.filter,
           let cached = cachedFilteredTrackers {
            visibleCategories = groupTrackersByCategory(cached)
            updatePlaceholderState()
            return
        }
        
        let weekday = Weekday(date: currentDate)
        let searchLowercased = searchText.lowercased()
        
        let filteredTrackers = allTrackers.filter { tracker in
            guard tracker.schedule.contains(weekday) else { return false }
            
            if !searchText.isEmpty {
                return tracker.name.lowercased().contains(searchLowercased)
            }
            return true
        }
        
        let isFuture = currentDate > Date()
        let trackerViewModels = filteredTrackers.map { tracker in
            TrackerCellViewModel(
                id: tracker.id,
                emoji: tracker.emoji,
                title: tracker.name,
                color: tracker.color,
                completedDays: trackerService.completedDays(for: tracker),
                isCompleted: trackerService.isCompleted(on: currentDate, tracker: tracker),
                isFuture: isFuture,
                isPinned: tracker.isPinned
            )
        }
        
        let finalTrackerViewModels = applyFilterLogic(to: trackerViewModels)
        
        cachedFilteredTrackers = finalTrackerViewModels
        lastFilterState = currentState
        
        visibleCategories = groupTrackersByCategory(finalTrackerViewModels)
        updatePlaceholderState()
    }
    
    private func updatePlaceholderState() {
        let placeholderState: PlaceholderState
        if visibleCategories.isEmpty {
            if !searchText.isEmpty {
                placeholderState = .searchNotFound
            } else if isFilterActive {
                placeholderState = .filterNotFound
            } else {
                placeholderState = .noTrackersForDate
            }
        } else {
            placeholderState = .hidden
        }
        
        onCategorizedTrackersChanged?(visibleCategories)
        onPlaceholderVisibilityChanged?(visibleCategories.isEmpty)
        onPlaceholderStateChanged?(placeholderState)
    }
    
    private func applyFilterLogic(to trackers: [TrackerCellViewModel]) -> [TrackerCellViewModel] {
        switch currentFilter {
        case .all, .today:
            return trackers
        case .completed:
            return trackers.filter { $0.isCompleted }
        case .uncompleted:
            return trackers.filter { !$0.isCompleted }
        }
    }
    
    private func groupTrackersByCategory(_ trackers: [TrackerCellViewModel]) -> [TrackerCategoryViewModel] {
        var categoryDict: [String: [TrackerCellViewModel]] = [:]
        var pinnedTrackers: [TrackerCellViewModel] = []
        
        for trackerViewModel in trackers {
            guard let originalTracker = allTrackers.first(where: { $0.id == trackerViewModel.id }) else { continue }
            
            if originalTracker.isPinned {
                pinnedTrackers.append(trackerViewModel)
            } else {
                let categoryName = originalTracker.category.title.isEmpty ? TrackerConstants.Strings.importantCategoryTitle : originalTracker.category.title
                
                if categoryDict[categoryName] == nil {
                    categoryDict[categoryName] = []
                }
                categoryDict[categoryName]?.append(trackerViewModel)
            }
        }
        
        var result: [TrackerCategoryViewModel] = []
        
        if !pinnedTrackers.isEmpty {
            result.append(TrackerCategoryViewModel(title: "Закрепленные", trackers: pinnedTrackers))
        }
        
        let otherCategories = categoryDict.map { TrackerCategoryViewModel(title: $0.key, trackers: $0.value) }
            .sorted { $0.title < $1.title }
        result.append(contentsOf: otherCategories)
        
        return result
    }
    
    // MARK: - Private Helpers
    private func rebuildTrackerIndex() {
        trackerIndex.removeAll()
        for (index, tracker) in allTrackers.enumerated() {
            trackerIndex[tracker.id] = index
        }
    }
    
    private func tracker(at index: Int) -> Tracker? {
        guard index >= 0 && index < allTrackers.count else { return nil }
        return allTrackers[index]
    }
    
    private func createUpdatedTracker(_ tracker: Tracker, isPinned: Bool) -> Tracker {
        return Tracker(
            id: tracker.id,
            name: tracker.name,
            color: tracker.color,
            emoji: tracker.emoji,
            schedule: tracker.schedule,
            category: tracker.category,
            isPinned: isPinned
        )
    }
    
    // MARK: - Filter State Persistence
    private func saveFilterState() {
        UserDefaults.standard.set(currentFilter.rawValue, forKey: "SelectedTrackerFilter")
    }
    
    private func loadFilterState() {
        if let savedFilterRawValue = UserDefaults.standard.string(forKey: "SelectedTrackerFilter"),
           let savedFilter = TrackerFilter(rawValue: savedFilterRawValue) {
            currentFilter = savedFilter
        }
    }
    
    private func clearCache() {
        cachedFilteredTrackers = nil
        lastFilterState = nil
    }
}
