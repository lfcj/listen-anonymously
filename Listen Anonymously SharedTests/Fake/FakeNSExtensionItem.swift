import Foundation

class FakeNSExtensionItem: NSExtensionItem {
    private static let audioItem: NSSecureCoding = {
        let fakeAudioDataItem = Data([0x00, 0x01, 0x02, 0x03])
        return fakeAudioDataItem as NSSecureCoding
    }()
    override var attachments: [NSItemProvider]? {
        get {
            [
                NSItemProvider(item: Self.audioItem, typeIdentifier: "com.apple.m4a-audio")
            ]
        }
        set {}
    }
}
