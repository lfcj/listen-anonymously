# Tuist Migration Guide

This guide explains how to migrate from the `.pbxproj` file to Tuist and how to build the project.

## Prerequisites

### Install Tuist

```bash
curl -Ls https://install.tuist.io | bash
```

Or using Homebrew:

```bash
brew install tuist
```

## Project Structure

The project has been configured with the following structure:

```
listen-anonymously/
├── Project.swift                          # Main Tuist project manifest
├── Package.swift                          # SPM dependencies definition
├── Config.swift                           # Tuist configuration
├── Debug.xcconfig                         # Debug build configuration
├── Release.xcconfig                       # Release build configuration  
├── Secrets.xcconfig                       # Local secrets (git-ignored)
├── Listen anonymously/                    # Main app target
│   ├── Sources/
│   └── Resources/
├── Listen anonymously Ext/                # App Extension target
│   ├── Sources/
│   └── Resources/
├── Listen Anonymously Shared/             # Shared framework
│   ├── Sources/
│   └── Resources/
├── Listen anonymously Tests/              # Main app tests
├── Listen Anonymously Shared Tests/       # Shared framework tests
└── Listen anonymously Ext Tests/          # Extension tests
```

## Targets

The project includes the following targets:

1. **Listen anonymously** - Main iOS app
2. **Listen anonymously Ext** - Action Extension for sharing audio files
3. **Listen Anonymously Shared** - Shared framework with reusable logic
4. **Listen anonymously Tests** - Unit tests for main app
5. **Listen Anonymously Shared Tests** - Unit tests for shared framework
6. **Listen anonymously Ext Tests** - Unit tests for extension

## External Dependencies

The project uses the following SPM packages:

- **RevenueCat** (4.0.0+) - In-app purchases and subscriptions
- **PostHog** (3.0.0+) - Product analytics
- **ViewInspector** (0.9.0+) - SwiftUI testing utilities

## Configuration Management

### Secret Management

The `DEVELOPMENT_TEAM` is kept secure using the `Secrets.xcconfig` file:

1. **Local Development**: Create a `Secrets.xcconfig` file in the root directory:

```xcconfig
// Secrets.xcconfig
DEV_TEAM_SECRET = YOUR_TEAM_ID_HERE
POSTHOG_API_KEY = your_posthog_key
REVENUE_CAT_KEY = your_revenue_cat_key
```

2. **CI/CD**: The GitHub Actions workflow should create this file from secrets:

```yaml
- name: Create Secrets.xcconfig
  run: |
    echo "DEV_TEAM_SECRET = ${{ secrets.DEVELOPMENT_TEAM }}" > Secrets.xcconfig
    echo "POSTHOG_API_KEY = ${{ secrets.POSTHOG_API_KEY }}" >> Secrets.xcconfig
    echo "REVENUE_CAT_KEY = ${{ secrets.REVENUE_CAT_KEY }}" >> Secrets.xcconfig
```

### Build Settings via xcconfig

- `Debug.xcconfig` and `Release.xcconfig` define build settings including:
  - Code signing configuration (Manual)
  - Deployment target (iOS 18)
  - Provisioning profile specifiers

## Building the Project

### First-time Setup

1. **Create Secrets.xcconfig** (if not already present):
```bash
cp Secrets.xcconfig.example Secrets.xcconfig
# Edit Secrets.xcconfig with your team ID and API keys
```

2. **Install Tuist** (if not already installed):
```bash
curl -Ls https://install.tuist.io | bash
```

3. **Fetch dependencies**:
```bash
tuist install
```

4. **Generate Xcode project**:
```bash
tuist generate
```

This will create `Listen anonymously.xcodeproj` and `Listen anonymously.xcworkspace`.

5. **Open the workspace**:
```bash
open "Listen anonymously.xcworkspace"
```

### Daily Workflow

After the initial setup, your workflow is simple:

1. **Make changes** to `Project.swift` or source files
2. **Regenerate project** if you modified `Project.swift`:
```bash
tuist generate
```
3. **Build and run** in Xcode as usual

### Clean Generation

If you need a fresh start:

```bash
tuist clean
tuist install
tuist generate
```

