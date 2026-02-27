import SwiftUI
import Listen_Anonymously_Shared

struct DonationButtonsView: View {
    let buyUsCoffee: () -> Void
    let sendGoodVibes: () -> Void
    let superKindTip: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text(My.localizedString("VIBE_CHECK"))
                .font(.title2.weight(.semibold))
                .foregroundColor(.white)

            Text(My.localizedString("LOVE_BEING_INVISIBLE"))
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))

            HStack(spacing: 12) {
                TranslucentIconLabelButton(
                    title: My.localizedString("BUY_US_A_COFFEE"),
                    icon: "cup.and.saucer.fill",
                    action: buyUsCoffee
                )
                .accessibilityIdentifier(AccessibilityIdentifier.Donations.buyUsCoffeeButton)

                TranslucentIconLabelButton(
                    title: My.localizedString("SEND_GOOD_VIBES"),
                    icon: "heart.fill",
                    action: sendGoodVibes
                )
                .accessibilityIdentifier(AccessibilityIdentifier.Donations.sendGoodVibesButton)
            }

            TranslucentIconLabelButton(
                title: My.localizedString("GHOST_MODE_HERO"),
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
