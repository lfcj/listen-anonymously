import Foundation

class FakeNSExtensionItem: NSExtensionItem {
    private static let audioItem: NSSecureCoding = {
        let fakeAudioDataItem = Data([0x00, 0x01, 0x02, 0x03])
        return fakeAudioDataItem as NSSecureCoding
    }()

    private var _leAttachments: [NSItemProvider] = []

    override var attachments: [NSItemProvider]? {
        get { _leAttachments}
        set {}
    }

    func withWhatsappEmptyAudioAttachment() -> FakeNSExtensionItem {
        _leAttachments = [
            NSItemProvider(item: Self.audioItem, typeIdentifier: "com.apple.m4a-audio")
        ]
        return self
    }

    func withPublicIdentifierAndEmptyAudioAttachment() -> FakeNSExtensionItem {
        _leAttachments = [
            NSItemProvider(item: Self.audioItem, typeIdentifier: "public.file-url")
        ]
        return self
    }

    func withValidURLAndAudioFile() -> FakeNSExtensionItem {
        // Create a temporary file with a valid URL
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("m4a")
        
        // Write some fake data to the file
        let fakeData = Data([0x00, 0x01, 0x02, 0x03])
        try? fakeData.write(to: tempURL)

        _leAttachments = [
            NSItemProvider(item: tempURL as NSURL, typeIdentifier: "com.apple.m4a-audio")
        ]

        return self
    }

    func withValidTelegramURLAndAudioFile() -> FakeNSExtensionItem {
        // Create a temporary file with a valid URL
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("ogg")

        // Write some fake data to the file
        let fakeData = Data([0x00, 0x01, 0x02, 0x03])
        try? fakeData.write(to: tempURL)

        _leAttachments = [
            NSItemProvider(item: tempURL as NSURL, typeIdentifier: "dyn.age80835h")
        ]

        return self
    }

}

extension FakeNSExtensionItem {
    static let validURL: FakeNSExtensionItem = {
        FakeNSExtensionItem()
            .withValidURLAndAudioFile()
    }()
}
