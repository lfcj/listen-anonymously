import SwiftUI
import Listen_Anonymously_Shared

struct FrontDoorView: View {

    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = FrontDoorViewModel()

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

                Spacer()

                DonationButtonsView(
                    buyUsCoffee: viewModel.buyUsCoffee,
                    sendGoodVibes: viewModel.sendGoodVibes,
                    superKindTip: viewModel.giveSuperKindTip
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 36)
                .frame(minHeight: 280) // It does not allow 2 lines on iPhone 14, so setting a min height to force it.
            }
            .frame(maxWidth: 600)
        }
    }

    func selectHowToUseTab() {
        appState.selectedTab = .howToUse
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
