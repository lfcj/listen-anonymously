import Foundation
import Listen_Anonymously_Shared
import RevenueCat

enum DonationType: String {
    case coffee = "donation.coffee"
    case goodVibes = "donation.goodvibes"
    case superKindTip = "donation.superkind"
}

final class RevenueCatService: Sendable {
    private let purchases: PurchasesClient
    private let revenueCatConfig: RevenueCatConfigProviding

    init(
        purchases: PurchasesClient = RevenueCatPurchasesClient(),
        revenueCatConfig: RevenueCatConfigProviding = RevenueCatConfig()
    ) {
        self.purchases = purchases
        self.revenueCatConfig = revenueCatConfig
        configureRevenueCatIfNeeded()
    }

    func purchase(product type: DonationType) async {
        let productID = type.rawValue
        log("donation_attempt", properties: ["product_id": productID])
        do {
            let product = try await loadProduct(with: productID)
            let result = try await purchases.purchase(product: product)

            if result.userCancelled == true {
                log("donation_cancelled", properties: ["product_id": productID])
                return
            }

            // Success
            log("donation_success", properties: ["product_id": productID])
        } catch {
            log("donation_failed", properties: [
                "product_id": productID,
                "error": String(describing: error)
            ])
        }
    }

    // MARK: - Private Helpers

    private func configureRevenueCatIfNeeded() {
        let purchases = self.purchases
        // Avoid re-configuring if already configured
        if purchases.isConfigured { return }

        guard !revenueCatConfig.apiKey.isEmpty else {
            log("donation_failed", properties: [
                "reason": "missing_api_key"
            ])
            return
        }

        purchases.configure(withAPIKey: revenueCatConfig.apiKey)
    }

    private func loadProduct(with productID: String) async throws -> StoreProductProtocol {
        let purchases = self.purchases
        return try await withCheckedThrowingContinuation { continuation in
            purchases.getProducts([productID]) { products in
                if let product = products.first {
                    continuation.resume(returning: product)
                } else {
                    continuation
                        .resume(
                            throwing: NSError(
                                domain: "FrontDoorViewModel",
                                code: 404, userInfo:
                                    [NSLocalizedDescriptionKey: "Product not found: \(productID)"]
                            )
                        )
                }
            }
        }
    }

    // MARK: - PostHog

    private func log(_ event: String, properties: sending [String: any Equatable]?) {
        Task.detached(priority: nil) {
            @Inject var posthog: SuperPosthog
            posthog.capture(event, properties: properties)
        }
    }

}

public struct ProductPurchaseResult {
    let transaction: StoreTransactionProtocol?
    let customerInfo: CustomerInfoProtocol
    let userCancelled: Bool
}

protocol PurchasesClient: Sendable {
    var isConfigured: Bool { get }
    func configure(withAPIKey key: String)
    func getProducts(_ productIDs: [String], completion: @escaping ([StoreProductProtocol]) -> Void)
    func purchase(product: StoreProductProtocol) async throws -> ProductPurchaseResult
}

/// Lives on top of the actual 3rd-party RevenueCat and implements `PurchasesClient` so it can be replaceable in the Test Suite
struct RevenueCatPurchasesClient: PurchasesClient, @unchecked Sendable {
    var isConfigured: Bool { Purchases.isConfigured }
    func configure(withAPIKey key: String) { Purchases.configure(withAPIKey: key) }
    func getProducts(_ productIDs: [String], completion: @escaping ([StoreProductProtocol]) -> Void) {
        Purchases.shared.getProducts(productIDs, completion: completion)
    }
    func purchase(product: StoreProductProtocol) async throws -> ProductPurchaseResult {
        guard let product = product as? StoreProduct else {
            return ProductPurchaseResult(transaction: nil, customerInfo: EmptyCustomerInfo(), userCancelled: false)
        }
        let purchaseData = try await Purchases.shared.purchase(product: product)
        return ProductPurchaseResult(
            transaction: purchaseData.transaction,
            customerInfo: purchaseData.customerInfo,
            userCancelled: purchaseData.userCancelled
        )
    }
}

// MARK: - RevenueCat Sendable + Liskov + DI Support

protocol CustomerInfoProtocol {}
protocol StoreProductProtocol: Sendable {
    var productIdentifier: String { get }
}
protocol StoreTransactionProtocol: Sendable {}

extension CustomerInfo: CustomerInfoProtocol {}
extension StoreProduct: StoreProductProtocol {}
extension StoreTransaction: StoreTransactionProtocol {}

struct EmptyCustomerInfo: CustomerInfoProtocol {}
