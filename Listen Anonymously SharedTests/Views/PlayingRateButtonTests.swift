import SwiftUI
import Testing
import ViewInspector
@testable import Listen_Anonymously_Shared

@MainActor
struct PlayingRateButtonTests {

    @Test func usesGivenImageName() throws {
        let expectedTitle = "Louvre"
        let view = PlayingRateButton(action: {}, title: expectedTitle)

        let inspectedText = try view.inspect().button(0).labelView().text(0).string()

        #expect(expectedTitle == inspectedText)
    }

    @Test func buttonPlaysGivenAction() throws {
        var callCount = 0
        let view = PlayingRateButton(
            action: {
                callCount += 1
            },
            title: "Any title"
        )

        let inspectedButton = try view.inspect().button(0)
        try inspectedButton.tap()

        #expect(callCount == 1)
    }

}
