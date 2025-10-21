import AVFAudio
import SwiftUI

public struct AudioPlayingView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var playingManager: AudioPlayingManager

    public init(playingManager: AudioPlayingManager) {
        self.playingManager = playingManager
    }

    public var body: some View {
        ZStack {
            VStack {
                Spacer()
                PlayingAnimationView(isPlaying: $playingManager.isPlaying)
                Spacer()
                Text("No one will know you hit play 😉")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(colorScheme == .dark ? .white : .laPurple)
                    .modifier(TranslucentCardStyle())
                    .padding()
                PlayerControllerView(
                    viewModel: PlayerControllerViewModel(playingManager: playingManager)
                )
                    .padding(.bottom)
                    .padding(.leading)
                    .padding(.trailing)
                    .disabled(!playingManager.canPlay)
                    
            }
            .blur(radius: playingManager.isPlayerNotUsable ? 2 : 0)
            .navigationTitle(playingManager.audioTitle ?? "")

            if playingManager.isLoadingAudio {
                AudioLoadingView()
            } else if let errorMessage = playingManager.errorMessage {
                ErrorMessageView(errorMessage: errorMessage, onRetry: { [weak playingManager] in
                    Task {
                        await playingManager?.findAudio(isSecondAttempt: true)
                    }
                })
            }
        }
        .background(
            LinearGradient
                .lavenderToPastelBlue
                .opacity(colorScheme == .dark ? 0.9 : 0.6)
        )
    }

}

#Preview {
    let audioPlayingManager = AudioPlayingManager(
        extensionContext: nil,
        canPlay: true,
        isLoadingAudio: false,
        errorMessage: nil,
        duration: 19,
        url: Bundle.main.url(forResource: "AUDIO-2024-02-23-14-21-50", withExtension: "mp3")!
    )

    AudioPlayingView(playingManager: audioPlayingManager)
        .preferredColorScheme(.light)
}

#Preview {
    let audioPlayingManager = AudioPlayingManager(
        extensionContext: nil,
        canPlay: true,
        isLoadingAudio: false,
        errorMessage: nil,
        duration: 19,
        url: Bundle.main.url(forResource: "AUDIO-2024-02-23-14-21-50", withExtension: "mp3")!
    )

    AudioPlayingView(playingManager: audioPlayingManager)
        .preferredColorScheme(.dark)
}
