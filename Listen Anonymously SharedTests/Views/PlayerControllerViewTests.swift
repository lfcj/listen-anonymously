import Testing
import ViewInspector
@testable import Listen_Anonymously_Shared

@MainActor
struct PlayerControllerViewTests {

    @Test func initialButtonIsPlayIcon() throws {
        let manager = AudioPlayingManager(extensionContext: nil)

        let view = PlayerControllerView(viewModel: PlayerControllerViewModel(playingManager: manager))
        let inspectedButtonImageName = try view.inspect().vStack()
            .hStack(2)
            .view(PlayingViewButton.self, 1)
            .button(0)
            .labelView()
            .image(0)
            .actualImage()
            .name()

        #expect(inspectedButtonImageName == "play.fill")
    }
 
}

