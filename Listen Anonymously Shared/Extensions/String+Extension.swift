import Foundation

extension String {

    func formatAudioFileName(locale: Locale =
        .current) -> String {
        let dateString = self
        guard dateString.count >= 22 else {
            return dateString
        }
        guard dateString.hasPrefix("AUDIO-") else {
            return dateString
        }
        // Parse the input string
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd-HH-mm"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        // swiftlint:disable todo
        // TODO: Use REGEX so other strings that contain dates work
        // swiftlint:enable todo
        guard let date = inputFormatter.date(from: dateString.prefix(22).replacingOccurrences(of: "AUDIO-", with: "")) else {
            return dateString
        }

        // Format the output
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        outputFormatter.timeStyle = .short
        outputFormatter.locale = locale
        // yyyyLLLdjmma -> May 20th, 2025 at 2:27 PM
        // MMMMdEEEEyyyy -> Tuesday, May 20th, 2025
        // EEEMMMdyyyyjmma -> Tue, May 20th, 2025 at 2:27 PM
        outputFormatter.setLocalizedDateFormatFromTemplate("EEEMMMdyyyyjmma")

        let formattedDate = outputFormatter.string(from: date)

        // Add ordinal suffix for day (English only)
        if locale.language.languageCode?.identifier.contains("en") == true {
            let calendar = Calendar.current
            let day = calendar.component(.day, from: date)
            let ordinalSuffix = ordinalSuffix(for: day)

            // Replace the day number with day + ordinal
            let dayString = "\(day)"
            if let range = formattedDate.range(of: dayString) {
                let withOrdinal = formattedDate.replacingCharacters(in: range, with: "\(day)\(ordinalSuffix)")
                return withOrdinal
            }
        }

        return formattedDate.localizedCapitalized
    }

    private func ordinalSuffix(for day: Int) -> String {
        switch day {
        case 11, 12, 13:
            return "th"
        default:
            switch day % 10 {
            case 1: return "st"
            case 2: return "nd"
            case 3: return "rd"
            default: return "th"
            }
        }
    }

}
