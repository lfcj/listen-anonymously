import Testing
import ViewInspector
@testable import Listen_anonymously

@MainActor
struct FrontDoorViewTests {

    @Test("tapping on see how it works  selects instructions tab")
    func tappingOnSeeHowItWorksSelectsInstructionsTab() throws {
        let appState = AppState()

        #expect(appState.selectedTab == .home)

        let seeHowItWorksButton = try FrontDoorView()
            .environmentObject(appState)
            .inspect()
            .zStack()
            .vStack(1)
            .button(2)

        try seeHowItWorksButton.tap()

        #expect(appState.selectedTab == .howToUse)
    }

}
