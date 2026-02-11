import SwiftUI

public enum SafeImageContent: Sendable, Equatable {
    case systemImage(String)
    case text(String)

    public static func resolve(
        name: String,
        systemImageExists: (String) -> Bool = { UIImage(systemName: $0) != nil }
    ) -> SafeImageContent {
        systemImageExists(name) ? .systemImage(name) : .text(name)
    }
}

public struct SafeImage: View {
    let name: String
    let fontSize: CGFloat
    let size: CGSize
    let foregroundColor: Color

    public init(
        name: String,
        fontSize: CGFloat = 48,
        size: CGSize = CGSize(width: 48, height: 48),
        foregroundColor: Color = .white.opacity(0.6)
    ) {
        self.name = name
        self.fontSize = fontSize
        self.size = size
        self.foregroundColor = foregroundColor
    }

    public var body: some View {
        switch SafeImageContent.resolve(name: name) {
        case .systemImage(let name):
            Image(systemName: name)
                .font(.system(size: fontSize))
                .foregroundStyle(foregroundColor)
                .frame(width: size.width, height: size.height)
        case .text(let name):
            Text(name)
                .font(.system(size: fontSize - 2))
                .frame(width: size.width, height: size.height)
        }
    }
}

#Preview {
    let symbols = ["film", "music.note", "airplane", "🍌", "moon", "👰🏻"]
    VStack(spacing: 16) {
        ForEach(symbols, id: \.self) { symbol in
            HStack(spacing: 12) {
                SafeImage(name: symbol)
                    .frame(width: 40, height: 40)
                Spacer()
                SafeLabel(title: symbol, icon: symbol)
            }
            .padding()
            .background(Color.purple)
            .cornerRadius(12)
        }
    }
}
