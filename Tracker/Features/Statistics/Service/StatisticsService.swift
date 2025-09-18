import Foundation

enum StatisticsError: Error {
    case invalidData
    case calculationFailed
    case cacheError
}

protocol StatisticsServiceProtocol {
    func calculateStatistics() throws -> StatisticsData
    func invalidateCache()
}

final class StatisticsService: StatisticsServiceProtocol {
    private let trackerService: TrackerServiceProtocol
    private let trackerRecordService: TrackerRecordStore
    private let cacheService: StatisticsCacheService
    
    init(trackerService: TrackerServiceProtocol,
         trackerRecordService: TrackerRecordStore,
         cacheService: StatisticsCacheService = StatisticsCacheService.shared) {
        self.trackerService = trackerService
        self.trackerRecordService = trackerRecordService
        self.cacheService = cacheService
    }
    
    func calculateStatistics() throws -> StatisticsData {
        if let cachedStatistics = cacheService.getCachedStatistics() {
            return cachedStatistics
        }
        
        return try calculateAndCacheStatistics()
    }
    
    func invalidateCache() {
        cacheService.clearCache()
    }
    
    private func calculateAndCacheStatistics() throws -> StatisticsData {
        let allTrackers = trackerService.fetchAllTrackers()
        let allRecords = trackerRecordService.fetchAll()
        
        guard !allTrackers.isEmpty || !allRecords.isEmpty else {
            throw StatisticsError.invalidData
        }
        
        let bestPeriod = calculateBestPeriod(trackers: allTrackers, records: allRecords)
        let perfectDays = calculatePerfectDays(trackers: allTrackers, records: allRecords)
        let completedTrackers = calculateCompletedTrackers(records: allRecords)
        let averageValue = calculateAverageValue(trackers: allTrackers, records: allRecords)
        
        let statisticsData = StatisticsData(
            bestPeriod: bestPeriod,
            perfectDays: perfectDays,
            completedTrackers: completedTrackers,
            averageValue: averageValue
        )

        cacheService.cacheStatistics(statisticsData)
        
        StatisticsNotificationCenter.shared.notifyStatisticsUpdate(statisticsData)
        
        return statisticsData
    }
    
    // MARK: - Private Methods
    
    private func buildTrackersByDate(_ records: [TrackerRecord]) -> [Date: Set<UUID>] {
        let calendar = Calendar.current
        var trackersByDate: [Date: Set<UUID>] = [:]
        
        for record in records {
            let date = calendar.startOfDay(for: record.date)
            trackersByDate[date, default: Set()].insert(record.trackerId)
        }
        
        return trackersByDate
    }
    
    private func calculateBestPeriod(trackers: [Tracker], records: [TrackerRecord]) -> Int {
        guard !trackers.isEmpty else { return 0 }
        
        let trackersByDate = buildTrackersByDate(records)
        let calendar = Calendar.current
        let today = Date()
        
        return findMaxPeriod(from: trackersByDate, calendar: calendar, today: today)
    }
    
    private func calculatePerfectDays(trackers: [Tracker], records: [TrackerRecord]) -> Int {
        guard !trackers.isEmpty else { return 0 }
        
        let trackersByDate = buildTrackersByDate(records)
        let calendar = Calendar.current
        let today = Date()
        
        return countPerfectDays(trackers: trackers, trackersByDate: trackersByDate, calendar: calendar, today: today)
    }
    
    private func calculateCompletedTrackers(records: [TrackerRecord]) -> Int {
        return records.count
    }
    
    private func calculateAverageValue(trackers: [Tracker], records: [TrackerRecord]) -> Double {
        guard !trackers.isEmpty else { return 0 }
        
        let trackersByDate = buildTrackersByDate(records)
        let calendar = Calendar.current
        let today = Date()
        
        return calculateAverageFromTrackersByDate(trackersByDate, calendar: calendar, today: today)
    }
    
    private func allTrackersActiveOnDate(_ trackers: [Tracker], date: Date) -> Set<UUID> {
        let weekday = Weekday(date: date)
        
        return Set(trackers.filter { tracker in
            tracker.schedule.contains(weekday)
        }.map { $0.id })
    }
    
    // MARK: - Helper Methods
    private func findMaxPeriod(from trackersByDate: [Date: Set<UUID>], calendar: Calendar, today: Date) -> Int {
        var maxPeriod = 0
        var currentPeriod = 0
        
        for i in 0..<UIConstants.Statistics.Calculation.otherMetricsDays {
            let checkDate = calendar.date(byAdding: .day, value: -i, to: today)!
            let startOfDay = calendar.startOfDay(for: checkDate)
            
            let hasAnyTracker = trackersByDate[startOfDay] != nil && !trackersByDate[startOfDay]!.isEmpty
            
            if hasAnyTracker {
                currentPeriod += 1
                maxPeriod = max(maxPeriod, currentPeriod)
            } else {
                currentPeriod = 0
            }
        }
        
        return maxPeriod
    }
    
    private func countPerfectDays(trackers: [Tracker], trackersByDate: [Date: Set<UUID>], calendar: Calendar, today: Date) -> Int {
        var perfectDays = 0
        
        for i in 0..<UIConstants.Statistics.Calculation.otherMetricsDays {
            let checkDate = calendar.date(byAdding: .day, value: -i, to: today)!
            let startOfDay = calendar.startOfDay(for: checkDate)
            
            let activeTrackers = allTrackersActiveOnDate(trackers, date: checkDate)
            
            if activeTrackers.isEmpty {
                continue
            }
            
            let completedTrackers = trackersByDate[startOfDay] ?? Set()
            
            if activeTrackers.isSubset(of: completedTrackers) {
                perfectDays += 1
            }
        }
        
        return perfectDays
    }
    
    private func calculateAverageFromTrackersByDate(_ trackersByDate: [Date: Set<UUID>], calendar: Calendar, today: Date) -> Double {
        var totalDays = 0
        var totalCompletedTrackers = 0
        
        for i in 0..<UIConstants.Statistics.Calculation.averageValueDays {
            let checkDate = calendar.date(byAdding: .day, value: -i, to: today)!
            let startOfDay = calendar.startOfDay(for: checkDate)
            
            let completedTrackers = trackersByDate[startOfDay] ?? Set()
            
            if !completedTrackers.isEmpty {
                totalDays += 1
                totalCompletedTrackers += completedTrackers.count
            }
        }
        
        return totalDays == 0 ? 0 : Double(totalCompletedTrackers) / Double(totalDays)
    }
}

