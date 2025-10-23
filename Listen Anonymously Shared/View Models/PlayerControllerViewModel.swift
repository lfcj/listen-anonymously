import Combine
import Foundation

open class PlayerControllerViewModel: ObservableObject {

    // MARK: - Properties

    @Published var currentTime: Double = 0
    @Published var isPlaying: Bool = false

    var duration: Double {
        playingManager.duration
    }

    var currentTimeString: String {
        formatSecond(Int(currentTime))
    }

    var remainingTimeString: String {
        formatSecond(Int(duration - currentTime))
    }

    // MARK: - Private Properties

    private let playingManager: AudioPlayingManager
    private(set) var timerCancellable: Cancellable?

    private let timer: AnyPublisher<Date, Never>

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    public init(
        playingManager: AudioPlayingManager,
        timerPublisher: AnyPublisher<Date, Never> = Timer.publish(every: 1, on: .main, in: .common).autoconnect().eraseToAnyPublisher(),
        currentTime: TimeInterval = 0
    ) {
        self.playingManager = playingManager
        self.timer = timerPublisher
        self.currentTime = currentTime

        playingManager.$isPlaying
            .assign(to: \.isPlaying, on: self)
            .store(in: &cancellables)
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

    func forward10Seconds() {
        let newTime = currentTime + 10.0

        // Ensure the new time does not exceed the audio duration
        if newTime < duration {
            currentTime = newTime
            setPlayerPosition()
        } else {
            stopTimer()
            stopPlaying()
            currentTime = duration
        }
    }

    func rewind10Seconds() {
        let newTime = currentTime - 10.0

        // Ensure the new time does not exceed the audio duration
        if newTime >= 0 {
            currentTime = newTime
            setPlayerPosition()
        } else {
            currentTime = 0
            setPlayerPosition()
        }
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
