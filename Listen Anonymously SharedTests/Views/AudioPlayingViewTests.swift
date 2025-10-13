import Testing
import SwiftUI
import ViewInspector
@testable import Listen_Anonymously_Shared

@MainActor
struct AudioPlayingViewTests {
    
    @Test func containsProgressViewWhenManagerIsLoading() throws {
        let manager = AudioPlayingManager(extensionContext: nil, isLoadingAudio: true)
        let view = AudioPlayingView(playingManager: manager)
        let loadingView = try view.inspect().zStack(0).vStack(0).view(AudioLoadingView.self, 0)
        
        #expect(loadingView.isHidden() == false)
    }
    
}
