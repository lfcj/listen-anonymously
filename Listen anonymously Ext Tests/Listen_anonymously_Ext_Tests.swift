import Testing
import UIKit
import XCTest
@testable import Listen_anonymously

struct Listen_anonymously_Ext_Tests {

    @Test("Action View Controller has full screen presentation style")
    func actionViewController_hasFullScreenPresentationStyle() async throws {
        let storyboard = await UIStoryboard(name: "MainInterface", bundle: Bundle(for: ActionViewController.self))
        let optionalViewController = await storyboard.instantiateInitialViewController() as? ActionViewController
        let viewController = try XCTUnwrap(optionalViewController)

        #expect(viewController.modalPresentationStyle == .fullScreen)
    }

}
