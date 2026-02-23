import RevenueCat
@testable import Listen_anonymously
import Listen_Anonymously_Shared
import XCTest

final class FrontDoorViewModelTests: XCTestCase {

    private final class MockPurchasesClient: PurchasesClient {
        var isConfigured: Bool = false
        var configuredWithKey: String?

        var productsByID: [String: StoreProductProtocol] = [:]
        var purchaseResult: ProductPurchaseResult?
        var purchaseError: Error?

        func configure(withAPIKey key: String) {
            isConfigured = true
            configuredWithKey = key
        }

        func getProducts(_ productIDs: [String], completion: @escaping ([StoreProductProtocol]) -> Void) {
            let products = productIDs.compactMap { productsByID[$0] }
            completion(products)
        }

        func purchase(product: StoreProduct) async throws -> ProductPurchaseResult {
            if let error = purchaseError { throw error }
            return purchaseResult ?? ProductPurchaseResult(transaction: nil, customerInfo: DummyCustomerInfo(), userCancelled: false)
        }
    }

    private let postHogSpy = PostHogSpy()

    override func setUp() async throws {
        try await super.setUp()
        await InjectionResolver.shared.add(postHogSpy, for: SuperPosthog.self)
    }

    func test_configureRevenueCat_missingAPIKey_logsFailure() {
        // Given: No RevenueCatAPIKey in Info.plist
        let mockPurchases = MockPurchasesClient()

        // When
        _ = FrontDoorViewModel(purchases: mockPurchases)

        // Then: Should have captured a failure due to missing_api_key
        XCTAssertTrue(postHogSpy.capturedEvents.contains("donation_failed"))
        let lastProperty: [String: any Equatable]? = postHogSpy.capturedProperties.last
        XCTAssertEqual(lastProperty?["reason"] as? String, "missing_api_key")
        XCTAssertFalse(mockPurchases.isConfigured)
    }

    func test_buyUsCoffee_success_logsAttemptAndSuccess() async throws {
        // Given
        let mockPurchases = MockPurchasesClient()
        // Simulate Info.plist key via direct configure call in mock — set isConfigured false but we won't assert configure path here
        let viewModel = FrontDoorViewModel(purchases: mockPurchases)

        // Provide product and a success purchase result
        let productID = "donation.coffee"
        mockPurchases.productsByID[productID] = DummyStoreProduct(productIdentifier: productID)
        mockPurchases.purchaseResult = ProductPurchaseResult(transaction: nil, customerInfo: DummyCustomerInfo(), userCancelled: false)

        // When
        viewModel.buyUsCoffee()
        // Give time for async Task to run
        await Task.yield()

        // Then
        XCTAssertTrue(postHogSpy.capturedEvents.contains("donation_attempt"))
        XCTAssertTrue(postHogSpy.capturedEvents.contains("donation_success"))
    }

    func test_sendGoodVibes_userCancelled_logsCancelled() async throws {
        // Given
        let mockPurchases = MockPurchasesClient()
        let viewModel = FrontDoorViewModel(purchases: mockPurchases)

        let productID = "donation.goodvibes"
        mockPurchases.productsByID[productID] = DummyStoreProduct(productIdentifier: productID)
        mockPurchases.purchaseResult = ProductPurchaseResult(transaction: nil, customerInfo: DummyCustomerInfo(), userCancelled: true)

        // When
        await viewModel.sendGoodVibes()
        await Task.yield()

        // Then
        XCTAssertTrue(postHogSpy.capturedEvents.contains("donation_attempt"))
        XCTAssertTrue(postHogSpy.capturedEvents.contains("donation_cancelled"))
    }

    func test_superKindTip_failure_logsFailed() async throws {
        // Given
        let mockPurchases = MockPurchasesClient()
        let viewModel = FrontDoorViewModel(purchases: mockPurchases)

        let productID = "donation.superkind"
        mockPurchases.productsByID[productID] = DummyStoreProduct(productIdentifier: productID)
        struct TestError: Error {}
        mockPurchases.purchaseError = TestError()

        // When
        viewModel.giveSuperKindTip()
        await Task.yield()

        // Then
        XCTAssertTrue(postHogSpy.capturedEvents.contains("donation_attempt"))
        XCTAssertTrue(postHogSpy.capturedEvents.contains("donation_failed"))
    }
}

// Reuse PostHogSpy from existing tests
final class PostHogSpy: SuperPosthog {
    private(set) var capturedEvents: [String] = []
    private(set) var capturedProperties: [[String: any Equatable]] = []

    init(capturedEvents: [String] = [], capturedProperties: [[String: any Equatable]] = []) {
        self.capturedEvents = capturedEvents
        self.capturedProperties = capturedProperties
        super.init()
    }

    override func capture(_ event: String, properties: [String: any Equatable]? = nil) {
        capturedEvents.append(event)
        if let properties {
            capturedProperties.append(properties)
        }
    }
}

private struct DummyCustomerInfo: CustomerInfoProtocol {}
private struct DummyStoreProduct: StoreProductProtocol {
    var productIdentifier: String
}
private struct DummyStoreTransaction: StoreTransactionProtocol {}
