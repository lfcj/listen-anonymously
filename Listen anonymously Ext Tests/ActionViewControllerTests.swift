import Testing
import UIKit
import XCTest
@testable import Listen_anonymously

struct ActionViewControllerTests {

    @Test("Storyboard ActionViewController has full screen presentation style")
    func actionViewController_hasFullScreenPresentationStyle_whenInstatiatedFromStoryboard() async throws {
        let storyboard = await UIStoryboard(name: "MainInterface", bundle: Bundle(for: ActionViewController.self))
        let optionalViewController = await storyboard.instantiateInitialViewController() as? ActionViewController
        let viewController = try XCTUnwrap(optionalViewController)
        

        #expect(viewController.modalPresentationStyle == .fullScreen)
    }

    @Test("Programatic ActionViewController has full screen presentation style")
    func actionViewController_hasFullScreenPresentationStyle_whenInstatiatedFromProgrammatically() async throws {
        let viewController = await ActionViewController(nibName: nil, bundle: nil)

        #expect(viewController.modalPresentationStyle == .fullScreen)
    }

}
