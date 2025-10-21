import UIKit

public protocol DeeplinkVerifying {
    nonisolated func canOpenURL(_ url: URL) -> Bool
}
extension UIApplication: DeeplinkVerifying {}

public struct DeeplinkHelper {

    /// Returns `true` if user has app that can handle `urlString` as a URL
    public static func hasApp(_ app: SupportedApps, application: DeeplinkVerifying = UIApplication.shared) -> Bool {
        if let url = URL(string: app.deeplinkString), application.canOpenURL(url) {
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
