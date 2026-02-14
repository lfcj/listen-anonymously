import Foundation

public extension Bundle {
    /// Use with Bundle.main.postHogAPIKey
    var postHogAPIKey: String? {
        return object(forInfoDictionaryKey: "PostHogAPIKey") as? String
    }
}
