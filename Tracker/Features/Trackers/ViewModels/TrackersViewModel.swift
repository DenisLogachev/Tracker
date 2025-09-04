import Foundation
import UIKit

final class TrackersViewModel {
    // MARK: - Bindings
    var onCategorizedTrackersChanged: (([TrackerCategoryViewModel]) -> Void)?
    var onPlaceholderVisibilityChanged: ((Bool) -> Void)?
    var onDateChanged: ((Date) -> Void)?
    
    // MARK: - State
    private var currentDate: Date = Date()
    private var allTrackers: [Tracker] = []
    private let trackerService: TrackerServiceProtocol
    
    // MARK: - Init
    init(trackerService: TrackerServiceProtocol) {
        self.trackerService = trackerService
    }
    
    // MARK: - Public API
    func load() {
        allTrackers = trackerService.fetchAllTrackers()
        filterTrackers(for: currentDate)
    }
    
    func changeDate(to date: Date) {
        currentDate = date
        onDateChanged?(date)
        filterTrackers(for: date)
    }
    
    func toggleTracker(withId trackerId: UUID) {
        guard let tracker = allTrackers.first(where: { $0.id == trackerId }),
              currentDate <= Date() else { return }
        
        if trackerService.isCompleted(on: currentDate, tracker: tracker) {
            trackerService.removeRecord(for: tracker, on: currentDate)
        } else {
            trackerService.addRecord(for: tracker, on: currentDate)
        }
        
        filterTrackers(for: currentDate)
    }
    
    func addTracker(_ tracker: Tracker) {
        trackerService.addTracker(tracker)
        load()
    }
    
    // MARK: - Helpers
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
        
        onCategorizedTrackersChanged?(categorizedTrackers)
        onPlaceholderVisibilityChanged?(categorizedTrackers.isEmpty)
    }
    
    private func groupTrackersByCategory(_ trackers: [TrackerCellViewModel]) -> [TrackerCategoryViewModel] {
        var categoryDict: [String: [TrackerCellViewModel]] = [:]
        
        for trackerViewModel in trackers {
            guard let originalTracker = allTrackers.first(where: { $0.id == trackerViewModel.id }) else { continue }
            let categoryName = originalTracker.category.title.isEmpty ? TrackerConstants.Strings.importantCategoryTitle : originalTracker.category.title
            
            if categoryDict[categoryName] == nil {
                categoryDict[categoryName] = []
            }
            categoryDict[categoryName]?.append(trackerViewModel)
        }
        
        if categoryDict.isEmpty && !trackers.isEmpty {
            categoryDict[TrackerConstants.Strings.importantCategoryTitle] = trackers
        }
        
        return categoryDict.map { TrackerCategoryViewModel(title: $0.key, trackers: $0.value) }
            .sorted { $0.title < $1.title }
    }
}


