import AVFoundation
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

    @Test("Playing deactivates the audio session")
    func playing_deactivatesAudioSession() async throws {
        let manager = AudioPlayingManager(extensionContext: FakeExtensionContext.realAudioItemsContext)
        
        await manager.findAudio()
        let avSessionSpy = AVAudioSessionSpy()
        manager.play(audioSession: avSessionSpy)
        
        #expect(avSessionSpy.setActiveToFalseCalls == 1)
        #expect(avSessionSpy.setActiveToTrueCalls == 1)
        #expect(avSessionSpy.setCategoryCalls == 1)
        #expect(manager.isPlaying == true)
    }

    @Test("Error is shown when player could not be created")
    func player_isNotCratedWhenSessionSetupFails() async throws {
        let manager = AudioPlayingManager(extensionContext: FakeExtensionContext.realAudioItemsContext)
        
        await manager.findAudio()
        let avSessionSpy = AVAudioSessionSpy()
        avSessionSpy.setActiveError = NSError(domain: "player_isNotCratedWhenSessionSetupFails error", code: 400)
        manager.play(audioSession: avSessionSpy)
        
        #expect(manager.errorMessage != nil)
        #expect(manager.errorMessage?.contains("Could create audio player") == true)
        #expect(manager.isPlaying == false)
    }

    @Test("Player is not usable when it is loading")
    func player_isNotUsableWhenItIsLoading() throws {
        let manager = AudioPlayingManager(extensionContext: FakeExtensionContext.realAudioItemsContext, canPlay: true, isLoadingAudio: true)

        #expect(manager.isPlayerNotUsable == true)
    }

    @Test("Player is not usable when there is an error")
    func player_isNotUsableWhenThereIsAnError() async throws {
        let manager = AudioPlayingManager(extensionContext: FakeExtensionContext.invalidItemsContext, canPlay: true, isLoadingAudio: true)

        await manager.findAudio()

        #expect(manager.isPlayerNotUsable == true)
    }

    @Test("Player is not usable when it cannot play")
    func player_isNotUsableWhenCanNotPlayDueToLackOfAudioData() async throws {
        let manager = AudioPlayingManager(extensionContext: FakeExtensionContext.invalidItemsContext)

        await manager.findAudio()

        #expect(manager.canPlay == false)
        #expect(manager.isPlayerNotUsable == true)
    }

    @Test("Player is usable when a valid audio URL is loaded")
    func player_isUsableWhenPlayerIsReady() async throws {
        let manager = AudioPlayingManager(extensionContext: FakeExtensionContext.realAudioItemsContext)

        await manager.findAudio()

        #expect(manager.isPlayerNotUsable == false)
    }

    @Test("Pause sets isPlaying to false")
    func player_setsIsPlayingToFalseWhenPaused() {
        let manager = AudioPlayingManager(extensionContext: FakeExtensionContext.realAudioItemsContext)
        manager.isPlaying = true

        manager.pause()

        #expect(manager.isPlaying == false)
    }

    @Test("Setting player position does not crash")
    func setting_playerPosition_doesNotCrash() {
        let manager = AudioPlayingManager(extensionContext: FakeExtensionContext.realAudioItemsContext)
        manager.play()
        manager.setPlayerPosition(200)
    }

    @Test("Trying a second time resets the error message")
    func player_resetsErrorMessageOnSecondAttempt() async throws {
        let manager = AudioPlayingManager(extensionContext: nil)
        
        await manager.findAudio()

        #expect(manager.errorMessage != nil)

        await manager.findAudio()
    }

}

final class AVAudioSessionSpy: AudioSessionProtocol, @unchecked Sendable {

    
    var setActiveError: Error?
    private(set) var setActiveToFalseCalls: Int = 0
    private(set) var setActiveToTrueCalls: Int = 0
    private(set) var setCategoryCalls: Int = 0

    func setActive(_ active: Bool, options: AVAudioSession.SetActiveOptions = []) throws {
        if let setActiveError {
            throw setActiveError
        }
        if active {
            setActiveToTrueCalls += 1
        } else {
            setActiveToFalseCalls += 1
        }
    }

    func setCategory(_ category: AVAudioSession.Category, mode: AVAudioSession.Mode, options: AVAudioSession.CategoryOptions) throws {
        setCategoryCalls += 1
    }
}
