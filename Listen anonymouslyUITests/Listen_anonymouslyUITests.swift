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

        XCTAssertEqual(
            app.staticTexts[AccessibilityIdentifier.Instructions.whatsAppStep4].label,
            "4. Scroll down and tap on:"
        )

        segmentedControl.buttons["Telegram"].tap()

        let telegramStep2 = app.staticTexts[AccessibilityIdentifier.Instructions.telegramStep2]
        let secondTelegramStepExists = telegramStep2.waitForExistence(timeout: 3)
        XCTAssertTrue(
            secondTelegramStepExists,
            "tapping on Telegram button should show second step for Telegram"
        )

        XCTAssertEqual(
            app.staticTexts[AccessibilityIdentifier.Instructions.telegramStep2].label,
            "2. Tap on 'Select'"
        )
        
    }

}
