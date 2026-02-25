import Combine
import Foundation

open class AppState: ObservableObject {
    @Published private(set) var hasCompletedInitialSetup = false
    @Published var selectedTab: TabSelection = .home

    func handlePostLaunch() {
        hasCompletedInitialSetup = true
    }
}
