import Combine
import Foundation

open class PlayerControllerViewModel: ObservableObject {

    // MARK: - Properties

    @Published var currentTime: Double = 0

    var duration: Double {
        playingManager.duration
    }

    var currentTimeString: String {
        formatSecond(Int(currentTime))
    }

    var remainingTimeString: String {
        formatSecond(Int(duration - currentTime))
    }

    var isPlaying: Bool {
        playingManager.isPlaying
    }

    // MARK: - Private Properties

    private let playingManager: AudioPlayingManager
    private(set) var timerCancellable: Cancellable?

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // MARK: - Init

    init(playingManager: AudioPlayingManager) {
        self.playingManager = playingManager
    }

    // MARK: - Accessible Methods

    func setPlayerPosition() {
        playingManager.setPlayerPosition(currentTime)
    }

    func playOrPause() {
        if !isPlaying {
            startTimer()
            startPlaying()
        } else {
            stopTimer()
            stopPlaying()
        }
    }

    func pause() {
        playingManager.pause()
    }

    // MARK: - Private Methods

    private func startTimer() {
        // Reset the timer and start receiving updates
        timerCancellable = timer.sink { [weak self] _ in
            self?.currentTime += 1
            self?.checkIfCurrentTimeIsOver()
        }
    }

    private func checkIfCurrentTimeIsOver() {
        guard currentTime >= playingManager.duration else {
            return
        }
        stopTimer()
        stopPlaying()
    }

    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    private func startPlaying() {
        if currentTime == playingManager.duration {
            currentTime = 0
            playingManager.setPlayerPosition(currentTime)
        }
        playingManager.play()
    }

    private func stopPlaying() {
        playingManager.pause()
    }

    private func formatSecond(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }

}
