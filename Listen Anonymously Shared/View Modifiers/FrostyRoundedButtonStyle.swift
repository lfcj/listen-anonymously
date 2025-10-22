import SwiftUI

public struct FrostyRoundedButtonStyle: ButtonStyle {

    public init(fullWidth: Bool = false) {
        self.fullWidth = fullWidth
    }

    var fullWidth: Bool

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.medium))
            .foregroundColor(.white)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white.opacity(0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.06), lineWidth: 0.5)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 6)
    }

}

#Preview("Light") {
    ZStack {
        Color.laPurple.ignoresSafeArea()
        Button("Hello, World!") {}
            .frame(minHeight: 50)
            .buttonStyle(FrostyRoundedButtonStyle())
    }.preferredColorScheme(.light)
}

#Preview("Dark") {
    ZStack {
        Color.laPurple.ignoresSafeArea()
        Button("Hello, World!") {}
            .frame(minHeight: 50)
            .buttonStyle(FrostyRoundedButtonStyle())
    }
    .preferredColorScheme(.dark)
}
