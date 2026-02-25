// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        productTypes: [
            "RevenueCat": .framework,
            "PostHog": .framework,
            "ViewInspector": .framework
        ]
    )
#endif

let package = Package(
    name: "ListenAnonymously",
    dependencies: [
        .package(url: "https://github.com/RevenueCat/purchases-ios.git", from: "4.0.0"),
        .package(url: "https://github.com/PostHog/posthog-ios.git", from: "3.0.0"),
        .package(url: "https://github.com/nalexn/ViewInspector.git", from: "0.9.0")
    ]
)
