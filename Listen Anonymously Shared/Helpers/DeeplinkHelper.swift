import UIKit

public struct DeeplinkHelper {

    public static var hasWhatsApp: Bool {
        hasApp(for: SupportedApps.whatsApp.deeplinkString)
    }

    public static var hasTelegram: Bool {
        hasApp(for: "https://t.me/username")
    }

    /// Returns `true` if user has app that can handle `urlString` as a URL
    static func hasApp(for urlString: String) -> Bool {
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            return true
        }
        return false
    }

}

public enum SupportedApps: String, CaseIterable, Identifiable {
    case whatsApp = "WhatsApp"
    case telegram = "Telegram"
    public var id: Self { self }

    var deeplinkString: String {
        switch self {
        case .whatsApp:
            return "https://wa.me/+1234567890"
        case .telegram:
            return "https://t.me/username"
        }
    }
}
