import SwiftUI
import Listen_Anonymously_Shared

struct ListenAnonExtensionView: View {
    var body: some View {
        Label {
            Text("Listen anonymously")
        } icon: {
            Image("anon-icon", bundle: Bundle(for: AudioPlayingManager.self))
                .renderingMode(.template)
                .resizable()
                .frame(width: 32, height: 32)
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(.white)
        .padding([.trailing, .leading], 12)
        .padding([.top, .bottom], 8)
        .background(
            RoundedRectangle(cornerSize: CGSize(width: 24, height: 24))
                .fill(.black.opacity(0.4))
        )
    }
}
