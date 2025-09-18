import Foundation

final class StatisticsCacheService {
    static let shared = StatisticsCacheService()
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Constants
    private enum Keys {
        static let statistics = "cached_statistics"
    }
    
    private enum Cache {
        static let expirationInterval: TimeInterval = UIConstants.Statistics.Calculation.cacheExpirationInterval
        static let version = 1
    }
    
    // MARK: - Private Properties
    private var cachedData: StatisticsData?
    private var lastCacheTime: Date?
    
    private init() {}
    
    // MARK: - Public Methods
    func cacheStatistics(_ statistics: StatisticsData) {
        do {
            let cacheData = StatisticsCacheData(
                version: Cache.version,
                statistics: statistics,
                timestamp: Date()
            )
            let encoded = try JSONEncoder().encode(cacheData)
            userDefaults.set(encoded, forKey: Keys.statistics)
            
            cachedData = statistics
            lastCacheTime = Date()
        } catch {
            print("StatisticsCache: Failed to encode statistics - \(error)")
        }
    }
    
    func getCachedStatistics() -> StatisticsData? {
        if let cached = cachedData, 
           let lastTime = lastCacheTime, 
           !isCacheExpired(lastTime) {
            return cached
        }
        
        guard let cacheData = getCacheData() else { return nil }
        
        if isCacheExpired(cacheData.timestamp) {
            clearCache()
            return nil
        }

        cachedData = cacheData.statistics
        lastCacheTime = cacheData.timestamp
        
        return cacheData.statistics
    }
    
    func hasValidCache() -> Bool {
        if let lastTime = lastCacheTime, !isCacheExpired(lastTime) {
            return true
        }
        
        guard let cacheData = getCacheData() else { return false }
        return !isCacheExpired(cacheData.timestamp)
    }

    func clearCache() {
        userDefaults.removeObject(forKey: Keys.statistics)
        cachedData = nil
        lastCacheTime = nil
    }
    
    // MARK: - Private Methods
    private func isCacheExpired(_ timestamp: Date) -> Bool {
        Date().timeIntervalSince(timestamp) > Cache.expirationInterval
    }
    
    private func getCacheData() -> StatisticsCacheData? {
        guard let data = userDefaults.data(forKey: Keys.statistics) else { return nil }
        
        do {
            let cacheData = try JSONDecoder().decode(StatisticsCacheData.self, from: data)
            
            if cacheData.version != Cache.version {
                print("StatisticsCache: Cache version mismatch, clearing cache")
                clearCache()
                return nil
            }
            
            return cacheData
        } catch {
            print("StatisticsCache: Failed to decode cache data - \(error)")
            clearCache()
            return nil
        }
    }
}


