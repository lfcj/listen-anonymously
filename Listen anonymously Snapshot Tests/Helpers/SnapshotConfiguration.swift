import UIKit

/// Contains all the size and `traitCollection` settings that a device has.
public struct SnapshotConfiguration {
    let name: String
    let size: CGSize
    let safeAreaInsets: UIEdgeInsets
    let layoutMargins: UIEdgeInsets
    let traitCollection: UITraitCollection

    static func iPhone8(style: UIUserInterfaceStyle, contentSize: UIContentSizeCategory = .medium) -> SnapshotConfiguration {
        SnapshotConfiguration(
            name: "iPhone 8",
            size: CGSize(width: 375, height: 667),
            safeAreaInsets: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0),
            layoutMargins: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16),
            traitCollection: UITraitCollection(
                mutations: { traitCollection in
                    traitCollection.forceTouchCapability = .available
                    traitCollection.layoutDirection = .leftToRight
                    traitCollection.preferredContentSizeCategory = contentSize
                    traitCollection.userInterfaceIdiom = .phone
                    traitCollection.horizontalSizeClass = .compact
                    traitCollection.verticalSizeClass = .regular
                    traitCollection.displayScale = 2
                    traitCollection.displayGamut = .P3
                    traitCollection.userInterfaceStyle = style
                }
            )
        )
    }

    static func iPhone12(style: UIUserInterfaceStyle, contentSize: UIContentSizeCategory = .medium) -> SnapshotConfiguration {
        SnapshotConfiguration(
            name: "iPhone 12",
            size: CGSize(width: 390, height: 844),
            safeAreaInsets: UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
            layoutMargins: UIEdgeInsets(top: 47, left: 16, bottom: 34, right: 16),
            traitCollection: UITraitCollection(mutations: { traits in
                traits.forceTouchCapability = .unavailable
                traits.layoutDirection = .leftToRight
                traits.preferredContentSizeCategory = contentSize
                traits.userInterfaceIdiom = .phone
                traits.horizontalSizeClass = .compact
                traits.verticalSizeClass = .regular
                traits.displayScale = 3
                traits.displayGamut = .P3
                traits.userInterfaceStyle = style
            })
        )
    }

    static func iPhone14Pro(style: UIUserInterfaceStyle, contentSize: UIContentSizeCategory = .medium) -> SnapshotConfiguration {
        SnapshotConfiguration(
            name: "iPhone 14 Pro",
            size: CGSize(width: 393, height: 852),
            safeAreaInsets: UIEdgeInsets(top: 59, left: 0, bottom: 34, right: 0),
            layoutMargins: UIEdgeInsets(top: 59, left: 16, bottom: 34, right: 16),
            traitCollection: UITraitCollection(mutations: { traits in
                traits.forceTouchCapability = .unavailable
                traits.layoutDirection = .leftToRight
                traits.preferredContentSizeCategory = contentSize
                traits.userInterfaceIdiom = .phone
                traits.horizontalSizeClass = .compact
                traits.verticalSizeClass = .regular
                traits.displayScale = 3
                traits.displayGamut = .P3
                traits.userInterfaceStyle = style
            })
        )
    }

    static func iPhone16e(style: UIUserInterfaceStyle = .light, contentSize: UIContentSizeCategory = .medium) -> SnapshotConfiguration {
        SnapshotConfiguration(
            name: "iPhone 16 e",
            size: CGSize(width: 375, height: 812),
            safeAreaInsets: UIEdgeInsets(top: 44, left: 0, bottom: 34, right: 0),
            layoutMargins: UIEdgeInsets(top: 44, left: 16, bottom: 34, right: 16),
            traitCollection: UITraitCollection(mutations: { traits in
                traits.forceTouchCapability = .unavailable
                traits.layoutDirection = .leftToRight
                traits.preferredContentSizeCategory = contentSize
                traits.userInterfaceIdiom = .phone
                traits.horizontalSizeClass = .compact
                traits.verticalSizeClass = .regular
                traits.displayScale = 2
                traits.displayGamut = .SRGB
                traits.userInterfaceStyle = style
            })
        )
    }

    static func iPhone17Thin(style: UIUserInterfaceStyle, contentSize: UIContentSizeCategory = .medium) -> SnapshotConfiguration {
        SnapshotConfiguration(
            name: "iPhone 17 Thin",
            size: CGSize(width: 402, height: 874),
            safeAreaInsets: UIEdgeInsets(top: 59, left: 0, bottom: 34, right: 0),
            layoutMargins: UIEdgeInsets(top: 59, left: 16, bottom: 34, right: 16),
            traitCollection: UITraitCollection(mutations: { traits in
                traits.forceTouchCapability = .unavailable
                traits.layoutDirection = .leftToRight
                traits.preferredContentSizeCategory = contentSize
                traits.userInterfaceIdiom = .phone
                traits.horizontalSizeClass = .compact
                traits.verticalSizeClass = .regular
                traits.displayScale = 3
                traits.displayGamut = .P3
                traits.userInterfaceStyle = style
            })
        )
    }

    static func iPhone17Pro(style: UIUserInterfaceStyle, contentSize: UIContentSizeCategory = .medium) -> SnapshotConfiguration {
        SnapshotConfiguration(
            name: "iPhone 17 Pro",
            size: CGSize(width: 402, height: 874),
            safeAreaInsets: UIEdgeInsets(top: 59, left: 0, bottom: 34, right: 0),
            layoutMargins: UIEdgeInsets(top: 59, left: 16, bottom: 34, right: 16),
            traitCollection: UITraitCollection(mutations: { traits in
                traits.forceTouchCapability = .unavailable
                traits.layoutDirection = .leftToRight
                traits.preferredContentSizeCategory = contentSize
                traits.userInterfaceIdiom = .phone
                traits.horizontalSizeClass = .compact
                traits.verticalSizeClass = .regular
                traits.displayScale = 3
                traits.displayGamut = .P3
                traits.userInterfaceStyle = style
            })
        )
    }

    static func iPad10(style: UIUserInterfaceStyle, contentSize: UIContentSizeCategory = .medium) -> SnapshotConfiguration {
        SnapshotConfiguration(
            name: "iPad 10",
            size: CGSize(width: 820, height: 1180),
            safeAreaInsets: UIEdgeInsets(top: 24, left: 0, bottom: 20, right: 0),
            layoutMargins: UIEdgeInsets(top: 24, left: 20, bottom: 20, right: 20),
            traitCollection: UITraitCollection(mutations: { traits in
                traits.forceTouchCapability = .unavailable
                traits.layoutDirection = .leftToRight
                traits.preferredContentSizeCategory = contentSize
                traits.userInterfaceIdiom = .pad
                traits.horizontalSizeClass = .regular
                traits.verticalSizeClass = .regular
                traits.displayScale = 2
                traits.displayGamut = .SRGB
                traits.userInterfaceStyle = style
            })
        )
    }

    static func iPad10Landscape(style: UIUserInterfaceStyle, contentSize: UIContentSizeCategory = .medium) -> SnapshotConfiguration {
        SnapshotConfiguration(
            name: "iPad 10 Landscape",
            size: CGSize(width: 1180, height: 820),
            safeAreaInsets: UIEdgeInsets(top: 24, left: 20, bottom: 20, right: 20),
            layoutMargins: UIEdgeInsets(top: 24, left: 20, bottom: 20, right: 20),
            traitCollection: UITraitCollection(mutations: { traits in
                traits.forceTouchCapability = .unavailable
                traits.layoutDirection = .leftToRight
                traits.preferredContentSizeCategory = contentSize
                traits.userInterfaceIdiom = .pad
                traits.horizontalSizeClass = .regular
                traits.verticalSizeClass = .regular
                traits.displayScale = 2
                traits.displayGamut = .SRGB
                traits.userInterfaceStyle = style
            })
        )
    }

}
