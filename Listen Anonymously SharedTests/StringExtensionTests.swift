import Testing
@testable import Listen_Anonymously_Shared

struct StringExtensionTests {

    @Test("Audio file and name is not formatted when input string is less than 22 characters long")
    func shortName_doesNotHaveExpectedAudioFilename () {
        let shortName = "AUDIO-2025-07-07"

        #expect(shortName == shortName.formatAudioFileName())
    }

}

