import Foundation

final class FakeExtensionContext: NSExtensionContext {

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

}
