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

        func purchase(product: StoreProductProtocol) async throws -> ProductPurchaseResult {
            if let error = purchaseError { throw error }
            return purchaseResult ?? ProductPurchaseResult(transaction: nil, customerInfo: DummyCustomerInfo(), userCancelled: false)
        }
    }

    private let postHogSpy = PostHogSpy()

    override func setUp() async throws {
        try await super.setUp()
        await InjectionResolver.shared.add(postHogSpy, for: SuperPosthog.self)
    }

    func test_configureRevenueCat_missingAPIKey_logsFailure() async throws {
        let expectation = expectation(description: "No api key error is logged")
        var cancellables: Set<AnyCancellable> = []

        // Given: No RevenueCatAPIKey in Info.plist
        let mockPurchases = MockPurchasesClient()

        // When
        _ = FrontDoorViewModel(purchases: mockPurchases, revenueCatConfig: MockRevenueCatConfig.empty)

        try await Task.sleep(for: .milliseconds(500))

        // Then
        postHogSpy.$capturedEvents.sink(receiveValue: { [weak self] events in
            XCTAssertTrue(events.contains("donation_failed"))
            let lastProperty: [String: any Equatable]? = self?.postHogSpy.capturedProperties.last
            XCTAssertEqual(lastProperty?["reason"] as? String, "missing_api_key")
            XCTAssertFalse(mockPurchases.isConfigured)

            expectation.fulfill()
        }).store(in: &cancellables)

        await fulfillment(of: [expectation], timeout: 2.0)
    }

    func test_buyUsCoffee_success_logsAttemptAndSuccess() async throws {
        let expectation = expectation(description: "coffee donation logs attempt and success")
        var cancellables: Set<AnyCancellable> = []

        // Given
        let mockPurchases = MockPurchasesClient()

        let viewModel = FrontDoorViewModel(purchases: mockPurchases)

        // Provide product and a success purchase result
        let productID = "donation.coffee"
        mockPurchases.productsByID[productID] = DummyStoreProduct(productIdentifier: productID)
        mockPurchases.purchaseResult = ProductPurchaseResult(transaction: nil, customerInfo: DummyCustomerInfo(), userCancelled: false)

        // When
        _ = try await viewModel.buyUsCoffee().value

        // Then
        postHogSpy.$capturedEvents.sink(receiveValue: { events in
            XCTAssertTrue(events.contains("donation_attempt"))
            XCTAssertTrue(events.contains("donation_success"))

            expectation.fulfill()
        }).store(in: &cancellables)

        await fulfillment(of: [expectation], timeout: 2.0)
    }

    func test_sendGoodVibes_userCancelled_logsCancelled() async throws {
        let expectation = expectation(description: "User cancelling sending good vibes donation is logged")
        var cancellables: Set<AnyCancellable> = []

        // Given
        let mockPurchases = MockPurchasesClient()
        let viewModel = FrontDoorViewModel(purchases: mockPurchases)

        let productID = FrontDoorViewModel.DonationType.goodVibes.rawValue
        mockPurchases.productsByID[productID] = DummyStoreProduct(productIdentifier: productID)
        mockPurchases.purchaseResult = ProductPurchaseResult(transaction: nil, customerInfo: DummyCustomerInfo(), userCancelled: true)

        // When
        try await viewModel.sendGoodVibes().value

        // Then
        postHogSpy.$capturedEvents.sink(receiveValue: { events in
            XCTAssertTrue(events.contains("donation_attempt"))
            XCTAssertTrue(events.contains("donation_cancelled"))

            expectation.fulfill()
        }).store(in: &cancellables)

        await fulfillment(of: [expectation], timeout: 2.0)
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
