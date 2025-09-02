import UIKit

final class TrackersPresenter {
    
    private weak var viewController: TrackersViewController?
    private var currentDate: Date = Date()
    private var allTrackers: [Tracker] = []
    private let trackerService: TrackerServiceProtocol
    
    init(viewController: TrackersViewController, trackerService: TrackerServiceProtocol) {
        self.viewController = viewController
        self.trackerService = trackerService
    }
    
    func loadTrackers() {
        allTrackers = trackerService.fetchAllTrackers()
        filterTrackers(for: currentDate)
    }
    
    func dateDidChange(to date: Date) {
        currentDate = date
        viewController?.updateDate(to: date)
        filterTrackers(for: date)
    }
    
    func trackerButtonTapped(trackerId: UUID) {
        guard let tracker = allTrackers.first(where: { $0.id == trackerId }) else { return }
        guard currentDate <= Date() else { return }
        
        if trackerService.isCompleted(on: currentDate, tracker: tracker) {
            trackerService.removeRecord(for: tracker, on: currentDate)
        } else {
            trackerService.addRecord(for: tracker, on: currentDate)
        }
        
        filterTrackers(for: currentDate)
    }
    
    private func filterTrackers(for date: Date) {
        let weekday = Weekday(date: date)
        
        let filteredTrackers = allTrackers
            .filter { $0.schedule.contains(weekday) }
            .map { tracker in
                TrackerCellViewModel(
                    id: tracker.id,
                    emoji: tracker.emoji,
                    title: tracker.name,
                    color: tracker.color,
                    completedDays: trackerService.completedDays(for: tracker),
                    isCompleted: trackerService.isCompleted(on: date, tracker: tracker),
                    isFuture: date > Date()
                )
            }
        
        let categorizedTrackers = groupTrackersByCategory(filteredTrackers)
        
        viewController?.showCategorizedTrackers(categorizedTrackers)
        viewController?.updatePlaceholderVisibility(isEmpty: categorizedTrackers.isEmpty)
    }
    
    private func groupTrackersByCategory(_ trackers: [TrackerCellViewModel]) -> [TrackerCategoryViewModel] {
        var categoryDict: [String: [TrackerCellViewModel]] = [:]
        
        for trackerViewModel in trackers {
            guard let originalTracker = allTrackers.first(where: { $0.id == trackerViewModel.id }) else { continue }
            let categoryName = originalTracker.category.title.isEmpty ? "Важное" : originalTracker.category.title
            
            if categoryDict[categoryName] == nil {
                categoryDict[categoryName] = []
            }
            categoryDict[categoryName]?.append(trackerViewModel)
        }
        
        if categoryDict.isEmpty && !trackers.isEmpty {
            categoryDict["Важное"] = trackers
        }
        
        return categoryDict.map { TrackerCategoryViewModel(title: $0.key, trackers: $0.value) }
            .sorted { $0.title < $1.title }
    }
    
    func addTracker(_ tracker: Tracker) {
        trackerService.addTracker(tracker)
        loadTrackers()
    }
}
