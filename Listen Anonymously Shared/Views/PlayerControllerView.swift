import AVFAudio
import Combine
import SwiftUI

struct PlayerControllerView: View {
    
    @ObservedObject var viewModel: PlayerControllerViewModel

    @State private var sliderColor = Color.laTeal

    var backImageName: String {
        "10.arrow.trianglehead.counterclockwise"
    }
    var forwardImageName: String {
        "10.arrow.trianglehead.clockwise"
    }

    var body: some View {
        VStack {
            Slider(
                value: $viewModel.currentTime,
                in: 0...viewModel.duration,
                onEditingChanged: { isEditing in
                    sliderColor = isEditing ? .laMagenta : .laTeal
                    viewModel.setPlayerPosition()
                }
            )
            .tint(sliderColor)
            HStack {
                Text(viewModel.currentTimeString)
                    .font(.title)
                
                if viewModel.isPlaying {
                    Spacer()
                    PlayingRateButton(
                        action: viewModel.chooseNextRate,
                        title: viewModel.currentRate.string
                    )
                    Spacer()
                } else {
                    Spacer()
                }
                Text(viewModel.remainingTimeString)
                    .font(.title)
            }
            HStack(spacing: 10) {
                PlayingViewButton(
                    imageName: backImageName,
                    size: CGSize(width: 50, height: 50),
                    action: viewModel.rewind10Seconds
                )

                PlayingViewButton(
                    imageName: viewModel.isPlaying ? "pause.fill" : "play.fill",
                    size: CGSize(width: 120, height: 100),
                    action: viewModel.playOrPause
                )
                
                PlayingViewButton(
                    imageName: forwardImageName,
                    size: CGSize(width: 50, height: 50),
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
        .background(LinearGradient.lavenderToPastelBlue)
}
