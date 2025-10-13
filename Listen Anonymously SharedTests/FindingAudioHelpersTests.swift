import Foundation
import Testing
@testable import Listen_Anonymously_Shared

struct FindingAudioHelpersTests {
    
    @Test("Loading audio URL from empty extension providers returns nil")
    func findAudio_inEmptyExtensionProvider() async throws {
        do {
            let audioFileInformation = try await FindingAudioHelpers.loadAudioURL(in: NSExtensionItem())
            #expect(audioFileInformation.title == "This should never be executed as we expect a thrown error")
        } catch let error as FindingAudioError {
            #expect(error == FindingAudioError.noAttachmentFound)
        }
    }

    @Test("load audio does not search for public identifiers on first attempt")
    func findAudio_doesNotUsePublicIdentifiersAtFirst() async throws {
        do {
            let audioFileInformation = try await FindingAudioHelpers.loadAudioURL(
                in: makeFakeExtensionItemWithFakeAudioItemAndPublicIdentifier()
            )
            #expect(audioFileInformation.title == "This should never be executed as we expect a thrown error")
        } catch let error as FindingAudioError {
            #expect(error == FindingAudioError.noAttachmentFound)
        }
    }

    @Test("load audio searches for public identifiers on second attempt")
    func findAudio_usesPublicIdentifiersAtSecondAttempt() async throws {
        do {
            let audioFileInformation = try await FindingAudioHelpers.loadAudioURL(
                in: makeFakeExtensionItemWithFakeAudioItemAndPublicIdentifier(),
                isSecondAttempt: true
            )
            #expect(audioFileInformation.title == "This should never be executed as we expect a thrown error")
        } catch let error as FindingAudioError {
            #expect(error == FindingAudioError.couldNotConvertLoadedItemToURL)
        }
    }

    @Test("load audio cannot load item when it is not valid")
    func findAudio_findsAudioFileInformationWithSpecificAudioTypeIdentifiers() async throws {
        do {
            let audioFileInformation = try await FindingAudioHelpers.loadAudioURL(
                in: makeFakeExtensionItemWithFakeAudioItem(),
                isSecondAttempt: false
            )
            #expect(audioFileInformation.title == "This should never be executed as we expect a thrown error")
        } catch let error as FindingAudioError {
            #expect(error == FindingAudioError.couldNotConvertLoadedItemToURL)
        }
    }

    @Test("load audio finds audio file information when item is valid")
    func findAudio_findsAudioFileInformationWhenItemIsURL() async throws {
        let audioFileInformation = try await FindingAudioHelpers.loadAudioURL(
            in: makeFakeExtensionItemWithValidURL()
        )

        #expect(audioFileInformation.url.absoluteString.hasSuffix("m4a") == true)
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

    func makeFakeExtensionItemWithFakeAudioItemAndPublicIdentifier() -> FakeNSExtensionItem {
        FakeNSExtensionItem()
            .withPublicIdentifierAndEmptyAudioAttachment()
    }

    func makeFakeExtensionItemWithFakeAudioItem() -> FakeNSExtensionItem {
        FakeNSExtensionItem()
            .withWhatsappEmptyAudioAttachment()
    }

    func makeFakeExtensionItemWithValidURL() -> FakeNSExtensionItem {
        FakeNSExtensionItem()
            .withValidURLAndAudioFile()
    }

    func makeFakeExtensionItemWithValidTelegramURL() -> FakeNSExtensionItem {
        FakeNSExtensionItem()
            .withValidTelegramURLAndAudioFile()
    }

}
