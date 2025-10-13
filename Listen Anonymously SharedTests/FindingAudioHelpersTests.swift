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

    @Test("load audio cannot load item when it is not valid")
    func findAudio_findsAudioFileInformationWithSpecificAudioTypeIdentifiers() async throws {
        do {
            let audioFileInformation = try await FindingAudioHelpers.loadAudioURL(in: makeFakeExtensionItemWithEmptyItem())
            #expect(audioFileInformation.title == "This should never be executed as we expect a thrown error")
        } catch let error as FindingAudioError {
            #expect(error == FindingAudioError.couldNotConvertLoadedItemToURL)
        }
    
    }

}

// MARK: - Helpers

private extension FindingAudioHelpersTests {

    func makeFakeExtensionItemWithEmptyItem() -> FakeNSExtensionItem {
        FakeNSExtensionItem()
    }
}
