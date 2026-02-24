import Foundation

final class FakeExtensionContext: NSExtensionContext, @unchecked Sendable {

    private var _leInputItems: [FakeNSExtensionItem] = []

    override var inputItems: [Any] {
        _leInputItems
    }

    private func withInvalidExtensionItems() -> FakeExtensionContext {
        _leInputItems = [.emptyWhatsappURL]
        return self
    }

    private func withValidExtensionItems() -> FakeExtensionContext {
        _leInputItems = [.validURL]
        return self
    }

    private func withRealExtensionItems() -> FakeExtensionContext {
        _leInputItems = [.validURLAndRealAudioFile]
        return self
    }

    private func withPublicIdentifierItems() -> FakeExtensionContext {
        _leInputItems = [.publicIdentifier]
        return self
    }

}

// MARK: - Helpers

extension FakeExtensionContext {
    static let invalidItemsContext: FakeExtensionContext = {
        FakeExtensionContext()
            .withInvalidExtensionItems()
    }()

    static let validItemsContext: FakeExtensionContext = {
        FakeExtensionContext()
            .withValidExtensionItems()
    }()

    static let realAudioItemsContext: FakeExtensionContext = {
        FakeExtensionContext()
            .withRealExtensionItems()
    }()

    static let publicIdentifierContext: FakeExtensionContext = {
        FakeExtensionContext()
            .withPublicIdentifierItems()
    }()
}
