import SwiftUI

public struct FrostedCardStyle: ViewModifier {

    public init() {}

    public func body(content: Content) -> some View {
        content
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 8)
    }

}

#Preview {
    VStack {
        Text("hi")
        Text("there")
    }
    .modifier(FrostedCardStyle())
}

#Preview {
    VStack {
        Text("hi")
        Text("there")
    }
    .modifier(FrostedCardStyle())
    .preferredColorScheme(.dark)
}
