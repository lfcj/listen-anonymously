import Combine
import SwiftUI
import Testing
import UIKit
import XCTest
@testable import Listen_Anonymously_Shared
@testable import Listen_anonymously

struct ActionViewControllerTests {

    init() {
        Task {
            await InjectionResolver.shared.add(SuperPosthog(), for: SuperPosthog.self)
        }
    }

    @MainActor
    @Test("Storyboard ActionViewController has full screen presentation style")
    func actionViewController_hasFullScreenPresentationStyle_whenInstatiatedFromStoryboard() async throws {
        let storyboard = UIStoryboard(name: "MainInterface", bundle: Bundle(for: ActionViewController.self))
        let optionalViewController = storyboard.instantiateInitialViewController() as? ActionViewController
        let viewController = try XCTUnwrap(optionalViewController)

        #expect(viewController.modalPresentationStyle == .fullScreen)
    }

    @MainActor
    @Test("Programatic ActionViewController has full screen presentation style")
    func actionViewController_hasFullScreenPresentationStyle_whenInstatiatedFromProgrammatically() async throws {
        let viewController = ActionViewController(nibName: nil, bundle: nil)

        #expect(viewController.modalPresentationStyle == .fullScreen)
    }

    @Test("ActionViewController searches for audio after it loads")
    @MainActor func actionViewController_searchesForAudio() async throws {
        let spyManager = SpyAudioPlayingManager(extensionContext: nil)
        #expect(spyManager.findAudioCalls == 0)
        let findAudioCallValues = spyManager.$findAudioCalls.values

        let viewController = ActionViewController(playingManager: spyManager)
        viewController.loadViewIfNeeded()

        for await audioCall in findAudioCallValues where audioCall > 0 {
            break
        }

        #expect(spyManager.findAudioCalls == 1)
    }

    @Test("Tapping on Done calls completeRequest")
    @MainActor func actionViewController_callsCompleteRequestWhenDoneIsTapped() throws {
        let spyExtensionContext = SpyExtensionContext()
        let manager = AudioPlayingManager(extensionContext: spyExtensionContext)
        let viewController = ActionViewController(
            playingManager: manager,
            extensionContext: spyExtensionContext
        )
        viewController.loadViewIfNeeded()

        let navController = try XCTUnwrap(viewController.children.first(where: { $0 is UINavigationController }) as? UINavigationController)

        let doneButton = navController.topViewController?.navigationItem.rightBarButtonItem
        _ = doneButton?.target?.perform(doneButton?.action)

        #expect(spyExtensionContext.completeRequestCalls == 1)
    }

    @Test("Tapping on Done does not call completeRequest when extensionContext is nil")
    @MainActor func actionViewController_doesNotCallCompleteRequestWhenExtensionContextIsNil() throws {
        let spyExtensionContext = SpyExtensionContext()
        let manager = AudioPlayingManager(extensionContext: spyExtensionContext)
        let viewController = ActionViewController(
            playingManager: manager,
            extensionContext: nil
        )
        viewController.loadViewIfNeeded()

        let navController = try XCTUnwrap(viewController.children.first(where: { $0 is UINavigationController }) as? UINavigationController)

        let doneButton = navController.topViewController?.navigationItem.rightBarButtonItem
        _ = doneButton?.target?.perform(doneButton?.action)

        #expect(spyExtensionContext.completeRequestCalls == 0)
    }

    @Test("iOS <26.0 uses .done as bar button style")
    @MainActor func doneIsUsedAsBarButtonStyleForiOSLessThan26() throws {
        let manager = AudioPlayingManager(extensionContext: nil)
        let viewController = ActionViewController(
            playingManager: manager,
            isIOS26Available: false
        )
        viewController.loadViewIfNeeded()

        let navController = try XCTUnwrap(viewController.children.first(where: { $0 is UINavigationController }) as? UINavigationController)

        let doneButton = navController.topViewController?.navigationItem.rightBarButtonItem

        if #available(iOS 26, *) {
            #expect(doneButton?.style == .prominent)
        } else {
            #expect(doneButton?.style == .done)
        }
    }

    @Test("default playingManager is used to initialized AudioPlayingView")
    @MainActor func audioPlayingView_isInitializedWithDefaultAudioPlayingManager() throws {
        let viewController = ActionViewController(nibName: nil, bundle: nil)
        viewController.loadViewIfNeeded()

        let navController = try XCTUnwrap(viewController.children.first(where: { $0 is UINavigationController }) as? UINavigationController)
        let hostingViewController = try XCTUnwrap(navController.topViewController as? UIHostingController<AudioPlayingView>)

        #expect(hostingViewController.rootView.playingManager === viewController.playingManager)
    }

}

class SpyAudioPlayingManager: AudioPlayingManager {
    @Published var findAudioCalls: Int = 0

    override func findAudio(isSecondAttempt: Bool) async {
        findAudioCalls += 1
    }

}

class SpyExtensionContext: NSExtensionContext {

    private(set) var completeRequestCalls = 0

    override func completeRequest(returningItems items: [Any]?, completionHandler: ((Bool) -> Void)? = nil) {
        completeRequestCalls += 1
    }

}
