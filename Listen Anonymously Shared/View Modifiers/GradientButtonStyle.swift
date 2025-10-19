import SwiftUI

public struct GradientButtonStyle: ButtonStyle {

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.buttonStart, .buttonEnd]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(24)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .shadow(
                color: .buttonShadow.opacity(configuration.isPressed ? 0.18 : 0.28),
                radius: configuration.isPressed ? 6 : 18, x: 0, y: 8
            )
            .foregroundColor(.white)
            .padding(.horizontal, 8)
    }

}

struct GradientButtonStyleLight_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button("Hello, World!") {}
                .buttonStyle(GradientButtonStyle())
        }.preferredColorScheme(.light)
    }
}

struct GradientButtonStyleDark_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button("Hello, World!") {}
                .buttonStyle(GradientButtonStyle())
        }
        .preferredColorScheme(.dark)
    }
}
