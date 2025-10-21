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
                buttonLabel
            }
        )
        .background(backgroundStack)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .lavender.opacity(0.1), radius: 20)
    }

    @ViewBuilder
    private var buttonLabel: some View {
        Image(systemName: imageName)
            .font(.system(size: size.width / 2))
            .frame(width: size.width, height: size.height)
            .foregroundStyle(tintGradient)
    }

    @ViewBuilder
    private var backgroundStack: some View {
        backgroundGradient
            .blur(radius: colorScheme == .dark ? 8 : 0)
            .background(.ultraThinMaterial)
    }

    private var tintGradient: LinearGradient {
        let colors: [Color]
        if colorScheme == .dark {
            colors = [
                Color.white.opacity(0.9),
                Color.white.opacity(0.7)
            ]
        } else {
            colors = [
                Color(hex: 0xE11075).opacity(0.7),
                Color(hex: 0x3700A4).opacity(0.7)
            ]
        }

        return LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var backgroundGradient: LinearGradient {
        let colors: [Color]
        if colorScheme == .dark {
            colors = [
                Color(hex: 0xE11075).opacity(0.7),
                Color(hex: 0x3700A4).opacity(0.7)
            ]
        } else {
            colors = [
                .white.opacity(0.4),
                .white.opacity(0.2)
            ]
        }

        return LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
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
