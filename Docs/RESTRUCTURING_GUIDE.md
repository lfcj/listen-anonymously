# Project Restructuring Guide

## Current Problem

Your files are **not** organized in the `Sources/` and `Resources/` subdirectory structure that Tuist expects.

**Current Structure (Flat):**
```
Listen anonymously/
├── AppDelegate.swift
├── ContentView.swift
├── LATabView.swift
├── InstructionsView.swift
├── Assets.xcassets
├── Info.plist
└── (all files mixed together)
```

**Expected Structure (Organized):**
```
Listen anonymously/
├── Sources/              ← Swift files go here
│   ├── AppDelegate.swift
│   ├── ContentView.swift
│   ├── LATabView.swift
│   ├── InstructionsView.swift
│   └── ViewModels/
└── Resources/            ← Resources go here
    ├── Assets.xcassets
    ├── Info.plist
    └── Localizations/
```

---

## Target 1: Recommended Directory Structure

### Main App: "Listen anonymously"

```
Listen anonymously/
├── Sources/                              # All Swift code
│   ├── App/
│   │   ├── ListenAnonymouslyApp.swift   # App entry point
│   │   └── AppDelegate.swift            # If using UIKit
│   ├── Views/
│   │   ├── ContentView.swift
│   │   ├── LATabView.swift
│   │   ├── InstructionsView.swift
│   │   └── OnboardingView.swift
│   ├── ViewModels/
│   │   ├── ContentViewModel.swift
│   │   └── InstructionsViewModel.swift
│   └── Utilities/
│       └── (utility files)
└── Resources/                            # All resources
    ├── Assets.xcassets                   # Images, colors
    ├── Info.plist                        # App metadata
    ├── LaunchScreen.storyboard          # Launch screen
    └── Localizations/                    # Localized strings
        ├── en.lproj/
        └── es.lproj/
```

### Extension: "Listen anonymously Ext"

```
Listen anonymously Ext/
├── Sources/                              # All Swift code
│   ├── ActionViewController.swift        # Extension entry point
│   ├── Views/
│   │   └── AudioPlayingView.swift
│   └── ViewModels/
│       └── AudioPlayingViewModel.swift
└── Resources/                            # All resources
    ├── Assets.xcassets
    ├── Info.plist
    └── MainInterface.storyboard          # Extension UI
```

### Shared Framework: "Listen Anonymously Shared"

```
Listen Anonymously Shared/
├── Sources/                              # All Swift code
│   ├── Models/
│   │   ├── AppState.swift
│   │   └── AudioFile.swift
│   ├── Services/
│   │   ├── AudioPlayingManager.swift
│   │   ├── RevenueCatService.swift
│   │   └── AnalyticsService.swift
│   ├── Views/
│   │   ├── PlayingAnimationView.swift
│   │   ├── BorderedOrGlass.swift
│   │   └── SnapshotView.swift
│   ├── Extensions/
│   │   ├── Bundle+Extension.swift
│   │   └── FileManager+Extension.swift
│   └── Utilities/
│       └── SnapshotConfiguration.swift
└── Resources/                            # All resources
    ├── Assets.xcassets                   # Shared images
    └── Fonts/                            # Shared fonts
```

### Test Targets

```
Listen anonymously Tests/
├── AppTests.swift
├── ViewTests.swift
├── Utilities/
│   └── XCTestCase+Snapshots.swift
└── Snapshots/                            # Reference images

Listen Anonymously Shared Tests/
├── AudioPlayingManagerTests.swift
├── RevenueCatServiceTests.swift
└── Mocks/
    └── FakeNSExtensionItem.swift

Listen anonymously Ext Tests/
├── ActionViewControllerTests.swift
└── ExtensionTests.swift
```

---

## Step-by-Step Restructuring Process

### Phase 1: Backup Current Project

```fish
# Create a backup branch
git checkout -b backup-before-restructure
git add .
git commit -m "Backup before restructuring"
git checkout main

# Or create a copy
cp -R ~/path/to/listen-anonymously ~/path/to/listen-anonymously-backup
```

