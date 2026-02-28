import Listen_Anonymously_Shared
import SwiftUI

struct TelegramInstructionsStepsView: View {
    var body: some View {
        VStack {
            TranslucentIconAndText(
                title: My.localizedString("TELEGRAM_STEP_1"),
                systemNameOrEmoji: "hand.tap.fill"
            )
            .fontWeight(.medium)

            TranslucentIconAndText(
                title: My.localizedString("TELEGRAM_STEP_2"),
                systemNameOrEmoji: "checkmark.circle"
            )
            .fontWeight(.medium)
            .accessibilityIdentifier(AccessibilityIdentifier.Instructions.telegramStep2)

            TranslucentIconAndText(
                title: My.localizedString("TELEGRAM_STEP_3"),
                systemNameOrEmoji: "square.and.arrow.up"
            )
            .fontWeight(.medium)

            TranslucentIconAndText(
                title: My.localizedString("SCROLL_DOWN_AND_TAP"),
                systemNameOrEmoji: ""
            )
            .fontWeight(.medium)

            ListenAnonExtensionView()

            Spacer()
        }
    }
}

#Preview {
    TelegramInstructionsStepsView()
        .padding()
        .background(LinearGradient.lavenderToPastelBlue)
}