## Running Tests

### Via Xcode
Open the workspace and use Cmd+U to run tests with code coverage enabled.

### Via Command Line

```bash
# Generate project first
tuist generate

# Run tests with xcodebuild
xcodebuild test \
  -workspace "Listen anonymously.xcworkspace" \
  -scheme "Listen anonymously" \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
  -enableCodeCoverage YES
```

### Via Fastlane

Your existing Fastlane lanes should continue to work:

```bash
bundle exec fastlane ios all_tests
```

You may need to update your Fastfile to use the workspace instead of the project:

```ruby
# Before
xcodeproj: "Listen anonymously.xcodeproj"

# After  
workspace: "Listen anonymously.xcworkspace"
```

## Benefits of Tuist

1. **No more pbxproj conflicts** - The Project.swift file is readable and mergeable
2. **Consistent configuration** - All targets follow the same patterns
3. **Type-safe project definition** - Catch configuration errors at generation time
4. **Better secret management** - Secrets remain in xcconfig files referenced by variables
5. **Scalable architecture** - Easy to add new targets or modify existing ones
6. **Version control friendly** - Project.swift is human-readable

## Migrating from .pbxproj

### What to Delete

After confirming everything works, you can remove:

```bash
# Backup first!
git mv Listen\ anonymously.xcodeproj Listen\ anonymously.xcodeproj.backup

# Or delete entirely
rm -rf "Listen anonymously.xcodeproj"
```

### What to Keep

- All source files
- All resource files  
- xcconfig files (Debug.xcconfig, Release.xcconfig, Secrets.xcconfig)
- Existing folder structure
- Fastlane configuration
- GitHub Actions workflows (with minor updates)

### What Changes

- `.xcodeproj` directory is now generated by Tuist
- Add `.xcodeproj` and `.xcworkspace` to `.gitignore`
- Keep `Project.swift`, `Package.swift`, and `Config.swift` in version control

## Updating .gitignore

Add these lines to your `.gitignore`:

```gitignore
# Tuist
.tuist
Tuist/Dependencies
*.xcodeproj
*.xcworkspace
Derived/

# Keep Secrets.xcconfig ignored
Secrets.xcconfig
```

## CI/CD Updates

Update your GitHub Actions workflow:

```yaml
- name: Install Tuist
  run: curl -Ls https://install.tuist.io | bash

- name: Create Secrets.xcconfig
  run: |
    echo "DEV_TEAM_SECRET = ${{ secrets.DEVELOPMENT_TEAM }}" > Secrets.xcconfig
    echo "POSTHOG_API_KEY = ${{ secrets.POSTHOG_API_KEY }}" >> Secrets.xcconfig
    echo "REVENUE_CAT_KEY = ${{ secrets.REVENUE_CAT_KEY }}" >> Secrets.xcconfig

- name: Generate Xcode Project
  run: tuist generate

- name: Run Tests
  run: |
    xcodebuild test \
      -workspace "Listen anonymously.xcworkspace" \
      -scheme "Listen anonymously" \
      -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
      -enableCodeCoverage YES
```

## Troubleshooting

### "No such module" errors

Run `tuist install` to fetch SPM dependencies.

### Build settings not applied

Verify that `Secrets.xcconfig` exists and contains your `DEV_TEAM_SECRET`.

### Extension not embedded

Check that the extension target is added as a dependency to the main app in `Project.swift`.

### Info.plist issues

Tuist uses `infoPlist: .extendingDefault()` to merge custom keys with defaults. Verify custom keys are correctly specified in the target definition.

### Code signing issues

Ensure:
1. `Secrets.xcconfig` contains your team ID
2. Provisioning profiles are installed
3. Manual signing is configured correctly in xcconfig files

## Support

For Tuist-specific issues, consult:
- [Tuist Documentation](https://docs.tuist.io)
- [Tuist GitHub](https://github.com/tuist/tuist)
- [Tuist Community](https://community.tuist.io)

## Next Steps

Once the migration is complete and verified:

1. Update your README.md with Tuist setup instructions
2. Update your CI/CD pipelines
3. Update your team's onboarding documentation
4. Consider using Tuist Cloud for caching and collaboration features
