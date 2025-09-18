import Foundation

final class StatisticsViewModel {
    private let statisticsService: StatisticsServiceProtocol
    private let notificationCenter = StatisticsNotificationCenter.shared
    
    // MARK: - Callbacks
    var onStatisticsChanged: (([StatisticsItem]) -> Void)?
    var onPlaceholderVisibilityChanged: ((Bool) -> Void)?
    
    // MARK: - Init
    init(statisticsService: StatisticsServiceProtocol) {
        self.statisticsService = statisticsService
        setupNotifications()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    // MARK: - Public Methods
    func loadStatistics() {
        do {
            let statisticsData = try statisticsService.calculateStatistics()
            updateUI(with: statisticsData)
        } catch {
            print("StatisticsViewModel: Failed to load statistics - \(error)")
            updateUI(with: StatisticsData(bestPeriod: 0, perfectDays: 0, completedTrackers: 0, averageValue: 0))
        }
    }
    
    // MARK: - Private Methods
    private func setupNotifications() {
        notificationCenter.observeStatisticsUpdates(
            observer: self,
            selector: #selector(handleStatisticsUpdate(_:))
        )
        
        notificationCenter.observeTrackerRecordChanges(
            observer: self,
            selector: #selector(handleTrackerRecordChange(_:))
        )
    }
    
    @objc private func handleStatisticsUpdate(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let statistics = userInfo["statistics"] as? StatisticsData else {
            return
        }
        
        updateUI(with: statistics)
    }
    
    @objc private func handleTrackerRecordChange(_ notification: Notification) {
        statisticsService.invalidateCache()
        
        DispatchQueue.main.async { [weak self] in
            self?.loadStatistics()
        }
    }
    
    private func updateUI(with statistics: StatisticsData) {
        let items = createStatisticsItems(from: statistics)
        
        let hasAnyData = statistics.bestPeriod > 0 ||
        statistics.perfectDays > 0 ||
        statistics.completedTrackers > 0 ||
        statistics.averageValue > 0
        
        onStatisticsChanged?(items)
        onPlaceholderVisibilityChanged?(!hasAnyData)
    }
    
    private func createStatisticsItems(from data: StatisticsData) -> [StatisticsItem] {
        return StatisticsType.allCases.map { type in
            let value: String
            switch type {
            case .bestPeriod:
                value = "\(data.bestPeriod)"
            case .perfectDays:
                value = "\(data.perfectDays)"
            case .completedTrackers:
                value = "\(data.completedTrackers)"
            case .averageValue:
                if data.averageValue == 0 {
                    value = "0"
                } else if data.averageValue < UIConstants.Statistics.Formatting.zeroThreshold {
                    value = String(format: "%.\(UIConstants.Statistics.Formatting.averageValueDecimalPlaces)f", data.averageValue)
                } else {
                    value = "\(Int(data.averageValue.rounded()))"
                }
            }
            
            return StatisticsItem(
                value: value,
                title: type.title
            )
        }
    }
}
