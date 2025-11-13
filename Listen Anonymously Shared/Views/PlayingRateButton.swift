import SwiftUI

struct RateButton: View {
    let action: () -> Void
    let title: String

    var body: some View {
        Button(
            action: action,
            label: {
                Text(title)
                    .foregroundStyle(.laPurpleText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
        )
        .borderedOrGlassButtonStyle()
    }
}
