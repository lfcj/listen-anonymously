import SwiftUI

struct PostLaunchScreenView: View {
    @State private var isAnimating = false
    @State private var isScaling = false
    @State private var showHeadphones = false
    @State private var isAnimatingHeadphones = false
    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground).ignoresSafeArea()

            GeometryReader { geometry in
                Image("launchscreenSVG")
                    .resizable()
                    .frame(maxWidth: geometry.size.width / 3, maxHeight: geometry.size.width / 3)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .scaleEffect(isScaling ? 1.5 : 1.0) // Pulsing scale
                    .rotationEffect(.degrees(isAnimating ? 360 : 0)) // Full rotation
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .animation(
                        Animation
                            .easeInOut(duration: 2.0),
                        value: isAnimating
                    )
                    .onAppear {
                        isAnimating = true
                        isScaling = true

                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isAnimating = false
                            isScaling = false
                            showHeadphones = true
                        }
                    }

                if showHeadphones {
                    Image("headphones")
                        .resizable()
                        .frame(maxWidth: geometry.size.width / 1.5, maxHeight: geometry.size.width / 2)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2 - 20)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.spring(response: 1.5, dampingFraction: 0.7), value: isAnimatingHeadphones)
                        .offset(y: isAnimatingHeadphones ? 0 : -geometry.size.height * 0.6)
                        .opacity(isAnimatingHeadphones ? 1 : 0)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                isAnimatingHeadphones = true
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    PostLaunchScreenView()
}
