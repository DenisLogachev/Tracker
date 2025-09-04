import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        if hasSeenOnboarding {
            window.rootViewController = TabBarController()
        } else {
            let onboarding = OnboardingPageViewController.demo()
            onboarding.onFinish = { [weak self] in
                UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                if let window = self?.window {
                    UIView.transition(
                        with: window,
                        duration: 0.3,
                        options: .transitionCrossDissolve,
                        animations: {
                            window.rootViewController = TabBarController()
                        })
                }
            }
            window.rootViewController = onboarding
        }
        self.window = window
        window.makeKeyAndVisible()
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    
    func sceneDidBecomeActive(_ scene: UIScene) {}
    
    func sceneWillResignActive(_ scene: UIScene) {}
    
    func sceneWillEnterForeground(_ scene: UIScene) {}
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        Persistence.shared.saveContext()
    }
}
