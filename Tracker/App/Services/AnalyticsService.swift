import Foundation
import AppMetricaCore

final class AnalyticsService {
    static let shared = AnalyticsService()
    
    private init() {}
    
    // MARK: - Screen Events
    
    func reportScreenOpen(_ screen: String) {
        let parameters: [String: Any] = [
            "event": "open",
            "screen": screen
        ]
        
        AppMetrica.reportEvent(name: "screen", parameters: parameters)
        logEvent("screen", parameters: parameters)
    }
    
    func reportScreenClose(_ screen: String) {
        let parameters: [String: Any] = [
            "event": "close",
            "screen": screen
        ]
        
        AppMetrica.reportEvent(name: "screen", parameters: parameters)
        logEvent("screen", parameters: parameters)
    }
    
    // MARK: - Click Events
    func reportClick(_ item: String, screen: String) {
        let parameters: [String: Any] = [
            "event": "click",
            "screen": screen,
            "item": item
        ]
        
        AppMetrica.reportEvent(name: "click", parameters: parameters)
        logEvent("click", parameters: parameters)
    }
    
    // MARK: - Private Methods
    private func logEvent(_ eventName: String, parameters: [String: Any]) {
        #if DEBUG
        print("📊 Analytics Event: \(eventName)")
        for (key, value) in parameters {
            print("  \(key): \(value)")
        }
        print("---")
        #endif
    }
}

// MARK: - Analytics Event Items
extension AnalyticsService {
    enum Item: String {
        case addTrack = "add_track"
        case track = "track"
        case filter = "filter"
        case edit = "edit"
        case delete = "delete"
    }
    
    enum Screen: String {
        case main = "Main"
        case statistics = "Statistics"
    }
}
