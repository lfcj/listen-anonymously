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

}
