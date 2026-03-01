import Foundation
@testable import Listen_Anonymously_Shared
import Testing

@MainActor
struct LocalizationTests {

    static let requiredKeys: [String.LocalizationValue] = [
        "NOT_FOUND_ATTACHMENT_ERROR",
        "FOUND_TYPEIDENTIFIER",
        "NO_BLUE_TICKS",
        "TOTAL_FREEDOM",
        "SEE_HOW_IT_WORKS",
        "STAY_UNSEEN",
        "STILL_IN_THE_LOOP",
        "LISTEN_WITHOUT_KNOWING",
        "HOW_TO_USE_TITLE",
        "SUPPORTED_APP",
        "TELEGRAM_STEP_1",
        "TELEGRAM_STEP_2",
        "TELEGRAM_STEP_3",
        "WHATSAPP_STEP_1",
        "WHATSAPP_STEP_2",
        "WHATSAPP_STEP_3",
        "SCROLL_DOWN_AND_TAP",
        "TAB_HOME",
        "TAB_HOW_TO_USE",
        "LISTEN_ANONYMOUSLY",
        "VIBE_CHECK",
        "LOVE_BEING_INVISIBLE",
        "BUY_US_A_COFFEE",
        "SEND_GOOD_VIBES",
        "GHOST_MODE_HERO",
        "NO_ONE_WILL_KNOW",
        "LOADING",
        "ERROR_READING_AUDIO",
        "TRY_AGAIN",
        "DONE",
        "COULD_NOT_READ_SHARED_ITEM",
        "UNKNOWN_ERROR",
        "TELEGRAM_CONVERSION_ERROR",
        "NO_AUDIO_FILE_FOUND"
    ]

    @Test("All localization keys return non-empty strings")
    func allKeysReturnNonEmptyStrings() {
        for key in Self.requiredKeys {
            let value = My.localizedString(key)
            #expect(!value.isEmpty, "Key '\(key)' should have a non-empty English translation")
        }
    }

    @Test("Localized strings are not equal to their key names")
    func localizedStringsAreNotRawKeys() {
        for key in Self.requiredKeys {
            let value = My.localizedString(key)
            let keyString = String(describing: key)
            #expect(value != keyString, "Key '\(keyString)' should return a translated value, not the key itself")
        }
    }

    @Test("NOT_FOUND_ATTACHMENT_ERROR has a meaningful English translation")
    func notFoundAttachmentErrorHasTranslation() {
        let value = My.localizedString("NOT_FOUND_ATTACHMENT_ERROR")
        #expect(value == "Could not find anything to listen to")
    }

    @Test("STAY_UNSEEN has a meaningful English translation")
    func stayUnseenHasTranslation() {
        let value = My.localizedString("STAY_UNSEEN")
        #expect(value == "Stay unseen.")
    }

    @Test("NO_ONE_WILL_KNOW includes emoji")
    func noOneWillKnowIncludesEmoji() {
        let value = My.localizedString("NO_ONE_WILL_KNOW")
        #expect(value.contains("😉"))
    }

}
