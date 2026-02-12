import Foundation
internal import PostHog

public protocol LaPostHogging {
    // PostHogSDK.shared.capture("button_clicked", properties: ["button_name": "signup"])
}

public class LAPostHog: LaPostHogging {
    public init() {
        // swiftlint:disable identifier_name
        guard let POSTHOG_API_KEY = Bundle.main.postHogAPIKey else {
            return
        }
        let POSTHOG_HOST = "https://eu.i.posthog.com"

        let config = PostHogConfig(apiKey: POSTHOG_API_KEY, host: POSTHOG_HOST)
        PostHogSDK.shared.setup(config)
        // swiftlint:enable identifier_name
    }
}
