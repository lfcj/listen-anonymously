import Foundation
import Testing
import UIKit
@testable import Listen_Anonymously_Shared

struct DeeplinkHelperTests {

    @Test func hasAppReturnsFalse_whenUIApplicationCannotOpenLink() {
        let fakeApplication = FakeApplication(acceptedURLs: [])

        let acceptedApps = SupportedApps.allCases.filter { DeeplinkHelper.hasApp($0, application: fakeApplication) }

        #expect(acceptedApps.isEmpty)
    }

    @Test func hasAppReturnsTrueIfUIApplicationCanOpenLink() {
        let fakeApplication = FakeApplication(acceptedURLs: [URL(string: SupportedApps.telegram.deeplinkString)!])

        let acceptedApps = SupportedApps.allCases.filter { DeeplinkHelper.hasApp($0, application: fakeApplication) }

        #expect([SupportedApps.telegram] == acceptedApps)
        #expect([SupportedApps.telegram.id] == acceptedApps.map { $0.id })
    }

}
    
struct FakeApplication: DeeplinkVerifying {

    let acceptedURLs: [URL]

    init(acceptedURLs: [URL]) {
        self.acceptedURLs = acceptedURLs
    }
    nonisolated func canOpenURL(_ url: URL) -> Bool {
        acceptedURLs.contains(url)
    }

}
