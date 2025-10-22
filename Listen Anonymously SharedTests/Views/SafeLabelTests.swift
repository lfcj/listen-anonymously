import Testing
import ViewInspector
@testable import Listen_Anonymously_Shared

@MainActor
struct SafeLabelTests {

    @Test func safeLabelDisplaysText_whenSystemImageDoesNotExist() throws {
        let labelView = SafeLabel(title: "bla", icon: "does-not-exist")

        let inspectedTextString = try labelView.inspect().label(0).icon().text(0).string()

        #expect(inspectedTextString == "does-not-exist")
    }

    @Test func safeLabelDisplaysSystemImage_whenNameMatchesSystemCatalog() throws {
        let imageView = SafeLabel(title: "bla", icon: "xmark")

        let inspectedImageName = try imageView.inspect().label(0).icon().image(0).actualImage().name()

        #expect(inspectedImageName == "xmark")
    }

}
