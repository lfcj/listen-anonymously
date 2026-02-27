import Foundation
internal import PostHog
import SwiftUI

public protocol PostHogProtocol: AnyObject, Sendable {
    func capture(_ event: String, properties: [String: any Equatable]?)
}

open class PostHog: @unchecked Sendable, PostHogProtocol {

    public static let shared = PostHog()
    private init() {}

    open func capture(_ event: String, properties: [String: any Equatable]? = nil) {
        PostHogSDK.shared.capture(event, properties: properties)
    }

    open func setup(key: String) {
        // swiftlint:disable identifier_name
        let POSTHOG_HOST = "https://eu.i.posthog.com"

        let config = PostHogConfig(apiKey: key, host: POSTHOG_HOST)
        PostHogSDK.shared.setup(config)
        // swiftlint:enable identifier_name
    }
}
