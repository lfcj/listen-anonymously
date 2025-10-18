import Combine
import Listen_Anonymously_Shared
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

    @Test("ActionViewController searches for audio after it loads")
    @MainActor func actionViewController_searchesForAudio() async throws {
        let spyManager = SpyAudioPlayingManager(extensionContext: nil)
        #expect(spyManager.findAudioCalls == 0)
        let findAudioCallValues = spyManager.$findAudioCalls.values

        let viewController = ActionViewController(playingManager: spyManager)
        viewController.loadViewIfNeeded()

        for await audioCall in findAudioCallValues {
            if audioCall > 0 {
                break
            }
        }

        #expect(spyManager.findAudioCalls == 1)
    }

}

class SpyAudioPlayingManager: AudioPlayingManager {
    @Published var findAudioCalls: Int = 0

    override func findAudio(isSecondAttempt: Bool) async {
        findAudioCalls += 1
    }

}
