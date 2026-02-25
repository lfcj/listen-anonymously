import Foundation

public extension Bundle {
    /// Use with Bundle.main.postHogAPIKey
    var postHogAPIKey: String? {
        return object(forInfoDictionaryKey: "PostHogAPIKey") as? String
    }

    /// Use with Bundle.main.revenueCatAPIKey
    var revenueCatAPIKey: String? {
        return object(forInfoDictionaryKey: "RevenueCatAPIKey") as? String
    }
}
