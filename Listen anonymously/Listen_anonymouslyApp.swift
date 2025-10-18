import SwiftUI

@main
struct Listen_anonymouslyApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            LATabView()
                .environmentObject(appState)
        }
    }
}
