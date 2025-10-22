import Listen_Anonymously_Shared
import Testing
import ViewInspector
@testable import Listen_anonymously

@MainActor
struct DonationButtonsViewTests {

    @Test func buyUsCoffee_ExecutesMethodWhenButtonIsTapped() throws {
        var buyUsCoffeeCalled = false
        let view = DonationButtonsView(
            buyUsCoffee: { buyUsCoffeeCalled = true },
            sendGoodVibes: {},
            superKindTip: {}
        )
        
        let buyUsCoffeeButton = try view
            .inspect()
            .vStack(0)
            .hStack(2)
            .view(TranslucentIconLabelButton.self, 0)
            .button(0)

        try buyUsCoffeeButton.tap()

        #expect(buyUsCoffeeCalled == true)
    }

    @Test func sendGoodVibes_ExecutesMethodWhenButtonIsTapped() throws {
        var sendGoodVibesCalled = false
        let view = DonationButtonsView(
            buyUsCoffee: {},
            sendGoodVibes: { sendGoodVibesCalled = true },
            superKindTip: {}
        )
        
        let sendGoodVibesButton = try view
            .inspect()
            .vStack(0)
            .hStack(2)
            .view(TranslucentIconLabelButton.self, 1)
            .button(0)

        try sendGoodVibesButton.tap()

        #expect(sendGoodVibesCalled == true)
    }

    @Test func sendSuperKindTip_ExecutesMethodWhenButtonIsTapped() throws {
        var sendSuperKindTip = false
        let view = DonationButtonsView(
            buyUsCoffee: {},
            sendGoodVibes: {},
            superKindTip: { sendSuperKindTip = true },
        )
        
        let sendSuperKindTipButton = try view
            .inspect()
            .vStack(0)
            .view(TranslucentIconLabelButton.self, 3)
            .button(0)

        try sendSuperKindTipButton.tap()

        #expect(sendSuperKindTip == true)
    }

}
