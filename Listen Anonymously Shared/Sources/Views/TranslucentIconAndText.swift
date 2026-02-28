import SwiftUI

public struct TranslucentIconAndText: View {
    let title: String
    let systemNameOrEmoji: String

    public init(title: String, systemNameOrEmoji: String) {
        self.title = title
        self.systemNameOrEmoji = systemNameOrEmoji
    }

    public var body: some View {
        HStack {
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
            Text(title)
                .font(.title2)
                .padding([.trailing])
                .foregroundStyle(.white)

            Spacer()
        }
        .padding([.bottom])
    }

}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color(hex: 0x0B004B), Color(hex: 0x1B0079)],
            startPoint: .top,
            endPoint: .bottom
        ).ignoresSafeArea()

        TranslucentIconAndText(title: "This is a test", systemNameOrEmoji: "house.fill")
    }
}
