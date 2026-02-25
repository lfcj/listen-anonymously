# Directory Structure: Before vs After

## ❌ Current Structure (Flat - Doesn't Match Tuist Expectations)

```
listen-anonymously/
│
├── Project.swift
├── Package.swift
├── Config.swift
├── .mise.toml
├── setup-tuist.fish
├── Debug.xcconfig
├── Release.xcconfig
├── Secrets.xcconfig
│
├── Listen anonymously/                    ⚠️ All files mixed together
│   ├── ListenAnonymouslyApp.swift        ← Swift file
│   ├── ContentView.swift                 ← Swift file
│   ├── LATabView.swift                   ← Swift file
│   ├── InstructionsView.swift            ← Swift file
│   ├── OnboardingView.swift              ← Swift file
│   ├── ContentViewModel.swift            ← Swift file
│   ├── Assets.xcassets                   ← Resource
│   ├── Info.plist                        ← Resource
│   ├── LaunchScreen.storyboard           ← Resource
│   └── en.lproj/                         ← Resource
│
├── Listen anonymously Ext/                ⚠️ All files mixed together
│   ├── ActionViewController.swift        ← Swift file
│   ├── AudioPlayingView.swift            ← Swift file
│   ├── Assets.xcassets                   ← Resource
│   ├── Info.plist                        ← Resource
│   └── MainInterface.storyboard          ← Resource
│
├── Listen Anonymously Shared/             ⚠️ All files mixed together
│   ├── AppState.swift                    ← Swift file
│   ├── AudioPlayingManager.swift         ← Swift file
│   ├── RevenueCatService.swift           ← Swift file
│   ├── PlayingAnimationView.swift        ← Swift file
│   ├── BorderedOrGlass.swift             ← Swift file
│   ├── Bundle+Extension.swift            ← Swift file
│   ├── FileManager+Extension.swift       ← Swift file
│   ├── SnapshotConfiguration.swift       ← Swift file
│   └── Assets.xcassets                   ← Resource
│
├── Listen anonymously Tests/
│   ├── AppTests.swift
│   ├── ViewTests.swift
│   └── XCTestCase+Snapshots.swift
│
├── Listen Anonymously Shared Tests/
│   ├── AudioPlayingManagerTests.swift
│   ├── RevenueCatServiceTests.swift
│   └── FakeNSExtensionItem.swift
│
└── Listen anonymously Ext Tests/
    └── ActionViewControllerTests.swift
```

**Problem with Current Structure:**

```swift
// In Project.swift:
sources: ["Listen anonymously/Sources/**"],  // ❌ Sources/ doesn't exist!
resources: ["Listen anonymously/Resources/**"], // ❌ Resources/ doesn't exist!
```

Tuist looks for `Sources/` and `Resources/` subdirectories, but all your files are at the root of each target directory.

---

## ✅ Expected Structure (Organized - Matches Tuist Expectations)

```
listen-anonymously/                        ← Repository root
│
├── 🔧 Tuist Configuration
├── Project.swift
├── Package.swift
├── Config.swift
├── .mise.toml
├── setup-tuist.fish
│
├── ⚙️ Build Configuration
├── Debug.xcconfig
├── Release.xcconfig
├── Secrets.xcconfig
│
├── 📱 Main App Target
├── Listen anonymously/
│   ├── Sources/                          ✅ All Swift files here
│   │   ├── App/
│   │   │   └── ListenAnonymouslyApp.swift
│   │   ├── Views/
│   │   │   ├── ContentView.swift
│   │   │   ├── LATabView.swift
│   │   │   ├── InstructionsView.swift
│   │   │   └── OnboardingView.swift
│   │   └── ViewModels/
│   │       └── ContentViewModel.swift
│   └── Resources/                        ✅ All resources here
│       ├── Assets.xcassets
│       ├── Info.plist
│       ├── LaunchScreen.storyboard
│       └── en.lproj/
│
├── 🧩 Extension Target
├── Listen anonymously Ext/
│   ├── Sources/                          ✅ All Swift files here
│   │   ├── ActionViewController.swift
│   │   └── Views/
│   │       └── AudioPlayingView.swift
│   └── Resources/                        ✅ All resources here
│       ├── Assets.xcassets
│       ├── Info.plist
│       └── MainInterface.storyboard
│
├── 📦 Shared Framework Target
├── Listen Anonymously Shared/
│   ├── Sources/                          ✅ All Swift files here
│   │   ├── Models/
│   │   │   └── AppState.swift
│   │   ├── Services/
│   │   │   ├── AudioPlayingManager.swift
│   │   │   └── RevenueCatService.swift
│   │   ├── Views/
│   │   │   ├── PlayingAnimationView.swift
│   │   │   └── BorderedOrGlass.swift
│   │   ├── Extensions/
│   │   │   ├── Bundle+Extension.swift
│   │   │   └── FileManager+Extension.swift
│   │   └── Utilities/
│   │       └── SnapshotConfiguration.swift
│   └── Resources/                        ✅ All resources here
│       └── Assets.xcassets
│
├── 🧪 Test Targets (can stay flat)
├── Listen anonymously Tests/
│   ├── AppTests.swift
│   ├── ViewTests.swift
│   └── Utilities/
│       └── XCTestCase+Snapshots.swift
│
├── Listen Anonymously Shared Tests/
│   ├── AudioPlayingManagerTests.swift
│   ├── RevenueCatServiceTests.swift
│   └── Mocks/
│       └── FakeNSExtensionItem.swift
│
└── Listen anonymously Ext Tests/
    └── ActionViewControllerTests.swift
```

