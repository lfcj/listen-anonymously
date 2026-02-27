import ProjectDescription

let project = Project(
    name: "Listen-anonymously",
    options: .options(
        automaticSchemesOptions: .disabled,
        textSettings: .textSettings(usesTabs: false, indentWidth: 4, tabWidth: 4)
    ),
    packages: [
        // TODO: Update to latest versions once tuist generate works
        // .remote(url: "https://github.com/RevenueCat/purchases-ios.git", requirement: .upToNextMajor(from: "5.59.2")),
        // .remote(url: "https://github.com/PostHog/posthog-ios.git", requirement: .upToNextMajor(from: "3.41.1")),
        // .remote(url: "https://github.com/nalexn/ViewInspector.git", requirement: .upToNextMajor(from: "0.10.3"))
        .remote(url: "https://github.com/RevenueCat/purchases-ios.git", requirement: .exact("5.59.2")),
        .remote(url: "https://github.com/PostHog/posthog-ios.git", requirement: .exact("3.41.2")),
        .remote(url: "https://github.com/nalexn/ViewInspector.git", requirement: .exact("0.10.3")),
        .remote(url: "https://github.com/element-hq/swift-ogg.git", requirement: .exact("0.0.3"))
    ],
    settings: .settings(
        configurations: [
            .debug(name: "Debug", xcconfig: "Configuration/Debug.xcconfig"),
            .release(name: "Release", xcconfig: "Configuration/Release.xcconfig")
        ]
    ),
    targets: [
        // MARK: - Main App Target
        .target(
            name: "Listen-anonymously",
            destinations: [.iPhone, .iPad],
            product: .app,
            bundleId: "com.reginafallangi.Listen-anonymously",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": [
                    "UIColorName": "",
                    "UIImageName": ""
                ],
                "CFBundleDisplayName": "Listen anonymously",
                "PostHogAPIKey": "$(POSTHOG_API_KEY)",
                "RevenueCatAPIKey": "$(REVENUE_CAT_KEY)",
                "NSExtension": [
                    "NSExtensionAttributes": [
                        "NSExtensionActivationRule": [
                            "NSExtensionActivationSupportsFileWithMaxCount": 1,
                            "NSExtensionActivationSupportsText": false
                        ]
                    ]
                ]
            ]),
            sources: ["Listen anonymously/Sources/**"],
            resources: ["Listen anonymously/Resources/**"],
            dependencies: [
                .target(name: "Listen-Anonymously-Shared"),
                .package(product: "RevenueCat")
            ],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": "$(DEV_TEAM_SECRET)",
                    "CODE_SIGN_STYLE": "Automatic"
                ],
                configurations: [
                    .debug(name: "Debug"),
                    .release(name: "Release")
                ]
            )
        ),

        // MARK: - App Extension Target
        .target(
            name: "Listen-anonymously-Ext",
            destinations: [.iPhone, .iPad],
            product: .appExtension,
            bundleId: "com.reginafallangi.Listen-anonymously.Listen-anonymously-Ext",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .extendingDefault(with: [
                "NSExtension": [
                    "NSExtensionMainStoryboard": "MainInterface",
                    "NSExtensionPointIdentifier": "com.apple.ui-services",
                    "NSExtensionAttributes": [
                        "NSExtensionActivationRule": [
                            "NSExtensionActivationSupportsFileWithMaxCount": 1,
                            "NSExtensionActivationSupportsText": false
                        ]
                    ]
                ],
                "PostHogAPIKey": "$(POSTHOG_API_KEY)",
                "RevenueCatAPIKey": "$(REVENUE_CAT_KEY)"
            ]),
            sources: ["Listen anonymously Ext/Sources/**"],
            resources: ["Listen anonymously Ext/Resources/**"],
            dependencies: [
                .target(name: "Listen-Anonymously-Shared")
            ],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": "$(DEV_TEAM_SECRET)",
                    "CODE_SIGN_STYLE": "Automatic"
                ],
                configurations: [
                    .debug(name: "Debug"),
                    .release(name: "Release")
                ]
            )
        ),

        // MARK: - Shared Framework Target
        .target(
            name: "Listen-Anonymously-Shared",
            destinations: [.iPhone, .iPad],
            product: .framework,
            bundleId: "com.reginafallangi.listen-anonymously.Listen-Anonymously-Shared",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Listen Anonymously Shared/Sources/**"],
            resources: ["Listen Anonymously Shared/Resources/**"],
            dependencies: [
                .package(product: "PostHog"),
                .package(product: "SwiftOGG")
            ],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": "$(DEV_TEAM_SECRET)",
                    "CODE_SIGN_STYLE": "Automatic",
                    "DEFINES_MODULE": "YES"
                ],
                configurations: [
                    .debug(name: "Debug"),
                    .release(name: "Release")
                ]
            )
        ),

        // MARK: - Test Targets
        .target(
            name: "Listen-anonymously-Tests",
            destinations: [.iPhone, .iPad],
            product: .unitTests,
            bundleId: "com.reginafallangi.Listen-anonymously-Tests",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Listen anonymouslyTests/**"],
            dependencies: [
                .target(name: "Listen-anonymously"),
                .target(name: "Listen-Anonymously-Shared"),
                .package(product: "ViewInspector")
            ],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": "$(DEV_TEAM_SECRET)"
                ]
            )
        ),

        .target(
            name: "Listen-Anonymously-Shared-Tests",
            destinations: [.iPhone, .iPad],
            product: .unitTests,
            bundleId: "com.reginafallangi.Listen-Anonymously-Shared-Tests",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Listen Anonymously SharedTests/**"],
            resources: ["Listen Anonymously Shared/Resources/TestResources/**"],
            dependencies: [
                .target(name: "Listen-Anonymously-Shared"),
                .package(product: "ViewInspector")
            ],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": "$(DEV_TEAM_SECRET)"
                ]
            )
        ),

        .target(
            name: "Listen-anonymously-Ext-Tests",
            destinations: [.iPhone, .iPad],
            product: .unitTests,
            bundleId: "com.reginafallangi.Listen-anonymously-Ext-Tests",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: [
                "Listen anonymously Ext Tests/**",
                "Listen anonymously Ext/Sources/**"
            ],
            resources: [
                .glob(pattern: "Listen anonymously Ext/Resources/**", excluding: ["Listen anonymously Ext/Resources/Info.plist"])
            ],
            dependencies: [
                .target(name: "Listen-Anonymously-Shared"),
                .target(name: "Listen-anonymously"),
                .package(product: "ViewInspector")
            ],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": "$(DEV_TEAM_SECRET)"
                ]
            )
        ),

        .target(
            name: "Listen-anonymously-UITests",
            destinations: [.iPhone, .iPad],
            product: .uiTests,
            bundleId: "com.reginafallangi.Listen-anonymously-UITests",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Listen anonymouslyUITests/**"],
            dependencies: [
                .target(name: "Listen-anonymously")
            ],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": "$(DEV_TEAM_SECRET)"
                ]
            )
        ),

        .target(
            name: "Listen-anonymously-Snapshot-Tests",
            destinations: [.iPhone, .iPad],
            product: .unitTests,
            bundleId: "com.reginafallangi.Listen-anonymously-Snapshot-Tests",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Listen anonymously Snapshot Tests/**"],
            resources: ["Listen anonymously Snapshot Tests/snapshots/**"],
            dependencies: [
                .target(name: "Listen-anonymously"),
                .target(name: "Listen-Anonymously-Shared")
            ],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": "$(DEV_TEAM_SECRET)"
                ]
            )
        )
    ],
    schemes: [
        .scheme(
            name: "Listen-anonymously",
            shared: true,
            buildAction: .buildAction(targets: ["Listen-anonymously"]),
            testAction: .targets(
                [
                    "Listen-anonymously-Tests",
                    "Listen-Anonymously-Shared-Tests",
                    "Listen-anonymously-Ext-Tests",
                    "Listen-anonymously-Snapshot-Tests",
                    "Listen-anonymously-UITests"
                ],
                configuration: "Debug",
                options: .options(
                    coverage: true,
                    codeCoverageTargets: [
                        "Listen-anonymously",
                        "Listen-Anonymously-Shared",
                        "Listen-anonymously-Ext"
                    ]
                )
            ),
            runAction: .runAction(configuration: "Debug"),
            archiveAction: .archiveAction(configuration: "Release"),
            profileAction: .profileAction(configuration: "Release"),
            analyzeAction: .analyzeAction(configuration: "Debug")
        )
    ]
)
