import Foundation
import Combine
import Listen_Anonymously_Shared
import RevenueCat

protocol CustomerInfoProtocol {}
protocol StoreProductProtocol {
    var productIdentifier: String { get }
}
protocol StoreTransactionProtocol {}

extension CustomerInfo: CustomerInfoProtocol {}
extension StoreProduct: StoreProductProtocol {}
extension StoreTransaction: StoreTransactionProtocol {}

public struct ProductPurchaseResult {
    let transaction: StoreTransactionProtocol?
    let customerInfo: CustomerInfoProtocol
    let userCancelled: Bool
}

protocol PurchasesClient {
    var isConfigured: Bool { get }
    func configure(withAPIKey key: String)
    func getProducts(_ productIDs: [String], completion: @escaping ([StoreProductProtocol]) -> Void)
    func purchase(product: StoreProduct) async throws -> ProductPurchaseResult
}

struct RevenueCatPurchasesClient: PurchasesClient {
    var isConfigured: Bool { Purchases.isConfigured }
    func configure(withAPIKey key: String) { Purchases.configure(withAPIKey: key) }
    func getProducts(_ productIDs: [String], completion: @escaping ([StoreProductProtocol]) -> Void) {
        Purchases.shared.getProducts(productIDs, completion: completion)
    }
    func purchase(product: StoreProduct) async throws -> ProductPurchaseResult {
        let purchaseData = try await Purchases.shared.purchase(product: product)
        return ProductPurchaseResult(
            transaction: purchaseData.transaction,
            customerInfo: purchaseData.customerInfo,
            userCancelled: purchaseData.userCancelled
        )
    }
}

final class FrontDoorViewModel: ObservableObject {

    // MARK: - Nested Types

    enum DonationType: String {
        case coffee = "donation.coffee"
        case goodVibes = "donation.goodvibes"
        case superKindTip = "donation.superkind"
    }

    // MARK: - Dependencies

    private let purchases: PurchasesClient

    // MARK: - Init

    init(purchases: PurchasesClient = RevenueCatPurchasesClient()) {
        self.purchases = purchases
        configureRevenueCatIfNeeded()
    }

    // MARK: - Public API

    func buyUsCoffee() {
        Task(priority: .userInitiated) {
            await purchase(product: .coffee)
        }
    }

    func sendGoodVibes() {
        Task(priority: .userInitiated) {
            await purchase(product: .goodVibes)
        }
    }

    func giveSuperKindTip() {
        Task(priority: .userInitiated) {
            await purchase(product: .superKindTip)
        }
    }

    // MARK: - Private helpers

    private func configureRevenueCatIfNeeded() {
        // Avoid re-configuring if already configured
        if purchases.isConfigured { return }

        let key = Bundle.main.object(forInfoDictionaryKey: "RevenueCatAPIKey") as? String

        guard let apiKey = key, apiKey.isEmpty == false else {
            log("donation_failed", properties: [
                "reason": "missing_api_key"
            ])
            return
        }
        purchases.configure(withAPIKey: apiKey)
    }

    private func purchase(product type: DonationType) async {
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
            log("donation_success", properties: [
                "product_id": productID
            ])
        } catch {
            log("donation_failed", properties: [
                "product_id": productID,
                "error": String(describing: error)
            ])
        }
    }

    private func loadProduct(with productID: String) async throws -> StoreProduct {
        return try await withCheckedThrowingContinuation { continuation in
            purchases.getProducts([productID]) { products in
                if let product = products.first as? StoreProduct {
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

    private func log(_ event: String, properties: [String: any Equatable]?) {
        Task.detached {
            @Inject var posthog: SuperPosthog
            posthog.capture(event, properties: properties)
        }
    }
}
