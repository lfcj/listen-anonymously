import Listen_Anonymously_Shared
import SwiftUI

struct WhatsAppInstructionsStepsView: View {
    var body: some View {
        VStack {
            TextAndIconLabel(
                title: "1. Long tap on your voice note on WhatsApp",
                systemNameOrEmoji: "hand.tap.fill"
            )
            .fontWeight(.medium)

            TextAndIconLabel(
                title: "2. Tap on 'Forward'",
                systemNameOrEmoji: "arrowshape.turn.up.forward"
            )
            .fontWeight(.medium)

            TextAndIconLabel(
                title: "3. Tap on the 'Share' icon at the bottom right",
                systemNameOrEmoji: "square.and.arrow.up"
            )
            .fontWeight(.medium)

            TextAndIconLabel(
                title: "4. Scroll down and tap on:",
                systemNameOrEmoji: "hand.tap.fill"
            )
            .fontWeight(.medium)
            .accessibilityIdentifier(AccessibilityIdentifier.Instructions.whatsAppStep4)

            ListenAnonExtensionView()

            Spacer()
        }
    }
}

#Preview {
    WhatsAppInstructionsStepsView()
        .padding()
        .background(LinearGradient.lavenderToPastelBlue)
}
