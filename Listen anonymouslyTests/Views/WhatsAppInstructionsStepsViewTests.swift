import Listen_Anonymously_Shared
import Testing
import ViewInspector
@testable import Listen_anonymously

@MainActor
struct WhatsAppInstructionsStepsViewTests {

    @Test("WhatsApp has three instructions")
    func whatsApp_displaysFourInstructions() throws {
        let view = WhatsAppInstructionsStepsView()

        let fourthText = try view.inspect().vStack(0).view(TextAndIconLabel.self, 3).hStack(0).text(0).string()

        #expect(fourthText == "4. Scroll down and tap on:")
    }

}
