# Project.swift Structure Guide

This document explains how the Tuist `Project.swift` maps to the traditional Xcode project structure.

## Architecture Overview

```
Project.swift
├── Project Settings (configurations)
│   └── xcconfig files (Debug.xcconfig, Release.xcconfig)
├── Targets
│   ├── Main App
│   ├── App Extension
│   ├── Shared Framework
│   └── Test Targets (3)
├── External Dependencies (Package.swift)
│   ├── RevenueCat
│   ├── PostHog
│   └── ViewInspector
└── Schemes
    └── Listen anonymously (with all test targets)
```

## Target Details

### 1. Main App Target: "Listen anonymously"

**Product Type:** `.app`  
**Bundle ID:** `com.lfcj.listen-anonymously`  
**Platform:** iOS 18+

**Purpose:** The main iOS application that users install and launch.

**Dependencies:**
- Listen Anonymously Shared (framework)
- RevenueCat (SPM)
- PostHog (SPM)

**Sources:** `Listen anonymously/Sources/**`  
**Resources:** `Listen anonymously/Resources/**`

**Custom Info.plist Keys:**
- `PostHogAPIKey` → `$(POSTHOG_API_KEY)` from Secrets.xcconfig
- `RevenueCatAPIKey` → `$(REVENUE_CAT_KEY)` from Secrets.xcconfig
- Launch screen configuration
- Extension activation rules

**Build Settings (from xcconfig):**
- `DEVELOPMENT_TEAM` = `$(DEV_TEAM_SECRET)`
- `CODE_SIGN_STYLE` = Manual
- `CODE_SIGN_IDENTITY` = Apple Development
- `PROVISIONING_PROFILE_SPECIFIER` = iOS Team Provisioning Profile: *

---

### 2. App Extension Target: "Listen anonymously Ext"

**Product Type:** `.appExtension`  
**Bundle ID:** `com.lfcj.listen-anonymously.extension`  
**Platform:** iOS 18+

**Purpose:** Action Extension that allows listening to audio files from the share sheet in apps like WhatsApp, Telegram, and iMessage.

**Dependencies:**
- Listen Anonymously Shared (framework)
- PostHog (SPM)

**Sources:** `Listen anonymously Ext/Sources/**`  
**Resources:** `Listen anonymously Ext/Resources/**`

**Custom Info.plist Keys:**
- `NSExtension` configuration
  - `NSExtensionMainStoryboard` = MainInterface
  - `NSExtensionPointIdentifier` = com.apple.ui-services
  - Activation rules for file sharing
- `PostHogAPIKey` → `$(POSTHOG_API_KEY)`
- `RevenueCatAPIKey` → `$(REVENUE_CAT_KEY)`

**Build Settings:**
Same code signing configuration as main app.

**Note:** The extension must be embedded in the main app. This is automatically handled by Tuist when the extension is listed as a dependency.

---

### 3. Shared Framework Target: "Listen Anonymously Shared"

**Product Type:** `.framework`  
**Bundle ID:** `com.lfcj.listen-anonymously.shared`  
**Platform:** iOS 18+

**Purpose:** Reusable framework containing shared logic, models, and UI components used by both the main app and extension.

**Dependencies:**
- PostHog (SPM)

**Sources:** `Listen Anonymously Shared/Sources/**`  
**Resources:** `Listen Anonymously Shared/Resources/**`

**Build Settings:**
- Same code signing as other targets
- `DEFINES_MODULE` = YES (to allow importing)

**Architecture Benefits:**
- Single Responsibility: UI and logic reusability
- DRY: No code duplication between app and extension
- Testability: Can be tested independently
- Modularity: Could be extracted to SPM package

---

### 4. Test Targets

#### a) Listen anonymously Tests
**Tests:** Main app functionality  
**Dependencies:** Main app, Shared framework, ViewInspector

#### b) Listen Anonymously Shared Tests
**Tests:** Shared framework functionality  
**Dependencies:** Shared framework, ViewInspector

#### c) Listen anonymously Ext Tests
**Tests:** Extension functionality  
**Dependencies:** Extension, Shared framework, ViewInspector

**Code Coverage:**
All test targets contribute to code coverage, which is enabled in the scheme configuration.

---

## Configuration Management

### xcconfig Files

The project uses xcconfig files for configuration instead of hardcoding values:

