import SwiftUI

struct BorderedOrGlass: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content.buttonStyle(.glass)
        } else {
            content.buttonStyle(.borderedProminent)
        }
    }
}

extension View {
    func borderedOrGlassButtonStyle() -> some View {
        self.modifier(BorderedOrGlass())
    }
}
