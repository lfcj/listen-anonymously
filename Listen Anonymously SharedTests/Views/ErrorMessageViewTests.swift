import Testing
import ViewInspector
@testable import Listen_Anonymously_Shared

@MainActor
struct ErrorMessageViewTests {
    
    @Test func displaysGivenErrorMessage() throws {
        let expectedMessage = "Test error"
        let view = ErrorMessageView(errorMessage: expectedMessage, onRetry: {})

        let errorMessageText = try view.inspect().vStack(0).text(1)

        #expect(try errorMessageText.string() == expectedMessage)
    }

    @Test func onRetry_isExecutedWhenButtonIsTapped() throws {
        var onRetryCallCount = 0
        let view = ErrorMessageView(errorMessage: "", onRetry: { onRetryCallCount += 1 })

        let retryButton = try view.inspect().vStack(0).button(2)
        try retryButton.tap()

        #expect(onRetryCallCount == 1)
    }

}
