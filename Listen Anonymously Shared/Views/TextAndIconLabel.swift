import SwiftUI

public struct TextAndIconLabel: View {
    let title: String
    let systemNameOrEmoji: String

    public init(title: String, systemNameOrEmoji: String) {
        self.title = title
        self.systemNameOrEmoji = systemNameOrEmoji
    }

    public var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .padding([.trailing])
                .foregroundStyle(.white)

            if !systemNameOrEmoji.isEmpty {
                SafeImage(
                    name: systemNameOrEmoji,
                    fontSize: 20,
                    size: CGSize(width: 20, height: 20),
                    foregroundColor: .white
                )
                .modifier(TranslucentCardStyle())
                .clipShape(Circle())
            }

            Spacer()
        }
        .padding([.bottom])
    }

}

#Preview {
    ZStack {
        LinearGradient.deepNightBlueToMidnight.ignoresSafeArea()

        TextAndIconLabel(title: "This is a test", systemNameOrEmoji: "house.fill")
    }
}
