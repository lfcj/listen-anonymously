import Combine
import Foundation

class AppState: ObservableObject {
    @Published private(set) var hasCompletedInitialSetup = false
    @Published var selectedTab: TabSelection = .home

    func handlePostLaunch() {
        hasCompletedInitialSetup = true
    }
}
