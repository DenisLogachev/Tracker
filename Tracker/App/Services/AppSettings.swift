import Foundation

protocol AppSettingsProtocol {
    var hasSeenOnboarding: Bool { get set }
}

final class AppSettings: AppSettingsProtocol{
    
    static let shared = AppSettings()
    
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    private enum Keys {
        static let hasSeenOnboarding = "hasSeenOnboarding"
    }
    
    var hasSeenOnboarding: Bool {
        get { defaults.bool(forKey: Keys.hasSeenOnboarding)}
        set { defaults.set(newValue, forKey: Keys.hasSeenOnboarding) }
    }
}
