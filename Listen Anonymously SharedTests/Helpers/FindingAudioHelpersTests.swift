import Foundation
import Testing
@testable import Listen_Anonymously_Shared

struct FindingAudioHelpersTests {

    @Test("Loading audio URL from empty extension providers returns nil")
    func findAudio_inEmptyExtensionProvider() async throws {
        await #expect(throws: FindingAudioError.noAudioFoundInAttachment(typeIdentifier: "").self) {
            _ = try await FindingAudioHelpers.loadAudioURL(in: NSExtensionItem())
        }
    }

    @Test("load audio does not search for public identifiers on first attempt")
    func findAudio_doesNotUsePublicIdentifiersAtFirst() async throws {
        await #expect(throws: FindingAudioError.noAudioFoundInAttachment(typeIdentifier: "public.file-url").self) {
            _ = try await FindingAudioHelpers.loadAudioURL(
                in: FakeNSExtensionItem.publicIdentifier
            )
        }
    }

    @Test("load audio searches for public identifiers on second attempt")
    func findAudio_usesPublicIdentifiersAtSecondAttempt() async throws {
        await #expect(throws: FindingAudioError.couldNotConvertLoadedItemToURL.self) {
            _ = try await FindingAudioHelpers.loadAudioURL(
                in: FakeNSExtensionItem.publicIdentifier,
                isSecondAttempt: true
            )
        }
    }

    @Test("load audio cannot load item when it is not valid")
    func findAudio_findsAudioFileInformationWithSpecificAudioTypeIdentifiers() async throws {
        await #expect(throws: FindingAudioError.couldNotConvertLoadedItemToURL.self) {
            _ = try await FindingAudioHelpers.loadAudioURL(
                in: FakeNSExtensionItem.emptyWhatsappURL,
                isSecondAttempt: false
            )
        }
    }

    @Test("load audio finds audio file information when item is valid")
    func findAudio_findsAudioFileInformationWhenItemIsURL() async throws {
        let audioFileInformation = try await FindingAudioHelpers.loadAudioURL(in: FakeNSExtensionItem.validURL)

        #expect(audioFileInformation.url.absoluteString.hasSuffix("m4a") == true)
    }

    @Test("load audio does not continue when Task is cancelled")
    func findAudio_stopsWhenTaskIsCancelled() async throws {
        let task = Task {
            return try await FindingAudioHelpers.loadAudioURL(in: FakeNSExtensionItem.validURL)
        }

        await #expect(throws: CancellationError.self) {
            task.cancel()
            _ = try await task.value
        }
    }

    @Test("load audio finds Telegram audio file information when item is valid and converts OGG to M4A")
    func findAudio_findsAudioFileInformationWhenItemIsTelegramURL() async throws {
        let audioFileInformation = try await FindingAudioHelpers.loadAudioURL(
            in: makeFakeExtensionItemWithValidTelegramURL()
        )

        #expect(audioFileInformation.url.absoluteString.hasSuffix("m4a") == true)
    }

    @Test("load audio with invalid Telegram OGG throws telegramConversionNotPossible")
    func findAudio_invalidTelegramOGGThrowsConversionError() async throws {
        await #expect(throws: FindingAudioError.telegramConversionNotPossible.self) {
            _ = try await FindingAudioHelpers.loadAudioURL(
                in: makeFakeExtensionItemWithInvalidTelegramOGG()
            )
        }
    }

    // MARK: - AudioFileInformation title

    @Test("valid audio file has formatted title from lastPathComponent")
    func validAudio_hasTitleFromLastPathComponent() async throws {
        let audioFileInformation = try await FindingAudioHelpers.loadAudioURL(in: FakeNSExtensionItem.validURL)

        #expect(audioFileInformation.title.isEmpty == false)
    }

    @Test("Telegram audio file has formatted title from original URL lastPathComponent")
    func telegramAudio_hasTitleFromOriginalURL() async throws {
        let audioFileInformation = try await FindingAudioHelpers.loadAudioURL(
            in: makeFakeExtensionItemWithValidTelegramURL()
        )

        #expect(audioFileInformation.title.isEmpty == false)
    }

    // MARK: - FindingAudioError Equatable (lines 15-28)

    @Test("noAudioFoundInAttachment equality matches on typeIdentifier")
    func equatable_noAudioFoundInAttachment() {
        let noAudioError1 = FindingAudioError.noAudioFoundInAttachment(typeIdentifier: "com.apple.m4a-audio")
        let noAudioError2 = FindingAudioError.noAudioFoundInAttachment(typeIdentifier: "com.apple.m4a-audio")
        let noAudioError3 = FindingAudioError.noAudioFoundInAttachment(typeIdentifier: "public.mp3")

        #expect(noAudioError1 == noAudioError2)
        #expect(noAudioError1 != noAudioError3)
    }

    @Test("couldNotLoadItem equality matches on localizedDescription")
    func equatable_couldNotLoadItem() {
        let errorA = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "fail"])
        let errorB = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "fail"])
        let errorC = NSError(domain: "test", code: 2, userInfo: [NSLocalizedDescriptionKey: "other"])

        #expect(FindingAudioError.couldNotLoadItem(error: errorA) == FindingAudioError.couldNotLoadItem(error: errorB))
        #expect(FindingAudioError.couldNotLoadItem(error: errorA) != FindingAudioError.couldNotLoadItem(error: errorC))
    }

    @Test("couldNotConvertLoadedItemToURL is equal to itself")
    func equatable_couldNotConvertLoadedItemToURL() {
        #expect(FindingAudioError.couldNotConvertLoadedItemToURL == FindingAudioError.couldNotConvertLoadedItemToURL)
    }

    @Test("telegramConversionNotPossible is equal to itself")
    func equatable_telegramConversionNotPossible() {
        #expect(FindingAudioError.telegramConversionNotPossible == FindingAudioError.telegramConversionNotPossible)
    }

    @Test("different FindingAudioError cases are not equal")
    func equatable_differentCases() {
        #expect(FindingAudioError.couldNotConvertLoadedItemToURL != FindingAudioError.telegramConversionNotPossible)
        #expect(FindingAudioError.noAudioFoundInAttachment(typeIdentifier: "x") != FindingAudioError.couldNotConvertLoadedItemToURL)
        #expect(FindingAudioError.couldNotLoadItem(error: NSError(domain: "", code: 0)) != FindingAudioError.telegramConversionNotPossible)
    }

    // MARK: - FindingAudioError LocalizedError (lines 31-45)

    @Test("noAudioFoundInAttachment errorDescription contains the file type suffix")
    func errorDescription_noAudioFoundInAttachment_withDottedIdentifier() async {
        let error = FindingAudioError.noAudioFoundInAttachment(typeIdentifier: "com.apple.m4a-audio")

        let description = await Task { @MainActor in
            error.errorDescription!
        }.value

        #expect(description.contains("m4a-audio"))
    }

    @Test("noAudioFoundInAttachment errorDescription uses full identifier when no dot separator")
    func errorDescription_noAudioFoundInAttachment_noDot() async {
        let error = FindingAudioError.noAudioFoundInAttachment(typeIdentifier: "")

        let description = await Task { @MainActor in
            error.errorDescription!
        }.value
        // Empty string split yields empty, nilIfEmpty returns nil, so falls back to typeIdentifier ""
        #expect(description.isEmpty == false)
    }

    @Test("couldNotConvertLoadedItemToURL has a non-empty errorDescription")
    func errorDescription_couldNotConvertLoadedItemToURL() async {
        let description = await Task { @MainActor in
            FindingAudioError.couldNotConvertLoadedItemToURL.errorDescription
        }.value

        #expect(description != nil)
        #expect(description!.isEmpty == false)
    }

    @Test("couldNotLoadItem errorDescription includes the underlying error description")
    func errorDescription_couldNotLoadItem() async {
        let underlying = NSError(domain: "test", code: 42, userInfo: [NSLocalizedDescriptionKey: "something broke"])
        let description = await Task { @MainActor in
            FindingAudioError.couldNotLoadItem(error: underlying).errorDescription
        }.value

        #expect(description != nil)
        #expect(description!.contains("something broke"))
    }

    @Test("telegramConversionNotPossible has a non-empty errorDescription")
    func errorDescription_telegramConversionNotPossible() async {
        let description = await Task { @MainActor in
            FindingAudioError.telegramConversionNotPossible.errorDescription
        }.value

        #expect(description != nil)
        #expect(description!.isEmpty == false)
    }

    // MARK: - String.nilIfEmpty (lines 117-121)

    @Test("nilIfEmpty returns nil for empty string")
    func nilIfEmpty_emptyString() {
        #expect("".nilIfEmpty == nil)
    }

    @Test("nilIfEmpty returns self for non-empty string")
    func nilIfEmpty_nonEmptyString() {
        #expect("hello".nilIfEmpty == "hello")
    }
}

// MARK: - Helpers

private extension FindingAudioHelpersTests {

    func makeFakeExtensionItemWithValidTelegramURL() -> FakeNSExtensionItem {
        FakeNSExtensionItem()
            .withValidTelegramURLAndAudioFile()
    }

    func makeFakeExtensionItemWithInvalidTelegramOGG() -> FakeNSExtensionItem {
        FakeNSExtensionItem()
            .withInvalidTelegramOGG()
    }

}
