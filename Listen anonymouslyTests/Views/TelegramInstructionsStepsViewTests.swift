import Listen_Anonymously_Shared
import SwiftUI
import Testing
import ViewInspector
@testable import Listen_anonymously

@MainActor
struct TelegramInstructionsStepsViewTests {

    @Test("Telegram has four instructions")
    func telegram_displaysFourInstructions() throws {
        let view = TelegramInstructionsStepsView()

        let fourthText = try view.inspect().vStack(0).view(TextAndIconLabel.self, 3).hStack(0).text(0).string()

        #expect(fourthText == "4. Scroll down and tap on:")
    }

}
