import Combine
@testable import Listen_anonymously
import Listen_Anonymously_Shared
import XCTest

final class RevenueCatServiceTests: XCTestCase {

    private let postHogSpy = PostHogSpy()

    func test_configureRevenueCat_missingAPIKey_logsFailure() async throws {
        let expectation = expectation(description: "No api key error is logged")
        var cancellables: Set<AnyCancellable> = []

        // Given: No RevenueCatAPIKey in Info.plist
        let mockPurchases = MockPurchasesClient()

        // When
        _ = RevenueCatService(
            purchases: mockPurchases,
            revenueCatConfig: MockRevenueCatConfig.empty,
            postHog: postHogSpy
        )

        try await Task.sleep(for: .milliseconds(500))

        // Then
        postHogSpy.$capturedEvents.sink(receiveValue: { [weak self] events in
            guard events.contains("donation_failed") else {
                return
            }
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
        let revenueCatService = RevenueCatService(
            purchases: mockPurchases,
            revenueCatConfig: MockRevenueCatConfig.empty,
            postHog: postHogSpy
        )
        let viewModel = FrontDoorViewModel(revenueCatService: revenueCatService)

        // Provide product and a success purchase result
        let productID = DonationType.coffee.rawValue
        mockPurchases.productsByID[productID] = DummyStoreProduct(productIdentifier: productID)
        mockPurchases.purchaseResult = ProductPurchaseResult(transaction: nil, customerInfo: DummyCustomerInfo(), userCancelled: false)

        // When
        _ = try await viewModel.buyUsCoffee().value

        // Then
        postHogSpy.$capturedEvents.sink(receiveValue: { events in
            guard events.contains("donation_success"), events.contains("donation_attempt") else {
                return
            }

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
        let revenueCatService = RevenueCatService(
            purchases: mockPurchases,
            revenueCatConfig: MockRevenueCatConfig.empty,
            postHog: postHogSpy
        )
        let viewModel = FrontDoorViewModel(revenueCatService: revenueCatService)

        let productID = DonationType.goodVibes.rawValue
        mockPurchases.productsByID[productID] = DummyStoreProduct(productIdentifier: productID)
        mockPurchases.purchaseResult = ProductPurchaseResult(transaction: nil, customerInfo: DummyCustomerInfo(), userCancelled: true)

        // When
        try await viewModel.sendGoodVibes().value

        // Then
        postHogSpy.$capturedEvents.sink(receiveValue: { events in
            guard events.contains("donation_cancelled") else {
                return
            }

            XCTAssertTrue(events.contains("donation_attempt"))
            XCTAssertTrue(events.contains("donation_cancelled"))

            expectation.fulfill()
        }).store(in: &cancellables)

        await fulfillment(of: [expectation], timeout: 2.0)
    }

    func test_superKindTip_failure_logsFailed() async throws {
        let expectation = expectation(description: "User cancelling sending good vibes donation is logged")
        var cancellables: Set<AnyCancellable> = []

        // Given
        let mockPurchases = MockPurchasesClient()
        let revenueCatService = RevenueCatService(
            purchases: mockPurchases,
            revenueCatConfig: MockRevenueCatConfig.empty,
            postHog: postHogSpy
        )
        let viewModel = FrontDoorViewModel(revenueCatService: revenueCatService)

        let productID = "donation.superkind"
        mockPurchases.productsByID[productID] = DummyStoreProduct(productIdentifier: productID)
        struct TestError: Error {}
        mockPurchases.purchaseError = TestError()

        // When
        try await viewModel.giveSuperKindTip().value

        // Then
        postHogSpy.$capturedEvents.sink(receiveValue: { events in
            XCTAssertTrue(events.contains("donation_attempt"))
            XCTAssertTrue(events.contains("donation_failed"))

            expectation.fulfill()
        }).store(in: &cancellables)

        await fulfillment(of: [expectation], timeout: 2.0)
    }

    func test_NoProductFound_sendsAnError() async throws {
        let expectation = expectation(description: "Non existing product throws error")
        var cancellables: Set<AnyCancellable> = []

        // Given
        let mockPurchases = MockPurchasesClient()
        let revenueCatService = RevenueCatService(
            purchases: mockPurchases,
            revenueCatConfig: MockRevenueCatConfig.empty,
            postHog: postHogSpy
        )
        let viewModel = FrontDoorViewModel(revenueCatService: revenueCatService)

        // When
        try await viewModel.giveSuperKindTip().value

        // Then
        postHogSpy.$capturedEvents.sink(receiveValue: { events in
            guard events.contains("donation_failed") else {
                return
            }

            XCTAssertTrue(events.contains("donation_failed"))

            let errorProperties = self.postHogSpy.capturedProperties.first(where: { $0.keys.contains(["error"])})
            XCTAssertNotNil(errorProperties)
            let errorAsString = errorProperties!["error"] as? String
            XCTAssertNotNil(errorAsString)
            XCTAssertTrue(errorAsString!.contains("Error Domain=FrontDoorViewModel"))
            XCTAssertTrue(errorAsString!.contains("Code=404"))
            XCTAssertTrue(errorAsString!.contains("UserInfo={NSLocalizedDescription=Product not found: donation.superkind}"))

            expectation.fulfill()
        }).store(in: &cancellables)

        await fulfillment(of: [expectation], timeout: 2.0)
    }

}

final class PostHogSpy: PostHogProtocol, @unchecked Sendable {
    @Published private(set) var capturedEvents: [String] = []
    @Published private(set) var capturedProperties: [[String: any Equatable]] = []
    private let lock = NSLock()

    func capture(_ event: String, properties: [String: any Equatable]? = nil) {
        lock.lock()
        capturedEvents.append(event)
        if let properties {
            capturedProperties.append(properties)
        }
        lock.unlock()
    }
}

struct DummyCustomerInfo: CustomerInfoProtocol {}
struct DummyStoreProduct: StoreProductProtocol {
    var productIdentifier: String
}
struct DummyStoreTransaction: StoreTransactionProtocol {}

struct MockRevenueCatConfig: RevenueCatConfigProviding {
    let apiKey: String

    static let empty: MockRevenueCatConfig = MockRevenueCatConfig(apiKey: "")
}

final class MockPurchasesClient: PurchasesClient, @unchecked Sendable {
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
