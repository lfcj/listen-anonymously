import XCTest
@testable import Listen_Anonymously_Shared

final class PostHogTests: XCTestCase {

    private let postHogSpy = PostHogSpy()
    private var originalPostHog: SuperPosthog?

    override func setUp() {
        originalPostHog = InjectionResolver.shared.resolve()
        InjectionResolver.shared.add(postHogSpy, for: SuperPosthog.self)
        super.setUp()
    }

    override func tearDown() {
        InjectionResolver.shared.add(originalPostHog ?? LAPostHog(key: "testing"), for: SuperPosthog.self)
        super.tearDown()
    }

    // MARK: - Tests

    func test_postHogEventsAreEmptyOnIntialization() {
        @Inject var postHog: SuperPosthog
        XCTAssertTrue(postHogSpy.capturedEvents.isEmpty)
    }

    func test_postHogCapturesEventsAndProperties() {
        @Inject var postHog: SuperPosthog
        let expectedEvent = "super hot gossip"
        let properties = ["details": "loads"]
        postHog.capture(expectedEvent, properties: properties)

        XCTAssertEqual([expectedEvent], postHogSpy.capturedEvents)
        XCTAssertEqual(["details"], Array(postHogSpy.capturedProperties[0].keys))
    }

    func test_postHogSendsAllEventsAndProperties() {
        @Inject var postHog: SuperPosthog
        let expectedEvent1 = "super hot gossip"
        let expectedEvent2 = "even hotter gossip"
        let properties1 = ["details": "loads"]
        let properties2 = ["more_deets": "way more"]

        postHog.capture(expectedEvent1, properties: properties1)
        postHog.capture(expectedEvent2, properties: properties2)

        XCTAssertEqual([expectedEvent1, expectedEvent2], postHogSpy.capturedEvents)
        XCTAssertEqual(["details", "more_deets"], Array(postHogSpy.capturedProperties.flatMap { $0.keys }))
    }

    func test_postHogSendsEventWhenPropertiesAreEmpty() {
        @Inject var postHog: SuperPosthog
        let expectedEvent = "super hot gossip"

        postHog.capture(expectedEvent)

        XCTAssertEqual([expectedEvent], postHogSpy.capturedEvents)
        XCTAssertTrue(postHogSpy.capturedProperties.isEmpty)
    }

}

final class PostHogSpy: SuperPosthog {
    private(set) var capturedEvents: [String] = []
    private(set) var capturedProperties: [[String: any Equatable]] = []

    override func capture(_ event: String, properties: [String: any Equatable]? = nil) {
        capturedEvents.append(event)
        if let properties {
            capturedProperties.append(properties)
        }
    }
}
