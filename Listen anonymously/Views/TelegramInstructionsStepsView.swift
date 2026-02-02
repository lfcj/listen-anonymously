import Listen_Anonymously_Shared
import SwiftUI

struct TelegramInstructionsStepsView: View {
    var body: some View {
        VStack {
            TextAndIconLabel(
                title: "1. Long tap on your voice note on Telegram",
                systemNameOrEmoji: "hand.tap.fill"
            )
            .fontWeight(.medium)

            TextAndIconLabel(
                title: "2. Tap on 'Select'",
                systemNameOrEmoji: "checkmark.circle"
            )
            .fontWeight(.medium)

            TextAndIconLabel(
                title: "3. Tap on the 'Share' icon in the middle bottom",
                systemNameOrEmoji: "square.and.arrow.up"
            )
            .fontWeight(.medium)

            TextAndIconLabel(
                title: "4. Scroll down and tap on:",
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
