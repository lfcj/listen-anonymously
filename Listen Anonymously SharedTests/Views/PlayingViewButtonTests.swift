import SwiftUI
import Testing
import ViewInspector
@testable import Listen_Anonymously_Shared

@MainActor
struct PlayingViewButtonTests {


    @Test func usesGivenImageName() throws {
        let expectedImageName = "xmark"
        let view = PlayingViewButton(imageName: expectedImageName, size: .zero, action: {})
            .environment(\.colorScheme, .light)

        let inspectedImageName = try view.inspect().button(0).labelView().image(0).actualImage().name()

        #expect(expectedImageName == inspectedImageName)
    }

    @Test func buttonPlaysGivenAction() throws {
        var callCount = 0
        let view = PlayingViewButton(
            imageName: "xmark",
            size: .zero,
            action: {
                callCount += 1
            }
        )
        .environment(\.colorScheme, .light)

        let inspectedButton = try view.inspect().button(0)
        try inspectedButton.tap()

        #expect(callCount == 1)
    }

}
