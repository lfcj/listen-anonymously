import Foundation

class FakeNSExtensionItem: NSExtensionItem, @unchecked Sendable {
    private static let audioData: Data = {
        let fakeAudioDataItem = Data([0x00, 0x01, 0x02, 0x03])
        return fakeAudioDataItem
    }()

    private var _leAttachments: [NSItemProvider] = []

    override var attachments: [NSItemProvider]? {
        get { _leAttachments}
        set {}
    }

    private func withWhatsAppEmptyAudioAttachment() -> FakeNSExtensionItem {
        _leAttachments = [
            NSItemProvider(item: Self.audioData as NSSecureCoding, typeIdentifier: "com.apple.m4a-audio")
        ]
        return self
    }

    private func withPublicIdentifierAndEmptyAudioAttachment() -> FakeNSExtensionItem {
        _leAttachments = [
            NSItemProvider(item: Self.audioData as NSSecureCoding, typeIdentifier: "public.file-url")
        ]
        return self
    }

    private func withValidURLAndDummyAudioFile() -> FakeNSExtensionItem {
        // Create a temporary file with a valid URL
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("AUDIO-2025-05-01-14-27" + UUID().uuidString)
            .appendingPathExtension("m4a")

        // Write some fake data to the file
        let fakeData = Data([0x00, 0x01, 0x02, 0x03])
        try? fakeData.write(to: tempURL)

        _leAttachments = [
            NSItemProvider(item: tempURL as NSURL, typeIdentifier: "com.apple.m4a-audio")
        ]

        return self
    }

    private func withValidURLAndRealAudioFile() -> FakeNSExtensionItem {
        let realURL = Bundle(for: Self.self).url(forResource: "AUDIO-2024-02-23-14-21-50", withExtension: "mp3")!

        _leAttachments = [
            NSItemProvider(item: realURL as NSURL, typeIdentifier: "com.apple.m4a-audio")
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
    static let emptyWhatsappURL: FakeNSExtensionItem = {
        FakeNSExtensionItem()
            .withWhatsAppEmptyAudioAttachment()
    }()

    static let validURL: FakeNSExtensionItem = {
        FakeNSExtensionItem()
            .withValidURLAndDummyAudioFile()
    }()

    static let validURLAndRealAudioFile: FakeNSExtensionItem = {
        FakeNSExtensionItem()
            .withValidURLAndRealAudioFile()
    }()

    static let publicIdentifier: FakeNSExtensionItem = {
        FakeNSExtensionItem()
            .withPublicIdentifierAndEmptyAudioAttachment()
    }()
}
