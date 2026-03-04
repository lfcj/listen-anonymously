import Listen_Anonymously_Shared
@testable import Listen_anonymously
import SwiftUI
import XCTest

@MainActor
// swiftlint:disable type_name
final class Listen_anonymously_Snapshot_Tests: XCTestCase {
// swiftlint:enable type_name

    // MARK: - Nested Types

    typealias FramingLocale = (folder: String, language: String)

    // MARK: - Localized screenshots for frameit (fastlane/screenshots/<locale>/)

    /// Fastlane locale folder -> Apple language code used in .lproj bundles.
    /// Covers all App Store Connect locales that the app supports.
    private let frameitLocales: [FramingLocale] = [
//        ("ar-SA", "ar"),
        ("cs", "cs"),
        ("da", "da"),
        ("de-DE", "de"),
        ("el", "el"),
        ("en-AU", "en-AU"),
        ("en-GB", "en-GB"),
        ("en-US", "en"),
        ("es-ES", "es"),
        ("es-MX", "es-MX"),
        ("fi", "fi"),
        ("fr-CA", "fr-CA"),
        ("fr-FR", "fr"),
//        ("he", "he"),
//        ("hi", "hi"),
        ("hr", "hr"),
        ("hu", "hu"),
        ("id", "id"),
        ("it", "it"),
//        ("ja", "ja"),
//        ("ko", "ko"),
        ("ms", "ms"),
        ("nl-NL", "nl"),
        ("no", "nb"),
        ("pl", "pl"),
        ("pt-BR", "pt-BR"),
        ("pt-PT", "pt-PT"),
        ("ro", "ro"),
        ("ru", "ru"),
        ("sk", "sk"),
        ("sv", "sv"),
//        ("th", "th"),
        ("tr", "tr"),
        ("uk", "uk"),
        ("vi", "vi")
//        ("zh-Hans", "zh-Hans"),
//        ("zh-Hant", "zh-Hant")
    ]

    let ciLocales: [FramingLocale] = [
        ("de-DE", "de"),
        ("en-US", "en"),
        ("es-ES", "es"),
        ("fr-FR", "fr")
    ]

    func test_frameit_screenshots() {
        let isCI = ProcessInfo.processInfo.environment["CI"] != nil
        let localesToTest = isCI ? ciLocales : frameitLocales
        for locale in localesToTest {
            My.currentLocalization = locale.language

            var configs: [(config: SnapshotConfiguration, suffix: String)] = [
                (.iPhone14ProMax(style: .light), "")
            ]

            if !isCI {
                configs.append((.iPadPro13(style: .light), "_ipad"))
            }

            for (config, suffix) in configs {
                // 01 - Front Door
                let frontDoor = FrontDoorView()
                record(
                    snapshot: frontDoor.snapshot(with: config, needsWindow: true),
                    named: "03_screenshot\(suffix)",
                    locale: locale.folder
                )

                // 02 - Instructions
                let instructionsViewModel = InstructionsViewModel()
                instructionsViewModel.supportedApps = [.telegram, .whatsApp]
                instructionsViewModel.selectedApp = .whatsApp
                let instructionsView = InstructionsView(viewModel: instructionsViewModel)
                record(
                    snapshot: instructionsView.snapshot(with: config, needsWindow: true),
                    named: "02_screenshot\(suffix)",
                    locale: locale.folder
                )

                // 03 - Playing View
                let playingManager = AudioPlayingManager(
                    extensionContext: NSExtensionContext(),
                    canPlay: true,
                    isPlaying: true,
                    duration: 42
                )
                let playerViewModel = PlayerControllerViewModel(playingManager: playingManager, currentTime: 12)
                let audioPlayingView = AudioPlayingView(playingManager: playingManager, playerControllerViewModel: playerViewModel)
                record(
                    snapshot: audioPlayingView.snapshot(with: config, needsWindow: true),
                    named: "01_screenshot\(suffix)",
                    locale: locale.folder
                )
            }
        }

        My.currentLocalization = nil
    }

}
