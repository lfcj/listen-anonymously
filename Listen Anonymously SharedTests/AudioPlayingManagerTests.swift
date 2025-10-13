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

        // Thu 1st. May 2025 at 14:27"
        #expect(manager.audioTitle?.contains("Thu") == true)
        #expect(manager.audioTitle?.contains("1st") == true)
        #expect(manager.audioTitle?.contains("May") == true)
        #expect(manager.audioTitle?.contains("2025 at") == true)
        #expect(manager.audioTitle?.contains(":27") == true)
        #expect(manager.canPlay == true)
    }

}
