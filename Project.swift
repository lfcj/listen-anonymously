import ProjectDescription

let project = Project(
    name: "Listen anonymously",
    options: .options(
        automaticSchemesOptions: .disabled,
        textSettings: .textSettings(usesTabs: false, indentWidth: 4, tabWidth: 4)
    ),
    settings: .settings(
        configurations: [
            .debug(name: "Debug", xcconfig: "Debug.xcconfig"),
            .release(name: "Release", xcconfig: "Release.xcconfig")
        ]
    ),
    targets: [
        // MARK: - Main App Target
        .target(
            name: "Listen anonymously",
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
                .target(name: "Listen Anonymously Shared"),
                .external(name: "RevenueCat"),
                .external(name: "PostHog")
            ],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": "$(DEV_TEAM_SECRET)",
                    "CODE_SIGN_STYLE": "Manual",
                    "CODE_SIGN_IDENTITY": "Apple Development",
                    "PROVISIONING_PROFILE_SPECIFIER": "iOS Team Provisioning Profile: *"
                ],
                configurations: [
                    .debug(name: "Debug"),
                    .release(name: "Release")
                ]
            )
        ),
        
        // MARK: - App Extension Target
        .target(
            name: "Listen anonymously Ext",
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
                .target(name: "Listen Anonymously Shared"),
                .external(name: "PostHog")
            ],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": "$(DEV_TEAM_SECRET)",
                    "CODE_SIGN_STYLE": "Manual",
                    "CODE_SIGN_IDENTITY": "Apple Development",
                    "PROVISIONING_PROFILE_SPECIFIER": "iOS Team Provisioning Profile: *"
                ],
                configurations: [
                    .debug(name: "Debug"),
                    .release(name: "Release")
                ]
            )
        ),
        
        // MARK: - Shared Framework Target
        .target(
            name: "Listen Anonymously Shared",
            destinations: [.iPhone, .iPad],
            product: .framework,
            bundleId: "com.reginafallangi.listen-anonymously.Listen-Anonymously-Shared",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Listen Anonymously Shared/Sources/**"],
            resources: ["Listen Anonymously Shared/Resources/**"],
            dependencies: [
                .external(name: "PostHog")
            ],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": "$(DEV_TEAM_SECRET)",
                    "CODE_SIGN_STYLE": "Manual",
                    "CODE_SIGN_IDENTITY": "Apple Development",
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
            name: "Listen anonymously Tests",
            destinations: [.iPhone, .iPad],
            product: .unitTests,
            bundleId: "com.reginafallangi.Listen-anonymouslyTests",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Listen anonymously Tests/**"],
            dependencies: [
                .target(name: "Listen anonymously"),
                .target(name: "Listen Anonymously Shared"),
                .external(name: "ViewInspector")
            ],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": "$(DEV_TEAM_SECRET)"
                ]
            )
        ),
        
        .target(
            name: "Listen Anonymously Shared Tests",
            destinations: [.iPhone, .iPad],
            product: .unitTests,
            bundleId: "com.reginafallangi.listen-anonymously.Listen-Anonymously-SharedTests",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Listen Anonymously Shared Tests/**"],
            dependencies: [
                .target(name: "Listen Anonymously Shared"),
                .external(name: "ViewInspector")
            ],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": "$(DEV_TEAM_SECRET)"
                ]
            )
        ),
        
        .target(
            name: "Listen anonymously Ext Tests",
            destinations: [.iPhone, .iPad],
            product: .unitTests,
            bundleId: "com.reginafallangi.listen-anonymously.Listen-anonymously-Ext-Tests",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Listen anonymously Ext Tests/**"],
            dependencies: [
                .target(name: "Listen anonymously Ext"),
                .target(name: "Listen Anonymously Shared"),
                .external(name: "ViewInspector")
            ],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": "$(DEV_TEAM_SECRET)"
                ]
            )
        )
    ],
    schemes: [
        Scheme(
            name: "Listen anonymously",
            shared: true,
            buildAction: .buildAction(targets: ["Listen anonymously"]),
            testAction: .targets(
                [
                    "Listen anonymously Tests",
                    "Listen Anonymously Shared Tests",
                    "Listen anonymously Ext Tests"
                ],
                configuration: "Debug",
                options: .options(
                    coverage: true,
                    codeCoverageTargets: [
                        "Listen anonymously",
                        "Listen Anonymously Shared",
                        "Listen anonymously Ext"
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
