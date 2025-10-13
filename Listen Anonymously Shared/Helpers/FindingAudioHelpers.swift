import Foundation

struct AudioFileInformation {
    let url: URL
    let title: String
}

enum FindingAudioError: Error {
    case noAttachmentFound
    case couldNotConvertLoadedItemToURL
    case telegramConversionNotPossible
    case noAudioFoundInAttachment
}

extension FindingAudioError {
    var localizedDescription: String {
        "This is an error"
    }
}

struct FindingAudioHelpers {

    static let telegramTypeIdentifiers = ["dyn.age80835h", "org.xiph.ogg-media"]
    static let publicFileURLIdentifier = ["public.file-url"]
    static let audioTypeIdentifiers = ["com.apple.m4a-audio", "public.mp3", "com.apple.coreaudio-format", "public.wav", "public.m4a"]
    static let typeIdentifiers = telegramTypeIdentifiers + audioTypeIdentifiers

    static func loadAudioURL(in item: NSExtensionItem, isSecondAttempt: Bool = false) async throws -> AudioFileInformation {
        guard let (audioAttachment, audioTypeIdentifier) = findAudioAttachment(in: item.attachments, isSecondAttempt: isSecondAttempt) else {
            throw FindingAudioError.noAttachmentFound
        }

        return try await loadAudioItemType(identifier: audioTypeIdentifier, from: audioAttachment)
    }
 
    private static func findAudioAttachment(in attachments: [NSItemProvider]?, isSecondAttempt: Bool = false) -> (NSItemProvider, String)? {
        var result: (NSItemProvider, String)? = nil
        let identifiers = isSecondAttempt ? publicFileURLIdentifier : typeIdentifiers
        attachments?.forEach { attachment in
            if let matchingAudioIdentifier = identifiers.first(where: { attachment.hasItemConformingToTypeIdentifier($0) }) {
                result = (attachment, matchingAudioIdentifier)
            }
        }

        return result
    }

    private static func loadAudioItemType(identifier: String, from audioAttachment: NSItemProvider) async throws -> AudioFileInformation {
        guard let audioURL = try await audioAttachment.loadItem(forTypeIdentifier: identifier, options: nil) as? URL else {
            throw FindingAudioError.couldNotConvertLoadedItemToURL
        }
        
        if Self.telegramTypeIdentifiers.contains(identifier) {
            return try handleTelegram(audioURL: audioURL)
        } else {
            return AudioFileInformation(url: audioURL, title: audioURL.lastPathComponent.formatAudioFileName())
        }
    }

    private static func handleTelegram(audioURL: URL) throws -> AudioFileInformation {
        let copyAudioURL = FileManager.createTemporaryFileURL(fileExtension: "ogg")
        let convertedAudioURL = FileManager.createTemporaryFileURL(fileExtension: "m4a")
        do {
            try FileManager.default.copyItem(at: audioURL, to: copyAudioURL)
        } catch {
            throw FindingAudioError.telegramConversionNotPossible
        }
        
        // Need OGG converter
        return AudioFileInformation(url: audioURL, title: audioURL.lastPathComponent)
    }

}
