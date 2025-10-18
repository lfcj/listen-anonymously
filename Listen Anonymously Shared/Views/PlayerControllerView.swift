import AVFAudio
import Combine
import SwiftUI

struct PlayerControllerView: View {
    
    @ObservedObject var playingManager: AudioPlayingManager

    @State private var currentTime: Double = 0
    @State private var timerCancellable: Cancellable?

    @State private var sliderColor = Color.la_teal

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var backImageName: String {
        if #available(iOS 18, *) {
            "10.arrow.trianglehead.counterclockwise"
        } else {
            "gobackward.10"
        }
    }
    var forwardImageName: String {
        if #available(iOS 18, *) {
            "10.arrow.trianglehead.clockwise"
        } else {
            "goforward.10"
        }
    }
    
    func formatSecond(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    var body: some View {
        VStack {
            Slider(
                value: $currentTime,
                in: 0...playingManager.duration,
                onEditingChanged: { isEditing in
                    sliderColor = isEditing ? .la_magenta : .la_teal
                    playingManager.setPlayerPosition(currentTime)
                }
            )
            .tint(sliderColor)
            HStack {
                Text(formatSecond(Int(currentTime)))
                    .font(.title)
                
                Spacer()
                Text(formatSecond(Int(playingManager.duration - currentTime)))
                    .font(.title)
            }
            HStack(spacing: 10) {
                PlayingViewButton(
                    imageName: backImageName,
                    size: CGSize(width: 40, height: 40),
                    action: {}
                )
                
                PlayingViewButton(
                    imageName: playingManager.isPlaying ? "pause.fill" : "play.fill",
                    size: CGSize(width: 100, height: 80),
                    action: {
                        if !playingManager.isPlaying {
                            startTimer()
                            startPlaying()
                        } else {
                            stopTimer()
                            stopPlaying()
                        }
                })
                
                PlayingViewButton(imageName: forwardImageName, size: CGSize(width: 40, height: 40), action: {})
            }
        }.onDisappear {
            playingManager.pause()
        }
    }
}

private extension PlayerControllerView {

    func startTimer() {
        // Reset the timer and start receiving updates
        timerCancellable = timer.sink { _ in
            self.currentTime += 1
            checkIfCurrentTimeIsOver()
        }
    }

    func checkIfCurrentTimeIsOver() {
        guard currentTime >= playingManager.duration else {
            return
        }
        stopTimer()
        stopPlaying()
    }

    func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    func startPlaying() {
        if currentTime == playingManager.duration {
            currentTime = 0
            playingManager.setPlayerPosition(currentTime)
        }
        playingManager.play()
    }

    func stopPlaying() {
        playingManager.pause()
    }
}

#Preview {
    let audioPlayingManager = AudioPlayingManager(
        extensionContext: nil,
        duration: 19,
        url: Bundle.main.url(forResource: "AUDIO-2024-02-23-14-21-50", withExtension: "mp3")!
    )

    PlayerControllerView(playingManager: audioPlayingManager)
}