### Phase 2: Create Directory Structure

```fish
# Navigate to project root
cd ~/path/to/listen-anonymously

# Create directory structure for main app
mkdir -p "Listen anonymously/Sources/App"
mkdir -p "Listen anonymously/Sources/Views"
mkdir -p "Listen anonymously/Sources/ViewModels"
mkdir -p "Listen anonymously/Sources/Utilities"
mkdir -p "Listen anonymously/Resources"

# Create directory structure for extension
mkdir -p "Listen anonymously Ext/Sources"
mkdir -p "Listen anonymously Ext/Sources/Views"
mkdir -p "Listen anonymously Ext/Sources/ViewModels"
mkdir -p "Listen anonymously Ext/Resources"

# Create directory structure for shared framework
mkdir -p "Listen Anonymously Shared/Sources/Models"
mkdir -p "Listen Anonymously Shared/Sources/Services"
mkdir -p "Listen Anonymously Shared/Sources/Views"
mkdir -p "Listen Anonymously Shared/Sources/Extensions"
mkdir -p "Listen Anonymously Shared/Sources/Utilities"
mkdir -p "Listen Anonymously Shared/Resources"
```

### Phase 3: Move Main App Files

#### Move Swift Files to Sources

```fish
# Example moves (adjust based on your actual files)
cd "Listen anonymously"

# Move app entry point
mv ListenAnonymouslyApp.swift Sources/App/
mv AppDelegate.swift Sources/App/ # if you have one

# Move views
mv ContentView.swift Sources/Views/
mv LATabView.swift Sources/Views/
mv InstructionsView.swift Sources/Views/
mv OnboardingView.swift Sources/Views/
# ... move all view files

# Move view models
mv ContentViewModel.swift Sources/ViewModels/
# ... move all view model files

# Move utilities
mv UtilityFile.swift Sources/Utilities/
# ... move all utility files
```

#### Move Resources

```fish
cd "Listen anonymously"

# Move resources
mv Assets.xcassets Resources/
mv Info.plist Resources/
mv LaunchScreen.storyboard Resources/ # if you have one
mv *.lproj Resources/ # Localization files
```

### Phase 4: Move Extension Files

```fish
cd "Listen anonymously Ext"

# Move Swift files
mv ActionViewController.swift Sources/
mv *.swift Sources/ # Any other Swift files

# Move resources
mv Assets.xcassets Resources/
mv Info.plist Resources/
mv MainInterface.storyboard Resources/
```

### Phase 5: Move Shared Framework Files

```fish
cd "Listen Anonymously Shared"

# Move models
mv AppState.swift Sources/Models/
mv AudioFile.swift Sources/Models/
# ... move all model files

# Move services
mv AudioPlayingManager.swift Sources/Services/
mv RevenueCatService.swift Sources/Services/
mv AnalyticsService.swift Sources/Services/
# ... move all service files

# Move views
mv PlayingAnimationView.swift Sources/Views/
mv BorderedOrGlass.swift Sources/Views/
mv SnapshotView.swift Sources/Views/
# ... move all shared view files

# Move extensions
mv Bundle+Extension.swift Sources/Extensions/
mv FileManager+Extension.swift Sources/Extensions/
# ... move all extension files

# Move utilities
mv SnapshotConfiguration.swift Sources/Utilities/
# ... move all utility files

# Move resources (if any)
mv Assets.xcassets Resources/ # if exists
```

### Phase 6: Move Test Files

```fish
# Tests can stay flat (no need for Sources/Resources)
# But you can organize them if you want

cd "Listen anonymously Tests"
mkdir -p Utilities
mkdir -p Snapshots
mv XCTestCase+Snapshots.swift Utilities/

cd "../Listen Anonymously Shared Tests"
mkdir -p Mocks
mv FakeNSExtensionItem.swift Mocks/
```

---

## Alternative: Less Nested Structure

