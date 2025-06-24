import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureAppearance()
    }
    
    private func configureTabBar() {
        let trackersVC = TrackersViewController()
        let statisticsVC = StatisticsViewController()
        
        trackersVC.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(systemName: "record.circle.fill"),
            selectedImage: UIImage(systemName: "record.circle.fill")
        )
        statisticsVC.tabBarItem = UITabBarItem(
            title: "Статистика",
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
        appearance.backgroundColor = .white
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}

