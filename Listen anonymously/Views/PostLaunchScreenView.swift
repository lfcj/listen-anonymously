import SwiftUI

struct PostLaunchScreenView: View {
    @State private var isAnimating = false
    @State private var showHeadphones = false
    @State private var isAnimatingHeadphones = false
    var body: some View {
        ZStack {
            Color.launchscreenBackground.ignoresSafeArea()

            GeometryReader { geometry in
                Image("launchscreenSVG")
                    .resizable()
                    .frame(maxWidth: geometry.size.width / 3, maxHeight: geometry.size.width / 3)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0)) // Full rotation
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .animation(
                        Animation.bouncy,
                        value: isAnimating
                    )
                    .onAppear {
                        isAnimating = true

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            showHeadphones = true
                        }
                    }

                if showHeadphones {
                    Image("headphones")
                        .resizable()
                        .frame(maxWidth: geometry.size.width / 1.5, maxHeight: geometry.size.width / 2)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2 - 30)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.spring(response: 0.7, dampingFraction: 0.4), value: isAnimatingHeadphones)
                        .offset(y: isAnimatingHeadphones ? 0 : -geometry.size.height * 0.6)
                        .opacity(isAnimatingHeadphones ? 1 : 0)
                        .onAppear {
                            isAnimatingHeadphones = true
                        }
                }
            }
        }
    }
}

#Preview {
    PostLaunchScreenView()
        .preferredColorScheme(.dark)
}
