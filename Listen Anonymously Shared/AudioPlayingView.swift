import AVFAudio
import SwiftUI

//struct AudioPlayingView: View {
//    @EnvironmentObject var playingManager: AudioPlayingManager
//
//    public var body: some View {
//        ZStack {
//            VStack {
//                Spacer()
//                PlayingAnimationView(isPlaying: $playingManager.isPlaying)
//                Spacer()
//                PlayerControllerView()
//                    .padding(.bottom)
//                    .padding(.leading)
//                    .padding(.trailing)
//                    .disabled(!playingManager.canPlay)
//                    
//            }
//            .blur(radius: playingManager.isPlayerNotUsable ? 2 : 0)
//            .navigationTitle(playingManager.audioTitle ?? "")
//
//            if playingManager.isLoadingAudio {
//                AudioLoadingView()
//            } else if let errorMessage = playingManager.errorMessage {
//                ErrorMessageView(errorMessage: errorMessage)
//            }
//        }
//    }
//}
//
//#Preview {
//    let audioPlayingManager = AudioPlayingManager(
//        extensionContext: nil,
//        canPlay: true,
//        isLoadingAudio: false,
//        errorMessage: nil,
//        duration: 19,
//        url: Bundle.main.url(forResource: "AUDIO-2024-02-23-14-21-50", withExtension: "mp3")!
//    )
//
//    AudioPlayingView().environmentObject(audioPlayingManager)
//}
