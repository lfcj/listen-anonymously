import SwiftUI
import Testing
import ViewInspector
@testable import Listen_Anonymously_Shared

@MainActor
struct AudioLoadingViewTests {

    @Test func containsLoadingText() throws {
        let view = AudioLoadingView()
        let text = try view.inspect().vStack().text(0)
        let textValue = try text.string()

        #expect(textValue == My.localizedString("LOADING"))
    }

    @Test func containsProgressView() throws {
        let view = AudioLoadingView()
        let progressView = try view.inspect().vStack().progressView(1)

        #expect(progressView.isHidden() == false)
    }

    @Test func hasCorrectFrameModifiers() throws {
        let view = AudioLoadingView()
        let inspectedView = try view.inspect()

        #expect(try inspectedView.vStack().fixedFrame().height == 100)
        #expect(try inspectedView.vStack().fixedFrame().width == 100)
        #expect(try inspectedView.vStack().padding() == .init(top: 10, leading: 10, bottom: 10, trailing: 10))
    }

}
