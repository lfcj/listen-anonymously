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
        .background(
            backgroundGradient
                .blur(radius: colorScheme == .dark ? 8 : 0)
                .background(.ultraThinMaterial)
        )
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

    private var tintGradient: LinearGradient {
       LinearGradient(
            colors: [.iconButtonForegroundStart, .iconButtonForegroundEnd],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [.iconButtonBackgroundStart, .iconButtonBackgroundEnd],
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
