import SwiftUI

public struct SnapshotView<Content: View>: View {
    let content: Content
    let configuration: SnapshotConfiguration

    public init(content: Content, configuration: SnapshotConfiguration) {
        self.content = content
        self.configuration = configuration
    }

    public var body: some View {
        content
            .environment(\.horizontalSizeClass, .compact)
            .environment(\.verticalSizeClass, .regular)
            .environment(\.layoutDirection, .leftToRight)
            .environment(\.sizeCategory, contentSizeCategory)
            .environment(\.colorScheme, colorScheme)
            .environment(\.displayScale, 2)
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: configuration.safeAreaInsets.top)
            }
    }

    public var contentSizeCategory: ContentSizeCategory {
        ContentSizeCategory(configuration.traitCollection.preferredContentSizeCategory) ?? .accessibilityExtraExtraExtraLarge
    }

    public var colorScheme: ColorScheme {
        switch configuration.traitCollection.userInterfaceStyle {
        case .light:
            return .light
        case .dark:
            return .dark
        case .unspecified:
            return .light
        @unknown default:
            fatalError("Unknown case \(configuration.traitCollection.userInterfaceStyle) ")
        }
    }

}

public extension ContentSizeCategory {
    // swiftlint:disable cyclomatic_complexity
    init(uiKitContentSizeCategory: UIContentSizeCategory) {
        switch uiKitContentSizeCategory {
        case .accessibilityExtraExtraExtraLarge:
            self = .accessibilityExtraExtraExtraLarge
        case .accessibilityExtraExtraLarge:
            self = .accessibilityExtraExtraLarge
        case .accessibilityExtraLarge:
            self = .accessibilityExtraLarge
        case .accessibilityLarge:
            self = .accessibilityLarge
        case .accessibilityMedium:
            self = .accessibilityMedium
        case .extraExtraExtraLarge:
            self = .extraExtraExtraLarge
        case .extraExtraLarge:
            self = .extraExtraLarge
        case .extraLarge:
            self = .extraLarge
        case .extraSmall:
            self = .extraSmall
        case .large:
            self = .large
        case .medium:
            self = .medium
        case .small:
            self = .small
        case .unspecified:
            self = .medium
        default:
            fatalError("Unknown case \(uiKitContentSizeCategory) ")
        }
    }
    // swiftlint:enable cyclomatic_complexity
}

public extension ColorScheme {
    init(style: UIUserInterfaceStyle) {
        switch style {
        case .light:
            self = .light
        case .dark:
            self = .dark
        case .unspecified:
            self = .light
        @unknown default:
            fatalError("Unknown case \(style) ")
        }
    }
}
