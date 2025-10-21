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

    static var deepNightBlueToMidnight: LinearGradient {
        LinearGradient(
            colors: [Color(hex: 0x0B004B), Color(hex: 0x1B0079)],
            startPoint: .top,
            endPoint: .bottom
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
