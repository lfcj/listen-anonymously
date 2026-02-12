import Listen_Anonymously_Shared
import XCTest

final class Listen_anonymouslyUITests: XCTestCase {

    /*
     On FrontDoor View, tap 3 buttons to give tip.
     Close views and then tap on instructions button
     Make sure that picker is shown when there are more supported apps
     Tap on picker
     Make sure that Whatsapp shows 4 points, as well as Telegram
     */
    @MainActor
    func testFrontDoor() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertEqual(
            app.staticTexts[AccessibilityIdentifier.Titles.stayUnseen].label,
            "Stay unseen.",
            "First title sentence is readable"
        )
        XCTAssertEqual(
            app.staticTexts[AccessibilityIdentifier.Titles.stillInTheLoop].label,
            "Still in the loop.",
            "Second title sentence is readable"
        )

        // Tap to switch to instructions
        app.buttons[AccessibilityIdentifier.FrontDoor.seeInstructions].tap()

        let segmentedControl = app.segmentedControls[AccessibilityIdentifier.Instructions.picker]

        let segmentedControlExists = segmentedControl.waitForExistence(timeout: 3)
        XCTAssertTrue(
            segmentedControlExists,
            "tapping on instructions button should show view with segmented control"
        )
    }

}
