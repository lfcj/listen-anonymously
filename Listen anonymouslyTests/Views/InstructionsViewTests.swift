import SwiftUI
import Testing
import ViewInspector
@testable import Listen_anonymously

@MainActor
struct InstructionsViewTests {

    @Test func pickerIsShownWhenThereIsMoreThanOneSupportedApp() throws {
        let viewModel = InstructionsViewModel()
        viewModel.supportedApps = [.telegram, .whatsApp]
        let view = InstructionsView(viewModel: viewModel)

        let picker = try view.inspect().zStack().vStack(1).vStack(1).picker(0)

        let appText1 = try picker.forEach(0).text(0).string()
        let appText2 = try picker.forEach(0).text(1).string()

        let appsTexts: Set<String> = Set([appText1, appText2])
        #expect(appsTexts == ["WhatsApp", "Telegram"])
    }

    @Test func instructionsShownReflectSelectedApp() throws {
        let viewModel = InstructionsViewModel()
        viewModel.supportedApps = [.telegram, .whatsApp]
        viewModel.selectedApp = .telegram
        let view = InstructionsView(viewModel: viewModel)

        let telegramInstructions = try view.inspect().zStack().vStack(1).view(TelegramInstructionsStepsView.self, 2)

        #expect(telegramInstructions.isHidden() == false)
    }

}
