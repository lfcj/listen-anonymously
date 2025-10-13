import Combine
import Testing
@testable import Listen_Anonymously_Shared

struct AudioPlayingManagerTests {

    @Test("Calling findAudio marks isLoadingAudio to true")
    func findAudio_marksIsLoadingAudioProperty() async throws {
        let manager = AudioPlayingManager(extensionContext: FakeExtensionContext())

        #expect(manager.isLoadingAudio == false, "Initial value should be false")

        await manager.findAudio()

        #expect(manager.isLoadingAudio == true, "isLoadingAudio should be true when it is finding audio")
    }

    @Test("Empty extensionContext stops audio search and shows error message")
    func emptyExtensionContext_stopsAudioSearchAndShowsErrorMessage() async throws {
        let manager = AudioPlayingManager(extensionContext: nil)
        
        await manager.findAudio()

        #expect(manager.errorMessage == "No audio file could be find. Please check you selected only one file.")

    }

    @Test("extensionContext with invalid item shows a FindingAudioError")
    func invalidItem_triggersFindingAudioError() async throws {
        let expectedLocalizedErrorMessage = "This is an error that needs localization"
        let manager = AudioPlayingManager(extensionContext: FakeExtensionContext.invalidItemsContext)

        await manager.findAudio()

        #expect(manager.isLoadingAudio == false)
        #expect(manager.errorMessage == expectedLocalizedErrorMessage)
    }

    @Test("extensionContext with valid item can play and sets title")
    func validItem_setsAudioURLAndFilename() async throws {
        let manager = AudioPlayingManager(extensionContext: FakeExtensionContext.validItemsContext)

        await manager.findAudio()

        #expect(manager.audioTitle?.contains("Thu") == true)
        #expect(manager.audioTitle?.contains("1st") == true)
        #expect(manager.audioTitle?.contains("May") == true)
        #expect(manager.audioTitle?.contains("2025 at") == true)
        #expect(manager.audioTitle?.contains(":27") == true)
        #expect(manager.canPlay == true)
    }

    @Test("extensionContext with valid item but dummy audio file shows error")
    func validItemButDummyAudio_producesErrors() async throws {
        let manager = AudioPlayingManager(extensionContext: FakeExtensionContext.validItemsContext)

        await manager.findAudio()

        #expect(manager.errorMessage?.hasPrefix("Could not get duration") == true)
    }

    @Test("extensionContext with valid item and real audio file shows no error and sets duration")
    func validItemAndValidAudio_producesNoErrors() async throws {
        let manager = AudioPlayingManager(extensionContext: FakeExtensionContext.realAudioItemsContext)

        let durationValues = manager.$duration.values

        await manager.findAudio()

        for await duration in durationValues {
            if duration > 0 {
                break
            }
        }

        #expect(manager.errorMessage == nil)
        #expect(Int(manager.duration) == 19)
    }

}
