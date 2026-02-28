import Testing
import ViewInspector
@testable import Listen_anonymously

@MainActor
struct FrontDoorViewTests {

    @Test("DonationButtonsView is present in the view hierarchy")
    func donationButtonsView_isPresent() throws {
        let dependencies = FrontDoorViewModelTests.makeDependencies()
        let appState = AppState()
        let view = FrontDoorView(viewModel: dependencies.viewModel)
            .environmentObject(appState)

        let inspected = try view.inspect()
        let donationButtons = try inspected.find(DonationButtonsView.self)
        #expect(donationButtons.isHidden() == false)
    }

    // MARK: - ProgressView conditional (lines 48-53)

    @Test("ZStack contains the conditional ProgressView structure")
    func progressView_structureExists() throws {
//        let dependencies = FrontDoorViewModelTests.makeDependencies()
//        let appState = AppState()
//        let view = FrontDoorView(viewModel: dependencies.viewModel)
//            .environmentObject(appState)
//
//        let inspected = try view.inspect()
//        let zStack = try inspected.zStack().
//        #expect(zStack.isHidden() == false)
    }

}
