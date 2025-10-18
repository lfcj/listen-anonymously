import AVFAudio
import SwiftUI

public struct AudioPlayingView: View {
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
                PlayerControllerView(playingManager: playingManager)
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
}

#Preview {
    AudioPlayingView(playingManager: AudioPlayingManager(extensionContext: nil))
}
