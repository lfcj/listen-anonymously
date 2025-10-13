import Testing
import SwiftUI
import ViewInspector
@testable import Listen_Anonymously_Shared

@MainActor
struct PlayingAnimationViewTests {

    @State var staticFalseIsPlaying: Bool = false
    @State var staticTrueIsPlaying: Bool = false

    @Test func containsImageOnTopOfCircle() throws {
        let view = makeView(isPlaying: false)

        let zStack = try view.inspect().zStack(0)

        let circle = try zStack.shape(0)
        let circleFrame = try circle.fixedFrame()
        let image = try zStack.image(1)
        let imageFrame = try image.fixedFrame()

        #expect(circleFrame.height == 80)
        #expect(circleFrame.width == 80)

        #expect(imageFrame.height == 40)
        #expect(imageFrame.width == 40)
    }

    @Test func anonIconImageIsScaledToFitAndWhite() throws {
        let view = makeView(isPlaying: false)

        let image = try view.inspect().zStack(0).image(1)
        let imageColor = try image.modifier(_ForegroundStyleModifier<Color>.self, 0).actualView().style

        #expect(try image.isScaledToFit())
        #expect(imageColor == .white)
    }

    @Test func testScaleEffectWhenNotPlaying() throws {
        let view = makeView(isPlaying: false)

        let zStackScaleEffect = try view.inspect().zStack(0).scaleEffect()

        #expect(zStackScaleEffect.height == 2.5)
        #expect(zStackScaleEffect.width == 2.5)
    }

}

// MARK: - Helpers

private extension PlayingAnimationViewTests {

    func makeView(isPlaying: Bool) -> PlayingAnimationView {
        var isPlaying = isPlaying
        let binding = Binding(
            get: { isPlaying },
            set: { isPlaying = $0 }
        )
  
        return PlayingAnimationView(isPlaying: binding)
    }

}
