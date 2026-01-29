import Foundation

public final class My {
    public static func LocalizedString(_ key: String.LocalizationValue, tableName: String? = "Localizable", bundle: Bundle = Bundle(for: My.self)) -> String {
        String(localized: key, table: tableName, bundle: bundle)
    }
}
