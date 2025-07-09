import Foundation

final class TrackerService: TrackerServiceProtocol {
    
    private var trackerRecords: [TrackerRecord] = []
    private var trackers: [Tracker] = []
    
    func fetchAllTrackers() -> [Tracker] {
        return trackers
    }
    
    func completedDays(for tracker: Tracker) -> Int {
        trackerRecords.filter { $0.id == tracker.id }.count
    }
    
    func isCompleted(on date: Date, tracker: Tracker) -> Bool {
        trackerRecords.contains { $0.id == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func addTracker(_ tracker: Tracker) {
        trackers.append(tracker)
    }
    
    func addRecord(for tracker: Tracker, on date: Date) {
        let record = TrackerRecord(id: tracker.id, date: date)
        trackerRecords.append(record)
    }
    
    func removeRecord(for tracker: Tracker, on date: Date) {
        trackerRecords.removeAll { record in
            record.id == tracker.id && Calendar.current.isDate(record.date, inSameDayAs: date)
        }
    }
}

