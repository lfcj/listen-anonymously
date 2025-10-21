import SwiftUI

struct SafeImage: View {
    let name: String
    let fontSize: CGFloat
    let size: CGSize
    let foregroundColor: Color

    init(
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

    var body: some View {
        if UIImage(systemName: name) != nil {
            Image(systemName: name)
                .font(.system(size: fontSize))
                .foregroundStyle(foregroundColor)
                .frame(width: size.width, height: size.height)
        } else {
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
