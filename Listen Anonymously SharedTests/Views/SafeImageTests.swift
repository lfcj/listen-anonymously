import Testing
import ViewInspector
@testable import Listen_Anonymously_Shared

@MainActor
struct SafeImageTests {

    @Test func safeImageDisplaysText_whenSystemImageDoesNotExist() throws {
        let imageView = SafeImage(name: "does-not-exist")

        let inspectedTextString = try imageView.inspect().text(0).string()

        #expect(inspectedTextString == "does-not-exist")
    }

    @Test func safeImageDisplaysSystemImage_whenNameMatchesSystemCatalog() throws {
        let imageView = SafeImage(name: "xmark")

        let inspectedImageName = try imageView.inspect().image(0).actualImage().name()

        #expect(inspectedImageName == "xmark")
    }

}
