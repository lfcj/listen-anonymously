import Foundation

// swiftlint:disable type_name
public final class My {
// swiftlint:enable type_name

    /// Set this to a language code (e.g. "de", "ja") to override the locale used by `localizedString`. Useful for snapshot tests
    /// When `nil`, the default bundle localization is used.
    @MainActor public static var currentLocalization: String?

    @MainActor
    public static func localizedString(_ key: String.LocalizationValue, tableName: String? = "Localizable", bundle: Bundle = Bundle(for: My.self)) -> String {
        let resolvedBundle: Bundle
        if let language = currentLocalization,
           let path = bundle.path(forResource: language, ofType: "lproj"),
           let locBundle = Bundle(path: path) {
            resolvedBundle = locBundle
        } else {
            resolvedBundle = bundle
        }
        return String(localized: key, table: tableName, bundle: resolvedBundle)
    }
}
