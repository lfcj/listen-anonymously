import Listen_Anonymously_Shared
import Testing

struct SafeImageTests {

    @Test func safeImageDisplaysText_whenSystemImageDoesNotExist() throws {
        let content = SafeImageContent.resolve(name: "does-not-exist", systemImageExists: { _ in false })
        #expect(content == .text("does-not-exist"))
    }

    @Test func safeImageDisplaysSystemImage_whenNameMatchesSystemCatalog() throws {
        let content = SafeImageContent.resolve(name: "xmark", systemImageExists: { _ in true })
        #expect(content == .systemImage("xmark"))
    }

}
