import Listen_Anonymously_Shared
import SwiftUI

struct FrontDoorView: View {

    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel: FrontDoorViewModel
    @State var isPurchasing = false
    @State private var showThankYou = false
    @State private var tipCounts: [DonationType: Int] = [:]

    init(viewModel: FrontDoorViewModel = FrontDoorViewModel(revenueCatService: RevenueCatService())) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient
                    .lavenderToPastelBlue
                    .ignoresSafeArea()

                VStack(spacing: 28) {
                    FrontDoorTitleView()
                        .padding(.horizontal, 24)
                        .padding(.top, 36)

                    ShadowTranslucentCard(
                        title: My.localizedString("NO_BLUE_TICKS"),
                        subtitle: My.localizedString("TOTAL_FREEDOM"),
                        systemName: "checkmark.circle.fill"
                    )
                    .foregroundStyle(.white)
                    .padding(.horizontal, 18)

                    Button(action: selectHowToUseTab) {
                        Text(My.localizedString("SEE_HOW_IT_WORKS"))
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
                    .disabled(isPurchasing)
                    .opacity(isPurchasing ? 0.5 : 1)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 36)
                    .frame(minHeight: 280) // It does not allow 2 lines on iPhone 14, so setting a min height to force it.
                }
                .frame(maxWidth: 600)
                if isPurchasing {
                    BlockingLoadingView()
                }
            }
            .toolbar {
                if !tipCounts.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showThankYou = true
                        } label: {
                            Image(systemName: "heart.fill")
                                .foregroundStyle(.white)
                        }
                        .accessibilityIdentifier(AccessibilityIdentifier.FrontDoor.thankYouButton)
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .sheet(isPresented: $showThankYou) {
                ThankYouView(tipCounts: tipCounts)
            }
        }
        .task {
            tipCounts = await viewModel.tippingJar.tipCounts
            for await event in viewModel.purchaseEvents {
                switch event.kind {
                case .purchasing:
                    isPurchasing = true
                case .success:
                    isPurchasing = false
                    tipCounts = await viewModel.tippingJar.tipCounts
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
        FrontDoorView(
            viewModel: FrontDoorViewModel(
                revenueCatService: RevenueCatService(),
                tippingJar: TippingJar(defaults: UserDefaults(suiteName: "Preview\(UUID())") ?? UserDefaults.standard))
        )
    }
}

#Preview {
    FrontDoorView()
        .preferredColorScheme(.dark)
}
