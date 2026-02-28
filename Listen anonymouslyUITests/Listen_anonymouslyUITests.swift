import XCTest

final class Listen_anonymouslyUITests: XCTestCase {

    @MainActor
    func testFrontDoor() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertEqual(
            app.staticTexts["stayUnseen"].label,
            "Stay unseen.",
            "First title sentence is readable"
        )
        XCTAssertEqual(
            app.staticTexts["stillInTheLoop"].label,
            "Still in the loop.",
            "Second title sentence is readable"
        )

        // Tap to switch to instructions
        app.buttons["seeInstructions"].tap()

        let segmentedControl = app.segmentedControls["instructionsPicker"]

        let segmentedControlExists = segmentedControl.waitForExistence(timeout: 3)
        XCTAssertTrue(
            segmentedControlExists,
            "tapping on instructions button should show view with segmented control"
        )

        XCTAssertEqual(
            app.staticTexts["instructions_whatsapp_step4"].label,
            "Scroll down and tap: 👇🏻"
        )

        segmentedControl.buttons["Telegram"].tap()

        let telegramStep2 = app.staticTexts["instructions_telegram_step2"]
        let secondTelegramStepExists = telegramStep2.waitForExistence(timeout: 3)
        XCTAssertTrue(
            secondTelegramStepExists,
            "tapping on Telegram button should show second step for Telegram"
        )

        XCTAssertEqual(
            app.staticTexts["instructions_telegram_step2"].label,
            "Tap 'Select'"
        )
    }

}
