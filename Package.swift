// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ListenAnonymously",
    dependencies: [
        .package(url: "https://github.com/RevenueCat/purchases-ios.git", from: "5.59.2"),
        .package(url: "https://github.com/PostHog/posthog-ios.git", from: "3.41.1"),
        .package(url: "https://github.com/nalexn/ViewInspector.git", from: "0.10.3")
    ]
)
