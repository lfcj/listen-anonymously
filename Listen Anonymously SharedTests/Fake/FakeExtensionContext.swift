import Foundation

final class FakeExtensionContext: NSExtensionContext {

    private var _leInputItems: [Any] = []

    override var inputItems: [Any] {
        _leInputItems
    }

    func withInvalidExtensionItems() -> FakeExtensionContext {
        _leInputItems = [
            FakeNSExtensionItem()
                .withWhatsappEmptyAudioAttachment()
        ]

        return self
    }

}

// MARK: - Helpers

extension FakeExtensionContext {
    static let invalidItemsContext: FakeExtensionContext = {
        FakeExtensionContext()
            .withInvalidExtensionItems()
    }()
}
