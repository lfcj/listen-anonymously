import SwiftUI

public extension LinearGradient {

    static var lavenderToPastelBlue: LinearGradient {
        LinearGradient(
            colors: [
                .lavender,
                .violetLavender,
                .pastelBlue
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

}

#Preview {
    ZStack {
        LinearGradient.lavenderToPastelBlue
            .ignoresSafeArea()
        Text("Hi")
            .foregroundStyle(.white)
    }
}

#Preview {
    ZStack {
        LinearGradient.lavenderToPastelBlue
            .ignoresSafeArea()
        Text("Hi")
            .foregroundStyle(.white)
    }
    .preferredColorScheme(.dark)
}