**Now Project.swift Works:**

```swift
// In Project.swift:
sources: ["Listen anonymously/Sources/**"],  // ✅ Found!
resources: ["Listen anonymously/Resources/**"], // ✅ Found!
```

---

## Side-by-Side Comparison: Single Target

### ❌ Before (Flat)

```
Listen anonymously/
├── File1.swift          ← Code
├── File2.swift          ← Code  
├── File3.swift          ← Code
├── Assets.xcassets      ← Resource
└── Info.plist           ← Resource
```

**Tuist looks for:**
- `Listen anonymously/Sources/**` ← Doesn't exist!
- `Listen anonymously/Resources/**` ← Doesn't exist!

### ✅ After (Organized)

```
Listen anonymously/
├── Sources/             ← Tuist finds this!
│   ├── File1.swift
│   ├── File2.swift
│   └── File3.swift
└── Resources/           ← Tuist finds this!
    ├── Assets.xcassets
    └── Info.plist
```

**Tuist looks for:**
- `Listen anonymously/Sources/**` ← ✅ Found!
- `Listen anonymously/Resources/**` ← ✅ Found!

---

## Migration Path: Step by Step

### Step 1: Current State

```
Listen anonymously/
├── AppFile.swift
├── ViewFile.swift
├── Assets.xcassets
└── Info.plist
```

### Step 2: Create Directories

```fish
mkdir -p "Listen anonymously/Sources"
mkdir -p "Listen anonymously/Resources"
```

```
Listen anonymously/
├── Sources/              ← New (empty)
├── Resources/            ← New (empty)
├── AppFile.swift         ← Old location
├── ViewFile.swift        ← Old location
├── Assets.xcassets       ← Old location
└── Info.plist            ← Old location
```

### Step 3: Move Swift Files

```fish
cd "Listen anonymously"
mv *.swift Sources/
```

```
Listen anonymously/
├── Sources/
│   ├── AppFile.swift     ← Moved
│   └── ViewFile.swift    ← Moved
├── Resources/            ← Still empty
├── Assets.xcassets       ← Still in old location
└── Info.plist            ← Still in old location
```

### Step 4: Move Resources

```fish
mv Assets.xcassets Resources/
mv Info.plist Resources/
```

```
Listen anonymously/
├── Sources/
│   ├── AppFile.swift     ✅
│   └── ViewFile.swift    ✅
└── Resources/
    ├── Assets.xcassets   ✅
    └── Info.plist        ✅
```

### Step 5: Generate & Build

```fish
tuist generate
open "Listen anonymously.xcworkspace"
# Build in Xcode (Cmd+B)
```

---

## What Happens When You Run `tuist generate`

### With Flat Structure (Before)

```
Tuist scans:
  "Listen anonymously/Sources/**"
    ↓
  Directory "Sources" not found
    ↓
  No Swift files included in target! ❌
```

**Result:** Empty target, build fails

### With Organized Structure (After)

