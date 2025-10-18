import AVFAudio
import Combine
import SwiftUI

struct PlayerControllerView: View {
    
    @ObservedObject var viewModel: PlayerControllerViewModel

    @State private var sliderColor = Color.la_teal

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
    
    var body: some View {
        VStack {
            Slider(
                value: $viewModel.currentTime,
                in: 0...viewModel.duration,
                onEditingChanged: { isEditing in
                    sliderColor = isEditing ? .la_magenta : .la_teal
                    viewModel.setPlayerPosition()
                }
            )
            .tint(sliderColor)
            HStack {
                Text(viewModel.currentTimeString)
                    .font(.title)
                
                Spacer()
                Text(viewModel.remainingTimeString)
                    .font(.title)
            }
            HStack(spacing: 10) {
                PlayingViewButton(
                    imageName: backImageName,
                    size: CGSize(width: 40, height: 40),
                    action: viewModel.rewind10Seconds
                )
                
                PlayingViewButton(
                    imageName: viewModel.isPlaying ? "pause.fill" : "play.fill",
                    size: CGSize(width: 100, height: 80),
                    action: viewModel.playOrPause
                )
                
                PlayingViewButton(
                    imageName: forwardImageName,
                    size: CGSize(width: 40, height: 40),
                    action: viewModel.forward10Seconds
                )
            }
        }.onDisappear {
            viewModel.pause()
        }
    }
}

#Preview {
    let audioPlayingManager = AudioPlayingManager(
        extensionContext: nil,
        duration: 19,
        url: Bundle.main.url(forResource: "AUDIO-2024-02-23-14-21-50", withExtension: "mp3")!
    )

    PlayerControllerView(viewModel: PlayerControllerViewModel(playingManager: audioPlayingManager))
}
