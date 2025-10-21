import SwiftUI
import Testing
import ViewInspector
@testable import Listen_Anonymously_Shared

@MainActor
struct TextAndIconLabelTests {

    @Test func systemImageIsDisplayed_whenAvailable() throws {
        let textAndIconLabel = TextAndIconLabel(title: "bla", systemNameOrEmoji: "xmark")

        let inspectedImageName = try textAndIconLabel.inspect().hStack(0).view(SafeImage.self, 1).image(0).actualImage().name()

        #expect(inspectedImageName == "xmark")
    }

    @Test func noIconIsDisplayed_whenImageNameIsEmpty() throws {
        let textAndIconLabel = TextAndIconLabel(title: "bla", systemNameOrEmoji: "")

        do {
            _ = try textAndIconLabel.inspect().hStack(0).view(SafeImage.self, 1)
        } catch let error {
            #expect(error.localizedDescription.contains("is absent"))
        }
    }

}
