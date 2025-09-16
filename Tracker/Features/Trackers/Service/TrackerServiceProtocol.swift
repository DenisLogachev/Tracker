import Foundation

protocol TrackerServiceProtocol {
    func fetchAllTrackers() -> [Tracker]
    func completedDays(for tracker: Tracker) -> Int
    func isCompleted(on date: Date, tracker: Tracker) -> Bool
    func addTracker(_ tracker: Tracker)
    func updateTracker(_ tracker: Tracker)
    func deleteTracker(_ tracker: Tracker)
    func addRecord(for tracker: Tracker, on date: Date)
    func removeRecord(for tracker: Tracker, on date: Date)
}
