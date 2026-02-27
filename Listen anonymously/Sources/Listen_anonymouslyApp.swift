import Listen_Anonymously_Shared
import SwiftUI

@main
// swiftlint:disable type_name
struct Listen_anonymouslyApp: App {
// swiftlint:enable type_name
    @StateObject private var appState = AppState()

    init() {
        guard let postHogKey = Bundle.main.postHogAPIKey else {
            // swiftlint:disable todo
            // TODO: Log error.
            // swiftlint:enable todo
            return
        }
        PostHog.shared.setup(key: postHogKey)
    }

    var body: some Scene {
        WindowGroup {
            LATabView()
                .environmentObject(appState)
        }
    }
}
