import Foundation

// MARK: - Notification Names
extension Notification.Name {
    static let statisticsDidUpdate = Notification.Name("statisticsDidUpdate")
    static let trackerRecordDidChange = Notification.Name("trackerRecordDidChange")
}

// MARK: - Statistics Notification Center
final class StatisticsNotificationCenter {
    static let shared = StatisticsNotificationCenter()
    
    // MARK: - Constants
    private enum UserInfoKeys {
        static let statistics = "statistics"
        static let trackerId = "trackerId"
        static let date = "date"
        static let isCompleted = "isCompleted"
    }
    
    private init() {}
    
    // MARK: - Public Methods
    func notifyStatisticsUpdate(_ statistics: StatisticsData) {
        let userInfo: [String: Any] = [
            UserInfoKeys.statistics: statistics
        ]
        
        NotificationCenter.default.post(
            name: .statisticsDidUpdate,
            object: self,
            userInfo: userInfo
        )
    }
    
    func notifyTrackerRecordChange(trackerId: UUID, date: Date, isCompleted: Bool) {
        let userInfo: [String: Any] = [
            UserInfoKeys.trackerId: trackerId,
            UserInfoKeys.date: date,
            UserInfoKeys.isCompleted: isCompleted
        ]
        
        NotificationCenter.default.post(
            name: .trackerRecordDidChange,
            object: self,
            userInfo: userInfo
        )
    }
    
    func observeStatisticsUpdates(observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(
            observer,
            selector: selector,
            name: .statisticsDidUpdate,
            object: nil
        )
    }
    
    func observeTrackerRecordChanges(observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(
            observer,
            selector: selector,
            name: .trackerRecordDidChange,
            object: nil
        )
    }
    
    func removeObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
}
