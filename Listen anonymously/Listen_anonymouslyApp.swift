import SwiftUI

@main
// swiftlint:disable type_name
struct Listen_anonymouslyApp: App {
// swiftlint:enable type_name
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            LATabView()
                .environmentObject(appState)
        }
    }
}
