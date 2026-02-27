import Listen_Anonymously_Shared
import SwiftUI

struct FrontDoorView: View {

    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = FrontDoorViewModel(revenueCatService: RevenueCatService())
    @State var isPurchasing = false

    var body: some View {
        ZStack {
            LinearGradient
                .lavenderToPastelBlue
                .ignoresSafeArea()

            VStack(spacing: 28) {
                FrontDoorTitleView()
                    .padding(.horizontal, 24)
                    .padding(.top, 36)

                ShadowTranslucentCard(
                    title: "No blue ticks. No pressure.",
                    subtitle: "Total freedom.",
                    systemName: "checkmark.circle.fill"
                )
                .foregroundStyle(.white)
                .padding(.horizontal, 18)

                Button(action: selectHowToUseTab) {
                    Text("See how it works")
                }
                .buttonStyle(GradientButtonStyle())
                .padding(.horizontal, 44)
                .accessibilityIdentifier(AccessibilityIdentifier.FrontDoor.seeInstructions)

                Spacer()

                DonationButtonsView(
                    buyUsCoffee: { purchase(.coffee) },
                    sendGoodVibes: { purchase(.coffee) },
                    superKindTip: { purchase(.superKindTip) }
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 36)
                .frame(minHeight: 280) // It does not allow 2 lines on iPhone 14, so setting a min height to force it.
            }
            .frame(maxWidth: 600)
            if isPurchasing {
                ProgressView()
                    .tint(.white)
                    .progressViewStyle(.circular)
                    .frame(width: 80, height: 80)
            }
        }
        .task {
            for await event in viewModel.events {
                switch event.kind {
                case .purchasing:
                    isPurchasing = true
                default:
                    isPurchasing = false
                }
            }
        }
    }

    func purchase(_ donationType: DonationType) {
        isPurchasing = true
        switch donationType {
        case .coffee:
            viewModel.buyUsCoffee()
        case .goodVibes:
            viewModel.sendGoodVibes()
        case .superKindTip:
            viewModel.giveSuperKindTip()
        }
    }

    func selectHowToUseTab() {
        appState.selectedTab = .howToUse
        viewModel.log("tapped-how-to-use")
    }

}

// MARK: - Preview

#Preview {
    Group {
        FrontDoorView()
    }
}

#Preview {
    FrontDoorView()
        .preferredColorScheme(.dark)
}
