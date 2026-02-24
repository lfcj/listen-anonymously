@testable import Listen_Anonymously_Shared
import XCTest

 final class PostHogTests: XCTestCase {

    private let postHogSpy = LocalPostHogSpy()

    override func setUp() async throws {
        try await super.setUp()
        await InjectionResolver.shared.add(postHogSpy, for: LocalPostHogSpy.self)
    }

    // MARK: - Tests

    func test_postHogEventsAreEmptyOnInitialization() async {
        @Inject var postHog: LocalPostHogSpy
        XCTAssertTrue(postHog.capturedEvents.isEmpty)
    }

    func test_postHogCapturesEventsAndProperties() async {
        @Inject var postHog: LocalPostHogSpy
        let expectedEvent = "super hot gossip"
        let properties = ["details": "loads"]
        postHog.capture(expectedEvent, properties: properties)

        XCTAssertEqual([expectedEvent], postHog.capturedEvents)
        XCTAssertEqual(["details"], Array(postHog.capturedProperties[0].keys))
    }

    func test_postHogSendsAllEventsAndProperties() async {
        @Inject var postHog: LocalPostHogSpy
        let expectedEvent1 = "super hot gossip"
        let expectedEvent2 = "even hotter gossip"
        let properties1 = ["details": "loads"]
        let properties2 = ["more_deets": "way more"]

        postHog.capture(expectedEvent1, properties: properties1)
        postHog.capture(expectedEvent2, properties: properties2)

        XCTAssertEqual([expectedEvent1, expectedEvent2], postHogSpy.capturedEvents)
        XCTAssertEqual(["details", "more_deets"], Array(postHogSpy.capturedProperties.flatMap { $0.keys }))
    }

    func test_postHogSendsEventWhenPropertiesAreEmpty() async {
        @Inject var postHog: LocalPostHogSpy
        let expectedEvent = "super hot gossip"

        postHog.capture(expectedEvent)

        XCTAssertEqual([expectedEvent], postHogSpy.capturedEvents)
        XCTAssertTrue(postHogSpy.capturedProperties.isEmpty)
    }

 }

private final class LocalPostHogSpy: SuperPosthog, @unchecked Sendable {
    private(set) var capturedEvents: [String] = []
    private(set) var capturedProperties: [[String: any Equatable]] = []
    private let lock = NSLock()

    override func capture(_ event: String, properties: [String: any Equatable]? = nil) {
        lock.lock()
        capturedEvents.append(event)
        if let properties {
            capturedProperties.append(properties)
        }
        lock.unlock()
    }
}
