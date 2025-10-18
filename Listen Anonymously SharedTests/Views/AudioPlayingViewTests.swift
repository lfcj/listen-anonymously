import SwiftUI
import Testing
import ViewInspector
@testable import Listen_Anonymously_Shared

@MainActor
struct AudioPlayingViewTests {
    
    @Test func containsProgressViewWhenManagerIsLoading() throws {
        let manager = AudioPlayingManager(extensionContext: nil, isLoadingAudio: true)
        let view = AudioPlayingView(playingManager: manager)
        #expect(manager.isLoadingAudio == true)
        let loadingView = try view.inspect().zStack(0).view(AudioLoadingView.self, 1)
        
        #expect(loadingView.isHidden() == false)
    }

    @Test func containsPlayingAnimationView() throws {
        let manager = AudioPlayingManager(extensionContext: nil)
        let view = AudioPlayingView(playingManager: manager)
        let playingAnimationView = try view.inspect().zStack(0).vStack(0).view(PlayingAnimationView.self, 1)

        #expect(playingAnimationView.isHidden() == false)
    }

    @Test func hasCorrectFrameModifiers() throws {
        let view = AudioLoadingView()
        let inspectedView = try view.inspect()
        
        #expect(try inspectedView.vStack().fixedFrame().height == 100)
        #expect(try inspectedView.vStack().fixedFrame().width == 100)
        #expect(try inspectedView.vStack().padding() == .init(top: 10, leading: 10, bottom: 10, trailing: 10))
    }

}
