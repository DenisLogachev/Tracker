import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureAppearance()
    }
    
    private func configureTabBar() {
        let trackerService = TrackerService()
        let trackerRecordService = TrackerRecordStore()
        let statisticsService = StatisticsService(trackerService: trackerService, trackerRecordService: trackerRecordService)
        
        let trackersViewModel = TrackersViewModel(trackerService: trackerService)
        let statisticsViewModel = StatisticsViewModel(statisticsService: statisticsService)
        
        let trackersVC = TrackersViewController(viewModel: trackersViewModel, trackerService: trackerService)
        let statisticsVC = StatisticsViewController(viewModel: statisticsViewModel)
        
        trackersVC.tabBarItem = UITabBarItem(
            title: UIConstants.TabBar.trackers,
            image: UIImage(systemName: "record.circle.fill"),
            selectedImage: UIImage(systemName: "record.circle.fill")
        )
        statisticsVC.tabBarItem = UITabBarItem(
            title: UIConstants.TabBar.statistics,
            image: UIImage(systemName: "hare.fill"),
            selectedImage: UIImage(systemName: "hare.fill")
        )
        viewControllers = [
            UINavigationController(rootViewController: trackersVC),
            UINavigationController(rootViewController: statisticsVC)
        ]
    }
    private func configureAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIConstants.Colors.screenBackground
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIConstants.Colors.secondaryGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIConstants.Colors.secondaryGray
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIConstants.Colors.accentColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIConstants.Colors.accentColor
        ]
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}