```
Debug.xcconfig / Release.xcconfig
├── #include? "Secrets.xcconfig"
├── CODE_SIGN_STYLE = Manual
├── DEVELOPMENT_TEAM = $(DEV_TEAM_SECRET)
├── CODE_SIGN_IDENTITY = Apple Development
├── PROVISIONING_PROFILE_SPECIFIER = iOS Team Provisioning Profile: *
└── DEPLOYMENT_TARGET = 18
```

**Secrets.xcconfig** (git-ignored):
```
DEV_TEAM_SECRET = G7YAMEJH7M
POSTHOG_API_KEY = phc_...
REVENUE_CAT_KEY = test_...
```

### How Variables Flow

```
Secrets.xcconfig
    ↓ (included by)
Debug.xcconfig / Release.xcconfig
    ↓ (referenced in)
Project.swift (configurations)
    ↓ (and target settings)
Target Build Settings
    ↓ (and Info.plist)
Runtime Configuration
```

**Example Flow:**
1. `DEV_TEAM_SECRET = G7YAMEJH7M` is defined in Secrets.xcconfig
2. `DEVELOPMENT_TEAM = $(DEV_TEAM_SECRET)` references it in xcconfig
3. Target settings use `DEVELOPMENT_TEAM: "$(DEV_TEAM_SECRET)"`
4. Xcode resolves to actual value during build

**Security:**
- Secrets.xcconfig is git-ignored
- Secrets.xcconfig.example is committed as template
- CI creates Secrets.xcconfig from GitHub Secrets
- Public xcconfig files only contain variable references

---

## External Dependencies

### Package.swift

Defines SPM dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/RevenueCat/purchases-ios.git", from: "4.0.0"),
    .package(url: "https://github.com/PostHog/posthog-ios.git", from: "3.0.0"),
    .package(url: "https://github.com/nalexn/ViewInspector.git", from: "0.9.0")
]
```

**Product Types:**
- All packages are configured as `.framework` in Tuist
- This ensures proper linking and embedding

**Dependency Graph:**
```
Listen anonymously (app)
├── Listen Anonymously Shared
│   └── PostHog
├── RevenueCat
└── PostHog

Listen anonymously Ext (extension)
├── Listen Anonymously Shared
│   └── PostHog
└── PostHog

Tests
├── ViewInspector
└── Respective targets
```

---

## Schemes

### Listen anonymously (Main Scheme)

**Build Targets:**
- Listen anonymously (app)

**Test Targets:**
- Listen anonymously Tests
- Listen Anonymously Shared Tests
- Listen anonymously Ext Tests

**Code Coverage:**
Enabled for:
- Listen anonymously
- Listen Anonymously Shared
- Listen anonymously Ext

**Configurations:**
- Build: Uses configuration from target
- Test: Debug
- Run: Debug
- Archive: Release
- Profile: Release
- Analyze: Debug

---

## Folder Structure Expectations

For the project to build correctly, ensure this structure:

```
listen-anonymously/
├── Project.swift                               # Tuist project manifest
├── Package.swift                               # SPM dependencies
├── Config.swift                                # Tuist configuration
├── Debug.xcconfig                              # Debug configuration
├── Release.xcconfig                            # Release configuration
├── Secrets.xcconfig                            # Local secrets (git-ignored)
├── Secrets.xcconfig.example                    # Template
│
├── Listen anonymously/                         # Main app
│   ├── Sources/                                # Swift source files
│   │   ├── App.swift (or similar app entry)
│   │   ├── Views/
│   │   ├── ViewModels/
│   │   └── ...
│   └── Resources/                              # Assets, storyboards, etc.
│       ├── Assets.xcassets
│       └── ...
│
├── Listen anonymously Ext/                     # Extension
│   ├── Sources/                                # Swift source files
│   │   ├── ActionViewController.swift
│   │   └── ...
│   └── Resources/                              # Assets, storyboards
│       ├── MainInterface.storyboard
│       └── ...
│
├── Listen Anonymously Shared/                  # Shared framework
│   ├── Sources/                                # Swift source files
│   │   ├── Models/
│   │   ├── Services/
│   │   ├── Views/
│   │   └── ...
│   └── Resources/                              # Shared resources
│       └── ...
│
├── Listen anonymously Tests/                   # Main app tests
│   └── *.swift
│
├── Listen Anonymously Shared Tests/            # Shared framework tests
│   └── *.swift
│
└── Listen anonymously Ext Tests/               # Extension tests
    └── *.swift
