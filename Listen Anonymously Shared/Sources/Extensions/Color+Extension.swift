import SwiftUI

// MARK: - Color helpers

public extension Color {

    /// Convenience init for hex like 0xRRGGBB
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }

    // MARK: - Asset catalog colors (Media.xcassets/Colors)

    static let laTeal = Color("la_teal", bundle: .module)
    static let laPurple = Color("la_purple", bundle: .module)
    static let laMagenta = Color("la_magenta", bundle: .module)
    static let laPurpleText = Color("la_purpleText", bundle: .module)
    static let lavender = Color("lavender", bundle: .module)
    static let pastelBlue = Color("pastel-blue", bundle: .module)
    static let violetLavender = Color("violet-lavender", bundle: .module)
    static let buttonStart = Color("buttonStart", bundle: .module)
    static let buttonEnd = Color("buttonEnd", bundle: .module)
    static let buttonShadow = Color("buttonShadow", bundle: .module)
    static let iconButtonBackgroundStart = Color("iconButtonBackgroundStart", bundle: .module)
    static let iconButtonBackgroundEnd = Color("iconButtonBackgroundEnd", bundle: .module)
    static let iconButtonForegroundStart = Color("iconButtonForegroundStart", bundle: .module)
    static let iconButtonForegroundEnd = Color("iconButtonForegroundEnd", bundle: .module)

}
