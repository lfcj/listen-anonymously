import Testing
@testable import Listen_Anonymously_Shared

@MainActor
struct SafeImageTests {

    @Test func safeImageDisplaysText_whenSystemImageDoesNotExist() throws {
        let content = SafeImageContent.resolve(name: "does-not-exist")
        #expect(content == .text("does-not-exist"))
    }

    @Test func safeImageDisplaysSystemImage_whenNameMatchesSystemCatalog() throws {
        let content = SafeImageContent.resolve(name: "xmark")
        #expect(content == .systemImage("xmark"))
    }

}
