import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        let hasSeenOnboarding = AppSettings.shared.hasSeenOnboarding
        if hasSeenOnboarding {
            window.rootViewController = TabBarController()
        } else {
            let onboarding = OnboardingPageViewController.demo()
            onboarding.onFinish = { [weak self] in
                AppSettings.shared.hasSeenOnboarding = true
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
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        Persistence.shared.saveContext()
    }
}
