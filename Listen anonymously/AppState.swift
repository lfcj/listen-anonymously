import Combine
import Foundation

class AppState: ObservableObject {
    @Published private(set) var hasCompletedInitialSetup = false

    func handlePostLaunch() {
        hasCompletedInitialSetup = true
    }
}
