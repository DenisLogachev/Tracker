import Foundation

struct StatisticsCacheData: Codable {
    let version: Int
    let statistics: StatisticsData
    let timestamp: Date
}
