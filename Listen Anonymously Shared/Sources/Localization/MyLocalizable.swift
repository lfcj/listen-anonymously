import Foundation

// swiftlint:disable type_name
public final class My {
// swiftlint:enable type_name
    public static func localizedString(_ key: String.LocalizationValue, tableName: String? = "Localizable", bundle: Bundle = Bundle(for: My.self)) -> String {
        String(localized: key, table: tableName, bundle: bundle)
    }
}
