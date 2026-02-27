import Listen_Anonymously_Shared
import SwiftUI

struct WhatsAppInstructionsStepsView: View {
    var body: some View {
        VStack {
            TextAndIconLabel(
                title: My.localizedString("WHATSAPP_STEP_1"),
                systemNameOrEmoji: "hand.tap.fill"
            )
            .fontWeight(.medium)

            TextAndIconLabel(
                title: My.localizedString("WHATSAPP_STEP_2"),
                systemNameOrEmoji: "arrowshape.turn.up.forward"
            )
            .fontWeight(.medium)

            TextAndIconLabel(
                title: My.localizedString("WHATSAPP_STEP_3"),
                systemNameOrEmoji: "square.and.arrow.up"
            )
            .fontWeight(.medium)

            TextAndIconLabel(
                title: My.localizedString("SCROLL_DOWN_AND_TAP"),
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
