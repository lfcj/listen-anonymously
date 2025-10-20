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
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .foregroundStyle(.white)
            .background(backgroundView)
            .overlay { overlayStroke }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: shadowColor, radius: 10, y: 2)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.25), value: colorScheme)
    }

    // MARK: - Subviews

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

    private var overlayStroke: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .stroke(
                colorScheme == .dark ?
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.35),
                            Color(hex: 0xE11075).opacity(0.4)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    :
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.8),
                            Color.white.opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                lineWidth: 1.2
            )
    }

    private var shadowColor: Color {
        colorScheme == .dark ?
            Color(hex: 0xE11075).opacity(0.5) :
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
