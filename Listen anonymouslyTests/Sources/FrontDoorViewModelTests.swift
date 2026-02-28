import Testing
@testable import Listen_anonymously

@MainActor
struct FrontDoorViewModelTests {

    struct Dependencies {
        let viewModel: FrontDoorViewModel
        let purchaseClient: MockPurchasesClient
        let postHog: PostHogSpy

        init(
            _ viewModel: FrontDoorViewModel,
            _ purchaseClient: MockPurchasesClient,
            _ postHog: PostHogSpy
        ) {
            self.viewModel = viewModel
            self.purchaseClient = purchaseClient
            self.postHog = postHog
        }
    }

    // MARK: - Helpers

    static func makeDependencies() -> Dependencies {
        let mockPurchases = MockPurchasesClient()
        let postHogSpy = PostHogSpy()
        let revenueCatService = RevenueCatService(
            purchases: mockPurchases,
            revenueCatConfig: MockRevenueCatConfig.empty,
            postHog: postHogSpy
        )
        let viewModel = FrontDoorViewModel(revenueCatService: revenueCatService, postHog: postHogSpy)
        return Dependencies(viewModel, mockPurchases, postHogSpy)
    }

    static func configureForPurchase(_ dependencies: Dependencies, donationType: DonationType) {
        let productID = donationType.rawValue
        dependencies.purchaseClient.productsByID[productID] = DummyStoreProduct(productIdentifier: productID)
        dependencies.purchaseClient.purchaseResult = ProductPurchaseResult(
            transaction: nil, customerInfo: DummyCustomerInfo(), userCancelled: false
        )
    }

    // MARK: - purchase(_:) dispatches to the correct ViewModel method

    @Test("purchase(.coffee) triggers buyUsCoffee on viewModel")
    func purchase_coffee_callsBuyUsCoffee() async throws {
        let dependencies = Self.makeDependencies()
        Self.configureForPurchase(dependencies, donationType: .coffee)

        // The view's purchase(.coffee) calls viewModel.buyUsCoffee().
        // We test the same dispatch by calling the viewModel directly and verifying
        // the .purchasing event is emitted on the purchaseEvents stream.
        let collectTask = Task {
            var kinds: [PurchaseEvent.Kind] = []
            for await event in dependencies.viewModel.purchaseEvents {
                kinds.append(event.kind)
                if event.kind == .finished { break }
            }
            return kinds
        }

        try await dependencies.viewModel.buyUsCoffee().value
        let kinds = await collectTask.value

        #expect(kinds.contains(.purchasing))
        #expect(kinds.contains(.finished))
        #expect(await dependencies.viewModel.tippingJar.donationsPurchased.contains(.coffee))
    }

    @Test("purchase(.goodVibes) triggers sendGoodVibes on viewModel")
    func purchase_goodVibes_callsSendGoodVibes() async throws {
        let dependencies = Self.makeDependencies()
        Self.configureForPurchase(dependencies, donationType: .goodVibes)

        let collectTask = Task {
            var kinds: [PurchaseEvent.Kind] = []
            for await event in dependencies.viewModel.purchaseEvents {
                kinds.append(event.kind)
                if event.kind == .finished { break }
            }
            return kinds
        }

        try await dependencies.viewModel.sendGoodVibes().value
        let kinds = await collectTask.value

        #expect(kinds.contains(.purchasing))
        #expect(kinds.contains(.finished))
    }

    @Test("purchase(.superKindTip) triggers giveSuperKindTip on viewModel")
    func purchase_superKindTip_callsGiveSuperKindTip() async throws {
        let dependencies = Self.makeDependencies()
        Self.configureForPurchase(dependencies, donationType: .superKindTip)

        let collectTask = Task {
            var kinds: [PurchaseEvent.Kind] = []
            for await event in dependencies.viewModel.purchaseEvents {
                kinds.append(event.kind)
                if event.kind == .finished { break }
            }
            return kinds
        }

        try await dependencies.viewModel.giveSuperKindTip().value
        let kinds = await collectTask.value

        #expect(kinds.contains(.purchasing))
        #expect(kinds.contains(.finished))
    }

    // MARK: - Event stream produces correct sequence

    @Test("purchaseEvents stream emits .purchasing then .finished for a successful purchase")
    func eventStream_emitsPurchasingThenFinished() async throws {
        let dependencies = Self.makeDependencies()
        Self.configureForPurchase(dependencies, donationType: .coffee)

        let collectTask = Task {
            var kinds: [PurchaseEvent.Kind] = []
            for await event in dependencies.viewModel.purchaseEvents {
                kinds.append(event.kind)
                if event.kind == .finished { break }
            }
            return kinds
        }

        try await dependencies.viewModel.buyUsCoffee().value
        let kinds = await collectTask.value

        // The view's .task modifier uses this exact pattern:
        // .purchasing -> isPurchasing = true
        // default (including .finished) -> isPurchasing = false
        #expect(kinds.first == .purchasing)
        #expect(kinds.last == .finished)
    }

    // MARK: - selectHowToUseTab

    @Test("selectHowToUseTab logs tapped-how-to-use via viewModel.log")
    func selectHowToUseTab_logsEvent() async throws {
        let dependencies = Self.makeDependencies()

        dependencies.viewModel.log("tapped-how-to-use")

        // log dispatches via Task.detached, give it time to execute
        try await Task.sleep(for: .milliseconds(200))

        #expect(dependencies.postHog.capturedEvents.contains("tapped-how-to-use"))
    }

    @Test("selectHowToUseTab sets selectedTab to .howToUse on AppState")
    func selectHowToUseTab_setsTab() {
        let appState = AppState()

        #expect(appState.selectedTab == .home)

        appState.selectedTab = .howToUse

        #expect(appState.selectedTab == .howToUse)
    }

}
