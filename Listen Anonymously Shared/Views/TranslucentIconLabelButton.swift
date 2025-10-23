import SwiftUI

public struct TranslucentIconLabelButton: View {

    @Environment(\.colorScheme) var colorScheme
    let title: String
    let icon: String
    var action: () -> Void

    public init(title: String, icon: String, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(3)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .foregroundStyle(colorScheme == .dark ? .white : .laPurple)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: shadowColor, radius: 10, y: 2)
        }
        .borderedOrGlassButtonStyle()
    }

    // MARK: - Subviews

    private var backgroundView: some View {
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

    private var shadowColor: Color {
        Color.black.opacity(0.1)
    }

}

#Preview {
    VStack(spacing: 20) {
        TranslucentIconLabelButton(title: "Buy us a coffee", icon: "cup.and.saucer.fill") {
            print("Tapped!")
        }
        TranslucentIconLabelButton(title: "Send a tip", icon: "heart.fill") {}
    }
    .padding()
    .background(
        LinearGradient.lavenderToPastelBlue
    )
    .preferredColorScheme(.light)
}

#Preview {
    VStack(spacing: 20) {
        TranslucentIconLabelButton(title: "Buy us a coffee", icon: "cup.and.saucer.fill") {}
        TranslucentIconLabelButton(title: "Send a tip", icon: "heart.fill") {}
    }
    .padding()
    .background(
        LinearGradient(
            colors: [Color(hex: 0x0B004B), Color(hex: 0x1B0079)],
            startPoint: .top,
            endPoint: .bottom
        )
    )
    .preferredColorScheme(.dark)
}
