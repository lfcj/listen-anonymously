import AVFoundation
import Combine
import Testing
@testable import Listen_Anonymously_Shared

struct PlayerControllerViewModelTests {

    @Test func initialCurrentTime_isZero() {
        let viewModel = PlayerControllerViewModel(
            playingManager: AudioPlayingManager(extensionContext: nil)
        )

        #expect(viewModel.currentTime == 0)
    }

    @Test func currentTimeString_reflectsCurrentTime() {
        let viewModel = PlayerControllerViewModel(
            playingManager: AudioPlayingManager(extensionContext: nil)
        )

        #expect(viewModel.currentTimeString == "00:00")

        viewModel.currentTime = 22324

        #expect(viewModel.currentTimeString == "372:04")
    }

    @Test func duration_reflectsAudioPlayerManagerDuration() {
        let manager = AudioPlayingManager(extensionContext: nil)
        let viewModel = PlayerControllerViewModel(playingManager: manager)

        #expect(viewModel.duration == manager.duration)

        let expectedDuration: Double = 22324
        manager.duration = expectedDuration

        #expect(viewModel.duration == expectedDuration)
    }

    @Test func remainingTimeStringIsDurationMinusCurrentTime() {
        let manager = AudioPlayingManager(extensionContext: nil)
        let viewModel = PlayerControllerViewModel(playingManager: manager)

        manager.duration = 100
        viewModel.currentTime = 25
        #expect(viewModel.remainingTimeString == "01:15")
    }

    @Test func isPlaying_reflectsAudioPlayingManagerIsPlaying() {
        let manager = AudioPlayingManager(extensionContext: nil)
        let viewModel = PlayerControllerViewModel(playingManager: manager)
        
        #expect(!viewModel.isPlaying)

        manager.isPlaying = true

        #expect(viewModel.isPlaying)
    }

    @Test func setPlayerPosition_callsPlayingManagerSetPlayerPosition() {
        let spyManager = SpyAudioPlayingManager(extensionContext: nil)
        let viewModel = PlayerControllerViewModel(playingManager: spyManager)

        let expectedSetCurrentTime: Double = 25
        viewModel.currentTime = expectedSetCurrentTime
        viewModel.setPlayerPosition()
        
        #expect(spyManager.setPlayerPositionCalls == 1)
        #expect(spyManager.spiedPlayerCurrentTime == expectedSetCurrentTime)
    }

    @Test func viewModel_playsAudioWhenPlayPressed() {
        let spyManager = SpyAudioPlayingManager(extensionContext: FakeExtensionContext.realAudioItemsContext)
        let viewModel = PlayerControllerViewModel(playingManager: spyManager)

        viewModel.playOrPause()

        #expect(spyManager.playCalls == 1)
        #expect(viewModel.timerCancellable != nil)
    }

    @Test func viewModel_pausesAudioWhenPausePressed() {
        let spyManager = SpyAudioPlayingManager(extensionContext: FakeExtensionContext.realAudioItemsContext)
        let viewModel = PlayerControllerViewModel(playingManager: spyManager)

        spyManager.isPlaying = true
        viewModel.playOrPause()

        #expect(spyManager.pauseCalls == 1)
        #expect(viewModel.timerCancellable == nil)
    }

    @Test func callingPause_callsAudioPlayingManagerPause() {
        let spyManager = SpyAudioPlayingManager(extensionContext: nil)
        let viewModel = PlayerControllerViewModel(playingManager: spyManager)
        
        viewModel.pause()

        #expect(spyManager.pauseCalls == 1)
    }

}

class SpyAudioPlayingManager: AudioPlayingManager {
    private(set) var setPlayerPositionCalls: Int = 0
    private(set) var spiedPlayerCurrentTime: Double = 0
    private(set) var playCalls: Int = 0
    private(set) var pauseCalls: Int = 0

    override func setPlayerPosition(_ currentTime: Double) {
        setPlayerPositionCalls += 1
        spiedPlayerCurrentTime = currentTime
    }

    override func play(audioSession: any AudioSessionProtocol = AVAudioSession.sharedInstance()) {
        playCalls += 1
        super.play(audioSession: audioSession)
    }

    override func pause() {
        pauseCalls += 1
    }
}
