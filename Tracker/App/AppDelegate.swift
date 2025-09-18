import UIKit
import AppMetricaCore

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        _ = Persistence.shared
        let categoryStore = TrackerCategoryStore(useFRC: false)
        _ = categoryStore.ensureDefaultCategory()
        if let configuration = AppMetricaConfiguration(apiKey: "APIKey") {
            AppMetrica.activate(with: configuration)
        }
            return true
    }
        
        
        // MARK: UISceneSession Lifecycle
        func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
            
            return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        }
    }
