import Foundation
import Combine
import Listen_Anonymously_Shared

final class FrontDoorViewModel: ObservableObject, Sendable {

    // MARK: - Properties

    let revenueCarService: RevenueCatService
    let purchaseEvents: AsyncStream<PurchaseEvent>
    let tippingJar: TippingJar
    private let postHog: PostHogProtocol

    // MARK: - Init

    init(revenueCatService: RevenueCatService, postHog: PostHogProtocol = PostHog.shared, tippingJar: TippingJar = TippingJar()) {
        self.revenueCarService = revenueCatService
        self.tippingJar = tippingJar
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
        if case let .success(donationType) = kind {
            addDonationTypeToTippingJar(donationType)
        }
    }

    private func addDonationTypeToTippingJar(_ donationType: DonationType) {
        Task { [weak tippingJar] in
            await tippingJar?.recordPurchase(donationType)
        }
    }

    private func purchase(product type: DonationType) async {
        let purchaseEventKind = await revenueCarService.purchase(product: type)
        Task { @MainActor [weak self] in
            self?.emit(purchaseEventKind)
        }
    }

}

actor TippingJar {
    @Published private(set) var donationsPurchased: [DonationType] = []
    private let defaults: UserDefaults

    private static func key(for type: DonationType) -> String {
        "tippingJar.count.\(type.rawValue)"
    }

    var totalTipCount: Int {
        tipCounts.values.reduce(0, +)
    }

    var tipCounts: [DonationType: Int] {
        var result: [DonationType: Int] = [:]
        for type in [DonationType.coffee, .goodVibes, .superKindTip] {
            let count = defaults.integer(forKey: Self.key(for: type))
            if count > 0 {
                result[type] = count
            }
        }
        return result
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func recordPurchase(_ donationType: DonationType) {
        donationsPurchased.append(donationType)
        let key = Self.key(for: donationType)
        let newCount = defaults.integer(forKey: key) + 1
        defaults.set(newCount, forKey: key)
    }
}
