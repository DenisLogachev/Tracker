import Foundation

struct StatisticsData: Codable {
    let bestPeriod: Int
    let perfectDays: Int
    let completedTrackers: Int
    let averageValue: Double
    
    var isEmpty: Bool {
        return bestPeriod == 0 && perfectDays == 0 && completedTrackers == 0 && averageValue == 0
    }
}

struct StatisticsItem {
    let value: String
    let title: String
}

enum StatisticsType: CaseIterable {
    case bestPeriod
    case perfectDays
    case completedTrackers
    case averageValue
    
    var title: String {
        switch self {
        case .bestPeriod:
            return UIConstants.Statistics.Texts.statisticsBestPeriod
        case .perfectDays:
            return UIConstants.Statistics.Texts.statisticsPerfectDays
        case .completedTrackers:
            return UIConstants.Statistics.Texts.statisticsCompletedTrackers
        case .averageValue:
            return UIConstants.Statistics.Texts.statisticsAverageValue
        }
    }
    
}
