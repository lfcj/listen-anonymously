import Foundation
import Testing
@testable import Listen_Anonymously_Shared

struct StringExtensionTests {

    @Test("Audio filename is not formatted when input string is less than 22 characters long")
    func shortName_doesNotHaveExpectedAudioFilename() {
        let inputName = "AUDIO-"

        #expect(inputName == inputName.formatAudioFileName())
    }

    @Test("Audio filename is not formatted when input string does not start with AUDIO")
    func name_doesNotStartWithAUDIO() {
        let inputName = "FAUDIO-yyyy-MM-dd-HH-mm"

        #expect(inputName == inputName.formatAudioFileName())
    }

    @Test("Audio filename with non-expected date format does not get processed")
    func name_doesNotHaveExpectedDateFormat() {
        let inputName = "AUDIO-MM-dd-HH-mm-yyyy"

        #expect(inputName == inputName.formatAudioFileName())
    }

    @Test("Expected filename is formatted in EN")
    func filename_hasCorrectFormat_forEN() {
        let inputName = "AUDIO-2025-05-20-14-27"
        let expectedFileName = "Tue, May 20th, 2025 at 2:27 PM"
        #expect(expectedFileName == inputName.formatAudioFileName(locale: Locale(identifier: "en")))
    }

    @Test("Expected filename is formatted in ES")
    func filename_hasCorrectFormat_forES() {
        let inputName = "AUDIO-2025-05-20-14-27"
        let expectedFileName = "Mar, 20 May 2025, 14:27"
        #expect(expectedFileName == inputName.formatAudioFileName(locale: Locale(identifier: "es")))
    }

    @Test("Expected filename is formatted in DE")
    func filename_hasCorrectFormat_forDE() {
        let inputName = "AUDIO-2025-05-20-14-27"
        let expectedFileName = "Di. 20. Mai 2025, 14:27"
        #expect(expectedFileName == inputName.formatAudioFileName(locale: Locale(identifier: "de")))
    }

    @Test("Expected filename is formatted in IT")
    func filename_hasCorrectFormat_forIT() {
        let inputName = "AUDIO-2025-05-20-14-27"
        let expectedFileName = "Mar 20 Mag 2025, 14:27"
        #expect(expectedFileName == inputName.formatAudioFileName(locale: Locale(identifier: "it")))
    }

    // MARK: - Ordinals

    @Test("Filename does not have custom ordinal for EN when it is not needed")
    func filename_doesNotHaveOrdinal_forEN() {
        let inputName = "AUDIO-2025-05-04-14-27"
        let expectedFileName = "Sun, May 4th, 2025 at 2:27 PM"
        #expect(expectedFileName == inputName.formatAudioFileName(locale: Locale(identifier: "en")))
    }

    @Test("Filename adds th ordinal for EN when it is 11, 12, or 13 day")
    func filename_doesAdds_th_OrdinalWhenNeeded_forEN() {
        let inputName11 = "AUDIO-2025-05-11-14-27"
        let expectedFileName11 = "Sun, May 11th, 2025 at 2:27 PM"
        #expect(expectedFileName11 == inputName11.formatAudioFileName(locale: Locale(identifier: "en")))

        let inputName12 = "AUDIO-2025-05-12-14-27"
        let expectedFileName12 = "Mon, May 12th, 2025 at 2:27 PM"
        #expect(expectedFileName12 == inputName12.formatAudioFileName(locale: Locale(identifier: "en")))

        let inputName13 = "AUDIO-2025-05-13-14-27"
        let expectedFileName13 = "Tue, May 13th, 2025 at 2:27 PM"
        #expect(expectedFileName13 == inputName13.formatAudioFileName(locale: Locale(identifier: "en")))
    }

    @Test("Filename adds st ordinal for EN when it is needed")
    func filename_doesAdds_st_OrdinalWhenNeeded_forEN() {
        let inputName = "AUDIO-2025-05-01-14-27"
        let expectedFileName = "Thu, May 1st, 2025 at 2:27 PM"
        #expect(expectedFileName == inputName.formatAudioFileName(locale: Locale(identifier: "en")))
    }

    @Test("Filename adds nd ordinal for EN when it is needed")
    func filename_doesAdds_nd_OrdinalWhenNeeded_forEN() {
        let inputName = "AUDIO-2025-05-02-14-27"
        let expectedFileName = "Fri, May 2nd, 2025 at 2:27 PM"
        #expect(expectedFileName == inputName.formatAudioFileName(locale: Locale(identifier: "en")))
    }

    @Test("Filename adds rd ordinal for EN when it is needed")
    func filename_doesAdds_rd_OrdinalWhenNeeded_forEN() {
        let inputName = "AUDIO-2025-05-03-14-27"
        let expectedFileName = "Sat, May 3rd, 2025 at 2:27 PM"
        #expect(expectedFileName == inputName.formatAudioFileName(locale: Locale(identifier: "en")))
    }

}
