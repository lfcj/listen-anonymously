import SwiftUI
import Listen_Anonymously_Shared

struct DonationButtonsView: View {
    let buyUsCoffee: () -> Void
    let sendGoodVibes: () -> Void
    let superKindTip: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text("Vibe check 💬")
                .font(.title2.weight(.semibold))
                .foregroundColor(.white)

            Text("How much do you love being invisible?")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))

            HStack(spacing: 12) {
                TranslucentIconLabelButton(
                    title: "Buy us a coffee",
                    icon: "cup.and.saucer.fill",
                    action: buyUsCoffee
                )
                .accessibilityIdentifier(AccessibilityIdentifier.Donations.buyUsCoffeeButton)

                TranslucentIconLabelButton(
                    title: "Send good vibes",
                    icon: "heart.fill",
                    action: sendGoodVibes
                )
                .accessibilityIdentifier(AccessibilityIdentifier.Donations.sendGoodVibesButton)
            }

            TranslucentIconLabelButton(
                title: "Go ghost mode hero (super kind tip)",
                icon: "sparkles",
                action: superKindTip
            )
            .accessibilityIdentifier(AccessibilityIdentifier.Donations.sendSuperKindTip)
        }
    }
}

#Preview {
    VStack {
        DonationButtonsView(
            buyUsCoffee: {},
            sendGoodVibes: {},
            superKindTip: {}
        )
        .background(LinearGradient.lavenderToPastelBlue)
    }
    .preferredColorScheme(.dark)
}

#Preview {
    VStack {
        DonationButtonsView(
            buyUsCoffee: {},
            sendGoodVibes: {},
            superKindTip: {}
        )
        .background(LinearGradient.lavenderToPastelBlue)
    }
    .preferredColorScheme(.light)
}
