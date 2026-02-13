import Foundation
internal import PostHog

public protocol LaPostHogging {
    func capture(_ event: String, properties: [String: Any]?)
}

public class LAPostHog: LaPostHogging {
    public init(key: String) {
        // swiftlint:disable identifier_name
        let POSTHOG_HOST = "https://eu.i.posthog.com"

        let config = PostHogConfig(apiKey: key, host: POSTHOG_HOST)
        PostHogSDK.shared.setup(config)
        // swiftlint:enable identifier_name
    }

    public func capture(_ event: String, properties: [String: Any]? = nil) {
        PostHogSDK.shared.capture(event, properties: properties)
    }
}