```
Tuist scans:
  "Listen anonymously/Sources/**"
    ↓
  Found: Listen anonymously/Sources/
    ↓
  Recursively includes:
    - Sources/AppFile.swift
    - Sources/ViewFile.swift
    - Sources/Views/ContentView.swift
    - Sources/ViewModels/ViewModel.swift
    ↓
  All files included in target! ✅
```

**Result:** Target builds successfully

---

## File Type Reference

### What Goes in Sources/

✅ **Swift files:**
- `.swift` - All Swift source code
- App files, View files, ViewModel files
- Model files, Service files
- Extension files, Utility files

### What Goes in Resources/

✅ **Resource files:**
- `.xcassets` - Asset catalogs (images, colors)
- `.plist` - Info.plist, configuration files
- `.storyboard` - Storyboards
- `.xib` - XIB files
- `.lproj` - Localization folders
- `.strings` - String files
- `.json` - Data files
- `.pdf`, `.png`, `.jpg` - Image files
- `.ttf`, `.otf` - Font files
- `.mp3`, `.wav` - Audio files

---

## Alternative: Simpler Structure (Also Works)

If you don't want nested subdirectories:

```
Listen anonymously/
├── Sources/
│   ├── File1.swift       ← All Swift files at this level
│   ├── File2.swift
│   ├── File3.swift
│   ├── File4.swift
│   └── File5.swift
└── Resources/
    ├── Assets.xcassets   ← All resources at this level
    ├── Info.plist
    └── Launch.storyboard
```

This is perfectly fine! You don't need to organize into subdirectories like `Views/`, `ViewModels/`, etc.

Just put all `.swift` files in `Sources/` and all resources in `Resources/`.

---

## Quick Reference: What Goes Where

| File Type | Current Location | New Location |
|-----------|-----------------|--------------|
| `*.swift` | `Listen anonymously/` | `Listen anonymously/Sources/` |
| `*.xcassets` | `Listen anonymously/` | `Listen anonymously/Resources/` |
| `Info.plist` | `Listen anonymously/` | `Listen anonymously/Resources/` |
| `*.storyboard` | `Listen anonymously/` | `Listen anonymously/Resources/` |
| `*.lproj` | `Listen anonymously/` | `Listen anonymously/Resources/` |

**Repeat for all targets:**
- `Listen anonymously Ext/`
- `Listen Anonymously Shared/`

---

## Verification Commands

### Check Current Structure

```fish
# See what's currently in target directory
ls -la "Listen anonymously/"

# If you see .swift files directly, they need to be moved
```

### Check If Sources/ Exists

```fish
# Check if Sources directory exists
if test -d "Listen anonymously/Sources"
    echo "✅ Sources directory exists"
else
    echo "❌ Sources directory missing - create it!"
end
```

### Check If Resources/ Exists

```fish
# Check if Resources directory exists
if test -d "Listen anonymously/Resources"
    echo "✅ Resources directory exists"
else
    echo "❌ Resources directory missing - create it!"
end
```

### Check File Counts

```fish
# Count Swift files in wrong location
cd "Listen anonymously"
set wrong_location (count *.swift)
echo "Swift files in wrong location: $wrong_location"

# Count Swift files in correct location
if test -d Sources
    set correct_location (count Sources/*.swift)
    echo "Swift files in correct location: $correct_location"
end
```

---

## Summary

### The Rule

```
Target Directory/
├── Sources/     ← All .swift files
└── Resources/   ← All other files (assets, plists, storyboards, etc.)
```

### The Commands

```fish
# 1. Create directories
mkdir -p "Listen anonymously/Sources"
mkdir -p "Listen anonymously/Resources"

# 2. Move files
cd "Listen anonymously"
mv *.swift Sources/
mv *.xcassets Resources/
mv Info.plist Resources/
mv *.storyboard Resources/
mv *.lproj Resources/

# 3. Repeat for other targets
cd "../Listen anonymously Ext"
mkdir -p Sources Resources
mv *.swift Sources/
mv * Resources/ 2>/dev/null  # Move remaining files

# 4. Regenerate project
cd ../..
tuist generate

# 5. Build!
open "Listen anonymously.xcworkspace"
```

---

## Need Help?

See the complete guide: `RESTRUCTURING_GUIDE.md`

Or ask specific questions about your file structure!
