import SwiftUI

public struct ShadowTranslucentCard: View {

    private let title: String
    private let subtitle: String
    private let systemName: String

    public init(title: String, subtitle: String, systemName: String) {
        self.title = title
        self.subtitle = subtitle
        self.systemName = systemName
    }

    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .opacity(0.9)
            }
            Spacer()
            Image(systemName: systemName)
                .font(.system(size: 28))
                .foregroundStyle(Color.white.opacity(0.95))
                .opacity(0.95)
        }
        .modifier(TranslucentCardStyle())
        .padding(.horizontal, 18)
    }

}

#Preview {
    ZStack {
        LinearGradient.lavenderToPastelBlue.ignoresSafeArea()

        ShadowTranslucentCard(
            title: "This is a card that looks frosty",
            subtitle: "This is the subtitle",
            systemName: "house.fill"
        )
    }
}