If you prefer a simpler structure without the extra nesting, you can use:

```
Listen anonymously/
├── Sources/
│   ├── ListenAnonymouslyApp.swift
│   ├── ContentView.swift
│   ├── LATabView.swift
│   ├── InstructionsView.swift
│   └── ContentViewModel.swift
└── Resources/
    ├── Assets.xcassets
    └── Info.plist
```

Just move all Swift files into `Sources/` and all resources into `Resources/`.

```fish
# Simpler approach
cd "Listen anonymously"
mkdir -p Sources Resources

# Move all Swift files
mv *.swift Sources/

# Move all resources
mv *.xcassets Resources/
mv Info.plist Resources/
mv *.storyboard Resources/
```

---

## Automated Migration Script (Fish)

```fish
#!/usr/bin/env fish

# Restructure Project Script
set PROJECT_ROOT (pwd)

echo "Restructuring Listen anonymously..."

# Function to create directory if it doesn't exist
function ensure_dir
    if not test -d $argv[1]
        mkdir -p $argv[1]
        echo "Created: $argv[1]"
    end
end

# Main App
echo "Restructuring main app..."
ensure_dir "Listen anonymously/Sources"
ensure_dir "Listen anonymously/Resources"

cd "Listen anonymously"
if test (count *.swift) -gt 0
    mv *.swift Sources/ 2>/dev/null
    echo "Moved Swift files to Sources/"
end
if test -d Assets.xcassets
    mv Assets.xcassets Resources/ 2>/dev/null
end
if test -f Info.plist
    mv Info.plist Resources/ 2>/dev/null
end
cd "$PROJECT_ROOT"

# Extension
echo "Restructuring extension..."
ensure_dir "Listen anonymously Ext/Sources"
ensure_dir "Listen anonymously Ext/Resources"

cd "Listen anonymously Ext"
if test (count *.swift) -gt 0
    mv *.swift Sources/ 2>/dev/null
    echo "Moved Swift files to Sources/"
end
if test -d Assets.xcassets
    mv Assets.xcassets Resources/ 2>/dev/null
end
if test -f Info.plist
    mv Info.plist Resources/ 2>/dev/null
end
if test -f MainInterface.storyboard
    mv MainInterface.storyboard Resources/ 2>/dev/null
end
cd "$PROJECT_ROOT"

# Shared Framework
echo "Restructuring shared framework..."
ensure_dir "Listen Anonymously Shared/Sources"
ensure_dir "Listen Anonymously Shared/Resources"

cd "Listen Anonymously Shared"
if test (count *.swift) -gt 0
    mv *.swift Sources/ 2>/dev/null
    echo "Moved Swift files to Sources/"
end
if test -d Assets.xcassets
    mv Assets.xcassets Resources/ 2>/dev/null
end
cd "$PROJECT_ROOT"

echo "Restructuring complete!"
echo "Run 'tuist generate' to regenerate project."
```

Save as `restructure-project.fish`, make executable, and run:

```fish
chmod +x restructure-project.fish
./restructure-project.fish
```

---

## Update Project.swift (if needed)

After restructuring, verify your `Project.swift` paths are correct:

```swift
.target(
    name: "Listen anonymously",
    // ...
    sources: ["Listen anonymously/Sources/**"],
    resources: ["Listen anonymously/Resources/**"],
    // ...
)
```

The `**` wildcard means "all files recursively", so it will find files in:
- `Listen anonymously/Sources/` (flat)
- `Listen anonymously/Sources/Views/` (nested)
- `Listen anonymously/Sources/ViewModels/` (nested)
- etc.

---

## Handle Info.plist

### Important: Info.plist Considerations

In Tuist, Info.plist can be:

1. **Inline** (defined in Project.swift) - Recommended
2. **External** (file in Resources/) - Traditional

If you move Info.plist to Resources, Tuist may still generate its own Info.plist. To use your existing one:

