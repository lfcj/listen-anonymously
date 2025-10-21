import Listen_Anonymously_Shared
import SwiftUI

struct InstructionsStepsView: View {
    var body: some View {
        VStack {
            TextAndIconLabel(
                title: "1. Select your message",
                systemNameOrEmoji: "hand.tap.fill"
            )
            .fontWeight(.medium)

            TextAndIconLabel(
                title: "2. Tap on 'Forward'",
                systemNameOrEmoji: "arrowshape.turn.up.forward.fill"
            )
            .fontWeight(.medium)

            TextAndIconLabel(
                title: "3. Tap on 'Share'",
                systemNameOrEmoji: "square.and.arrow.up"
            )
            .fontWeight(.medium)

            TextAndIconLabel(
                title: "4. Scroll down and tap on:",
                systemNameOrEmoji: "hand.tap.fill"
            )
            .fontWeight(.medium)

            ListenAnonExtensionView()

            Spacer()
        }
    }
}
