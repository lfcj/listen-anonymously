import Foundation
internal import PostHog

public class SuperPosthog: Injectable {
    /// This is an abstract class to allow injection, never initialize it directly
    init() {}

    public func capture(_ event: String, properties: [String: any Equatable]? = nil) {
        PostHogSDK.shared.capture(event, properties: properties)
    }
}

public final class LAPostHog: SuperPosthog {
    public init(key: String) {
        // swiftlint:disable identifier_name
        let POSTHOG_HOST = "https://eu.i.posthog.com"

        let config = PostHogConfig(apiKey: key, host: POSTHOG_HOST)
        PostHogSDK.shared.setup(config)
        // swiftlint:enable identifier_name
    }
}
