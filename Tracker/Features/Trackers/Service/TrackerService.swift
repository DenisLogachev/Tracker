import Foundation

final class TrackerService: TrackerServiceProtocol {
    
    private let trackerStore: TrackerStore
    private let recordStore: TrackerRecordStore
    
    init(trackerStore: TrackerStore = TrackerStore(),
         recordStore: TrackerRecordStore = TrackerRecordStore()) {
        self.trackerStore = trackerStore
        self.recordStore = recordStore
    }
    
    func fetchAllTrackers() -> [Tracker] {
        return trackerStore.fetchAll()
    }
    
    func completedDays(for tracker: Tracker) -> Int {
        return recordStore.fetchRecords(for: tracker).count
    }
    
    func isCompleted(on date: Date, tracker: Tracker) -> Bool {
        return recordStore.fetchRecords(for: tracker)
            .contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func addTracker(_ tracker: Tracker) {
        trackerStore.add(tracker)
    }
    
    func updateTracker(_ tracker: Tracker) {
        trackerStore.update(tracker)
    }
    
    func deleteTracker(_ tracker: Tracker) {
        trackerStore.delete(tracker)
    }
    
    func addRecord(for tracker: Tracker, on date: Date) {
        recordStore.addRecord(for: tracker, on: date)
    }

    func removeRecord(for tracker: Tracker, on date: Date) {
        recordStore.deleteRecord(for: tracker, on: date)
    }
}
