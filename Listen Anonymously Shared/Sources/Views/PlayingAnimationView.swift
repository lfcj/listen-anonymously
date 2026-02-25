import SwiftUI

public struct PlayingAnimationView: View {
    @Binding var isPlaying: Bool
    @State private var scale: CGFloat = 2.5
    @State private var color = Color.laPurple

    public var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.laMagenta, .laPurple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 80)
            Image("anon-icon", bundle: Bundle(for: AudioPlayingManager.self))
                .resizable()
                .renderingMode(.template)
                .frame(width: 40, height: 40)
                .foregroundStyle(.white)
                .aspectRatio(contentMode: .fit)
        }
        .scaleEffect(scale)
        .transition(Twirl())
        .onChange(of: isPlaying) {
            if isPlaying {
                startBouncing()
            } else {
                stopBouncing()
            }
        }
    }

    private func startBouncing() {
        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            scale = 3.5
            color = .laPurple
        }
    }

    private func stopBouncing() {
        withAnimation(.easeInOut(duration: 0.5)) {
            scale = 2.5
            color = .laMagenta
        }
    }

}
#Preview {
    @Previewable @State var isPlaying = false
    VStack {
        Spacer()
        PlayingAnimationView(isPlaying: $isPlaying)

        Spacer()
        Button(isPlaying ? "Stop" : "Play") {
            isPlaying.toggle()
        }
        .padding()
    }

}

struct Twirl: Transition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .scaleEffect(phase.isIdentity ? 1 : 0.5)
            .opacity(phase.isIdentity ? 1 : 0)
            .blur(radius: phase.isIdentity ? 0 : 10)
            .rotationEffect(
                .degrees(
                    phase == .willAppear ? 360 :
                        phase == .didDisappear ? -360 : .zero
                )
            )
            .brightness(phase == .willAppear ? 1 : 0)
    }
}