```swift
.target(
    name: "Listen anonymously",
    // ...
    infoPlist: .file(path: "Listen anonymously/Resources/Info.plist"),
    // ...
)
```

Or keep using the inline approach already in Project.swift:

```swift
infoPlist: .extendingDefault(with: [
    "PostHogAPIKey": "$(POSTHOG_API_KEY)",
    "RevenueCatAPIKey": "$(REVENUE_CAT_KEY)",
    // ... other keys
])
```

---

## After Restructuring

### 1. Verify Structure

```fish
# Check main app
ls -R "Listen anonymously"

# Should show:
# Listen anonymously/
# ├── Sources/
# │   └── (Swift files)
# └── Resources/
#     └── (Assets, Info.plist, etc.)
```

### 2. Clean Old Generated Files

```fish
# Remove old generated project
rm -rf *.xcodeproj
rm -rf *.xcworkspace
rm -rf .tuist
```

### 3. Generate Fresh Project

```fish
tuist generate
```

### 4. Open and Build

```fish
open "Listen anonymously.xcworkspace"
```

Build in Xcode (Cmd+B) and verify everything works.

### 5. Commit Changes

```fish
git add .
git status # Verify changes
git commit -m "Restructure project with Sources and Resources directories"
```

---

## Troubleshooting

### Files Not Found After Restructuring

**Problem:** Xcode can't find files after restructuring.

**Solution:** 
1. Verify files are in correct locations
2. Run `tuist generate` again
3. Clean build folder (Cmd+Shift+K)
4. Build again

### Import Statements Broken

**Problem:** `import ListenAnonymouslyShared` not working.

**Solution:** This shouldn't be affected by file location, but if it is:
1. Verify framework is in dependencies
2. Run `tuist generate`
3. Clean and rebuild

### Resources Not Loading

**Problem:** Assets.xcassets images not showing.

**Solution:**
1. Verify `Assets.xcassets` is in `Resources/` directory
2. Check `resources: ["Listen anonymously/Resources/**"]` in Project.swift
3. Run `tuist generate`

### Info.plist Issues

**Problem:** App won't launch, plist errors.

**Solution:**
Use inline plist in Project.swift instead of file:

```swift
infoPlist: .extendingDefault(with: [
    "UILaunchScreen": [:],
    "PostHogAPIKey": "$(POSTHOG_API_KEY)",
    // ... other keys
])
```

---

## Summary Checklist

- [ ] Backup project (git branch or copy)
- [ ] Create `Sources/` and `Resources/` directories for each target
- [ ] Move Swift files to `Sources/`
- [ ] Move resources to `Resources/`
- [ ] Update `Project.swift` if using file-based Info.plist
- [ ] Run `tuist generate`
- [ ] Build and test
- [ ] Commit changes

---

## Quick Command Summary

```fish
# Create structure
mkdir -p "Listen anonymously/Sources"
mkdir -p "Listen anonymously/Resources"
mkdir -p "Listen anonymously Ext/Sources"
mkdir -p "Listen anonymously Ext/Resources"
mkdir -p "Listen Anonymously Shared/Sources"
mkdir -p "Listen Anonymously Shared/Resources"

# Move files (example)
cd "Listen anonymously"
mv *.swift Sources/
mv Assets.xcassets Resources/
mv Info.plist Resources/

# Regenerate
cd ..
tuist generate

# Open
open "Listen anonymously.xcworkspace"
```

---

## Benefits of This Structure

1. **Clear Separation** - Code vs Resources
2. **Easy Navigation** - Know where to find things
3. **Better Organization** - Can nest further (Views/, ViewModels/, etc.)
4. **Standard Practice** - Follows iOS conventions
5. **Tuist Compatible** - Works perfectly with `sources:` and `resources:` paths

---

## Need Help?

If you get stuck:

1. Check file locations: `ls -R "Listen anonymously"`
2. Check Project.swift paths match your structure
3. Run `tuist generate` after any changes
4. Clean and rebuild in Xcode

Happy restructuring! 🏗️
