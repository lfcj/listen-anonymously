import SwiftUI

struct PlayingViewButton: View {
    @Environment(\.colorScheme) var colorScheme
    let imageName: String
    let size: CGSize
    let action: () -> Void
    var body: some View {
        Button(
            action: action,
            label: {
                Image(systemName: imageName)
                    .font(.system(size: size.width / 2))
                    .frame(width: size.width, height: size.height)
                    .tint(tint)
            }
        )
        .background(backgroundView)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .lavender.opacity(0.1), radius: 20)
    }

    private var tint: LinearGradient {
        if colorScheme == .dark {
            LinearGradient(
                colors: [
                    Color.white.opacity(0.9),
                    Color.white.opacity(0.7)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            LinearGradient(
                colors: [
                    Color(hex: 0xE11075).opacity(0.7),
                    Color(hex: 0x3700A4).opacity(0.7)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    private var backgroundView: some View {
        Group {
            if colorScheme == .dark {
                LinearGradient(
                    colors: [
                        Color(hex: 0xE11075).opacity(0.7),
                        Color(hex: 0x3700A4).opacity(0.7)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .blur(radius: 8)
                .background(.ultraThinMaterial)
            } else {
                LinearGradient(
                    colors: [
                        .white.opacity(0.4),
                        .white.opacity(0.2)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .background(.ultraThinMaterial)
            }
        }
    }

}

#Preview {
    ZStack {
        LinearGradient.lavenderToPastelBlue
            .ignoresSafeArea()
        PlayingViewButton(
            imageName: "10.arrow.trianglehead.counterclockwise",
            size: CGSize(width: 150, height: 150),
            action: {}
        )
    }
    .preferredColorScheme(.light)
}

#Preview {
    ZStack {
        LinearGradient.lavenderToPastelBlue
            .ignoresSafeArea()
        PlayingViewButton(
            imageName: "10.arrow.trianglehead.counterclockwise",
            size: CGSize(width: 150, height: 150),
            action: {}
        )
    }
    .preferredColorScheme(.dark)
}
