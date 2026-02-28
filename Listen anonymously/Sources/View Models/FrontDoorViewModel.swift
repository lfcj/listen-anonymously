import Foundation
import Combine
import Listen_Anonymously_Shared

final class FrontDoorViewModel: ObservableObject, Sendable {

    // MARK: - Properties

    let tippingJar: TippingJar = TippingJar()
    let revenueCarService: RevenueCatService
    let purchaseEvents: AsyncStream<PurchaseEvent>
    private let eventContinuation: AsyncStream<PurchaseEvent>.Continuation?
    private let postHog: PostHogProtocol

    // MARK: - Init

    init(revenueCatService: RevenueCatService, postHog: PostHogProtocol = PostHog.shared) {
        self.revenueCarService = revenueCatService
        var cont: AsyncStream<PurchaseEvent>.Continuation?
        self.purchaseEvents = AsyncStream { continuation in
            cont = continuation
        }
        self.eventContinuation = cont
        self.postHog = postHog
    }

    // MARK: - Public API

    @discardableResult
    @MainActor
    func buyUsCoffee() -> Task<Void, Error> {
        emit(.purchasing)
        return Task(priority: .userInitiated) { [purchase] in
            await purchase(.coffee)
            emit(.finished)
        }
    }

    @discardableResult
    @MainActor
    func sendGoodVibes() -> Task<Void, Error> {
        emit(.purchasing)
        return Task(priority: .userInitiated) { [purchase] in
            await purchase(.goodVibes)
            emit(.finished)
        }
    }

    @discardableResult
    @MainActor
    func giveSuperKindTip() -> Task<Void, Error> {
        emit(.purchasing)
        return Task(priority: .userInitiated) { [purchase] in
            await purchase(.superKindTip)
            emit(.finished)
        }
    }

    func log(_ event: String, properties: sending [String: any Equatable]? = nil) {
        Task.detached(priority: nil) { [weak postHog] in
            postHog?.capture(event, properties: properties)
        }
    }

    // MARK: - Private helpers

    @MainActor
    private func emit(_ kind: PurchaseEvent.Kind) {
        eventContinuation?.yield(PurchaseEvent(kind: kind))
    }

    private func purchase(product type: DonationType) async {
        await revenueCarService.purchase(product: type)
    }

}

actor TippingJar {
    @Published private(set) var donationsPurchased: [DonationType] = []

    func recordPurchase(_ donationType: DonationType) {
        donationsPurchased.append(donationType)
    }
}
