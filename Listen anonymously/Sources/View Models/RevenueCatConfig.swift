import Foundation
import Listen_Anonymously_Shared

protocol RevenueCatConfigProviding: Sendable {
    var apiKey: String { get }
}

struct RevenueCatConfig: RevenueCatConfigProviding, Sendable {
    var apiKey: String {
        Bundle.main.revenueCatAPIKey ?? ""
    }
}
