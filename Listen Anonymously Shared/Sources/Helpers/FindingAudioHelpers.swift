import Foundation
import SwiftOGG

struct AudioFileInformation {
    let url: URL
    let title: String
}

enum FindingAudioError: Error, Equatable {
    case noAudioFoundInAttachment(typeIdentifier: String)
    case couldNotLoadItem(error: Error)
    case couldNotConvertLoadedItemToURL
    case telegramConversionNotPossible

    static func == (lhs: FindingAudioError, rhs: FindingAudioError) -> Bool {
        switch (lhs, rhs) {
        case (.noAudioFoundInAttachment(let lhsTypeID), .noAudioFoundInAttachment(let rhsTypeID)):
            return lhsTypeID == rhsTypeID
        case (.couldNotLoadItem(let lhsError), .couldNotLoadItem(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.couldNotConvertLoadedItemToURL, .couldNotConvertLoadedItemToURL):
            return true
        case (.telegramConversionNotPossible, .telegramConversionNotPossible):
            return true
        default:
            return false
        }
    }
}

extension FindingAudioError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noAudioFoundInAttachment(let typeIdentifier):
            let fileType = String(typeIdentifier.split(separator: ".").last ?? "").nilIfEmpty
            return "\(My.localizedString("NOT_FOUND_ATTACHMENT_ERROR")). \(My.localizedString("FOUND_TYPEIDENTIFIER")): \(fileType ?? typeIdentifier)"
        case .couldNotConvertLoadedItemToURL:
            return My.localizedString("COULD_NOT_READ_SHARED_ITEM")
        case .couldNotLoadItem(let error):
            return "\(My.localizedString("UNKNOWN_ERROR")): \(error.localizedDescription)"
        case .telegramConversionNotPossible:
            return My.localizedString("TELEGRAM_CONVERSION_ERROR")
        }
    }
}

struct FindingAudioHelpers {

    static let telegramTypeIdentifiers = ["dyn.age80835h", "org.xiph.ogg-media"]
    static let publicFileURLIdentifier = ["public.file-url"]
    static let audioTypeIdentifiers = ["com.apple.m4a-audio", "public.mp3", "com.apple.coreaudio-format", "public.wav", "public.m4a"]
    static let typeIdentifiers = telegramTypeIdentifiers + audioTypeIdentifiers

    static func loadAudioURL(in item: NSExtensionItem, isSecondAttempt: Bool = false) async throws -> AudioFileInformation {
        guard let (audioAttachment, audioTypeIdentifier) = findAudioAttachment(in: item.attachments, isSecondAttempt: isSecondAttempt) else {
            throw FindingAudioError.noAudioFoundInAttachment(
                typeIdentifier: item.attachments?.flatMap { $0.registeredTypeIdentifiers }.joined(separator: ",") ?? ""
            )
        }

        try Task.checkCancellation()
        return try await loadAudioItemType(identifier: audioTypeIdentifier, from: audioAttachment)
    }

    private static func findAudioAttachment(in attachments: [NSItemProvider]?, isSecondAttempt: Bool = false) -> (NSItemProvider, String)? {
        var result: (NSItemProvider, String)?
        let identifiers = isSecondAttempt ? publicFileURLIdentifier : typeIdentifiers
        attachments?.forEach { attachment in
            if let matchingAudioIdentifier = identifiers.first(where: { attachment.hasItemConformingToTypeIdentifier($0) }) {
                result = (attachment, matchingAudioIdentifier)
            }
        }

        return result
    }

    private static func loadAudioItemType(identifier: String, from audioAttachment: NSItemProvider) async throws -> AudioFileInformation {
        try Task.checkCancellation()
        do {
            let loadedItem = try await audioAttachment.loadItem(forTypeIdentifier: identifier, options: nil)
            guard let audioURL = loadedItem as? URL else {
                // Log error showing loadedItem to see why it cannot be turned into URL
                throw FindingAudioError.couldNotConvertLoadedItemToURL
            }

            if Self.telegramTypeIdentifiers.contains(identifier) {
                return try handleTelegram(audioURL: audioURL)
            } else {
                return AudioFileInformation(url: audioURL, title: audioURL.lastPathComponent.formatAudioFileName())
            }
        } catch let error {
            if error is FindingAudioError {
                throw error
            } else {
                throw FindingAudioError.couldNotLoadItem(error: error)
            }
        }
    }

    private static func handleTelegram(audioURL: URL) throws -> AudioFileInformation {
        let copyAudioURL = FileManager.createTemporaryFileURL(fileExtension: "ogg")
        let convertedAudioURL = FileManager.createTemporaryFileURL(fileExtension: "m4a")
        do {
            try FileManager.default.copyItem(at: audioURL, to: copyAudioURL)
            try OGGConverter.convertOpusOGGToM4aFile(src: copyAudioURL, dest: convertedAudioURL)
        } catch {
            throw FindingAudioError.telegramConversionNotPossible
        }
        return AudioFileInformation(url: convertedAudioURL, title: audioURL.lastPathComponent.formatAudioFileName())
        // swiftlint:disable todo
        // TODO: NAME CAN BE DIFFERENT IN TELEGRAM, FORMAT IT FOR IT.
        // swiftlint:enable todo
    }

}

extension String {
    var nilIfEmpty: String? {
        return isEmpty ? nil : self
    }
}
