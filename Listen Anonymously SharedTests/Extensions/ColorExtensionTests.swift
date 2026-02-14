import Foundation
import SwiftUI
import Testing
import Listen_Anonymously_Shared

struct ColorExtensionTests {

    @Test("Black color is created correctly")
    func blackColor_isCreatedCorrectlyUsingHEX() {
        let blackColor = Color(hex: 0x000000)

        #expect(blackColor == .black)
    }

    @Test("White color is created correctly")
    func whiteColor_isCreatedCorrectlyUsingHEX() {
        let whiteColor = Color(hex: 0xFFFFFF)

        #expect(whiteColor == .white)
    }

    @Test("Black color with opacity is created correctly")
    func blackColor_isCreatedCorrectlyUsingHEXAndOpacityDifferentToOne() {
        let blackColor = Color(hex: 0x000000, opacity: 0.5)

        #expect(UIColor(blackColor).cgColor.alpha == 0.5)
    }

    @Test("Random color is created correctly")
    func randomColor_isMappedCorrectly() {
        let randomColor = Color(hex: 0x999999, opacity: 0.3)

        let randomCGColor = UIColor(randomColor).cgColor
        guard let comps = randomCGColor.components, comps.count >= 4 else {
            Issue.record("Expected RGBA components")
            return
        }
        let tolerance: CGFloat = 0.0001
        #expect(abs(comps[0] - 0.6) < tolerance)
        #expect(abs(comps[1] - 0.6) < tolerance)
        #expect(abs(comps[2] - 0.6) < tolerance)
        #expect(abs(comps[3] - 0.3) < tolerance)
    }

}
