import SwiftUI

struct PostLaunchScreenView: View {
    var body: some View {
        ZStack {
            Color.launchscreenBackground.ignoresSafeArea()
            Image(systemName: "xmark")
        }
    }
}

private extension Color {
    static var launchscreenBackground: Color { Color("LaunchScreenBackgroundColor") }
}
