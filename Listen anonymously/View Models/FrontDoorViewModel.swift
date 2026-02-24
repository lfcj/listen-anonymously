import Foundation
import Combine
import Listen_Anonymously_Shared

final class FrontDoorViewModel: ObservableObject, Sendable {

    // MARK: - Properties

    let tippingJar: TippingJar = TippingJar()
    let revenueCarService: RevenueCatService

    // MARK: - Init

    init(revenueCatService: RevenueCatService) {
        self.revenueCarService = revenueCatService
    }

    // MARK: - Public API

    @discardableResult
    @MainActor
    func buyUsCoffee() -> Task<Void, Error> {
        Task(priority: .userInitiated) { [purchase] in
            await purchase(.coffee)
        }
    }

    @discardableResult
    @MainActor
    func sendGoodVibes() -> Task<Void, Error> {
        Task(priority: .userInitiated) { [purchase] in
            await purchase(.goodVibes)
        }
    }

    @discardableResult
    @MainActor
    func giveSuperKindTip() -> Task<Void, Error> {
        Task(priority: .userInitiated) { [purchase] in
            await purchase(.superKindTip)
        }
    }

    // MARK: - Private helpers

    private func purchase(product type: DonationType) async {
        await revenueCarService.purchase(product: type)
    }

    private func log(_ event: String, properties: sending [String: any Equatable]?) {
        Task.detached(priority: nil) {
            @Inject var posthog: SuperPosthog
            posthog.capture(event, properties: properties)
        }
    }
}

actor TippingJar {
    @Published private(set) var donationsPurchased: [DonationType] = []

    func recordPurchase(_ donationType: DonationType) {
        donationsPurchased.append(donationType)
    }
}
