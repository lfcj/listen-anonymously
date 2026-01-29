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

    @Test("load audio finds Telegram audio file information when item is valid")
    func findAudio_findsAudioFileInformationWhenItemIsTelegramURL() async throws {
        let audioFileInformation = try await FindingAudioHelpers.loadAudioURL(
            in: makeFakeExtensionItemWithValidTelegramURL()
        )

        #expect(audioFileInformation.url.absoluteString.hasSuffix("ogg") == true)
    }

}

// MARK: - Helpers

private extension FindingAudioHelpersTests {

    func makeFakeExtensionItemWithValidTelegramURL() -> FakeNSExtensionItem {
        FakeNSExtensionItem()
            .withValidTelegramURLAndAudioFile()
    }

}