```

**Important:**
- Source paths in `Project.swift` must match your actual folder structure
- Use `/**` to include all files recursively
- Adjust paths if your structure is different

---

## Customizing Project.swift

### Adding a New Target

```swift
.target(
    name: "New Target Name",
    destinations: [.iPhone, .iPad],
    product: .framework, // or .app, .appExtension, .unitTests
    bundleId: "com.lfcj.new-target",
    deploymentTargets: .iOS("18.0"),
    infoPlist: .default, // or .extendingDefault(with: [...])
    sources: ["New Target/Sources/**"],
    resources: ["New Target/Resources/**"],
    dependencies: [
        // List dependencies here
    ],
    settings: .settings(
        base: [
            "DEVELOPMENT_TEAM": "$(DEV_TEAM_SECRET)",
            // Add custom settings here
        ]
    )
)
```

### Adding a New Dependency

1. Add to `Package.swift`:
```swift
.package(url: "https://github.com/owner/repo.git", from: "1.0.0")
```

2. Add to target in `Project.swift`:
```swift
dependencies: [
    .external(name: "PackageName")
]
```

3. Run:
```bash
tuist install
tuist generate
```

### Modifying Build Settings

**Option 1: In xcconfig files (recommended)**
```xcconfig
SWIFT_VERSION = 6.0
ENABLE_TESTABILITY = YES
```

**Option 2: In Project.swift**
```swift
settings: .settings(
    base: [
        "SWIFT_VERSION": "6.0",
        "ENABLE_TESTABILITY": "YES"
    ]
)
```

### Adding Custom Info.plist Keys

```swift
infoPlist: .extendingDefault(with: [
    "CustomKey": "CustomValue",
    "NestedKey": [
        "SubKey1": "Value1",
        "SubKey2": "Value2"
    ]
])
```

---

## Best Practices

### 1. Keep Secrets Secure
- Never commit Secrets.xcconfig
- Always reference via variables: `$(VAR_NAME)`
- Use Secrets.xcconfig.example as template

### 2. Maintain Configuration Hierarchy
```
Tuist defaults
    ↓ (overridden by)
xcconfig files
    ↓ (overridden by)
Target-specific settings in Project.swift
```

### 3. Version Control
**DO commit:**
- Project.swift
- Package.swift
- Config.swift
- *.xcconfig (except Secrets.xcconfig)
- Secrets.xcconfig.example

**DON'T commit:**
- *.xcodeproj
- *.xcworkspace
- .tuist/
- Derived/
- Secrets.xcconfig

### 4. Regenerate After Changes
Always run `tuist generate` after modifying:
- Project.swift
- Package.swift
- Config.swift

### 5. Keep It Simple
- Use xcconfig for build settings when possible
- Use Project.swift for target structure and dependencies
- Use Info.plist extensions for app-specific metadata

---

## Troubleshooting

### Build Setting Not Applied
1. Check xcconfig files are included correctly
2. Verify variable syntax: `$(VAR_NAME)`
3. Clean and regenerate: `tuist clean && tuist generate`

### Dependency Not Found
1. Run `tuist install` to fetch SPM packages
2. Check Package.swift has correct URL and version
3. Check Project.swift references correct package name

### Code Signing Issues
1. Verify Secrets.xcconfig exists and has `DEV_TEAM_SECRET`
2. Check provisioning profiles are installed
3. Verify bundle IDs match your profiles

### Path Not Found
1. Check folder structure matches paths in Project.swift
2. Use `Sources/` and `Resources/` subdirectories
3. Ensure `/**` wildcard is used for recursive search

---

## Migration from .pbxproj

### What Changed
- ❌ .pbxproj file (binary, hard to merge)
- ✅ Project.swift (readable, mergeable)

### What Stayed the Same
- Folder structure
- Source files
- xcconfig files
- Build settings
- Secret management
- External dependencies

### Benefits
- ✅ No more merge conflicts in .pbxproj
- ✅ Readable project configuration
- ✅ Type-safe definitions
- ✅ Consistent structure across team
- ✅ Easy to add/modify targets
- ✅ Better CI/CD integration

---

## Additional Resources

- [Tuist Documentation](https://docs.tuist.io)
- [Tuist Examples](https://github.com/tuist/tuist/tree/main/fixtures)
- [TUIST_SETUP.md](TUIST_SETUP.md) - Setup instructions
- [TUIST_MIGRATION_CHECKLIST.md](TUIST_MIGRATION_CHECKLIST.md) - Migration guide
