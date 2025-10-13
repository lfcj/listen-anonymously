import Foundation

extension String {

    // TODO: Improve to find this regex in any string + add tests
    func formatAudioFileName() -> String {
        let fileName = self
        guard fileName.count >= 22 else {
            return fileName
        }
        guard fileName.hasPrefix("AUDIO-") else {
            return fileName
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm"

        if let date = dateFormatter.date(from: String(fileName.prefix(22).replacingOccurrences(of: "AUDIO-", with: ""))) {
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "d"
            let day = dayFormatter.string(from: date)

            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MMM"
            let month = monthFormatter.string(from: date)

            let hourFormatter = DateFormatter()
            hourFormatter.dateFormat = "HH:mm"
            let time = hourFormatter.string(from: date)

            // Add "st," "nd," "rd," or "th" to the day
            var dayWithSuffix = day
            let dayInt = Int(day) ?? 0
            switch dayInt {
            case 1, 21, 31:
                dayWithSuffix += "st" // TODO: test in spanish
            case 2, 22:
                dayWithSuffix += "nd"
            case 3, 23:
                dayWithSuffix += "rd"
            default:
                dayWithSuffix += "th"
            }

            return "\(month) \(dayWithSuffix) \(time)"
        }

        return fileName
    }
}
