# Visual Migration Guide

## 🎯 The Problem (Visual)

### What Your Project.swift Says

```swift
sources: ["Listen anonymously/Sources/**"]
         ↓
         Looking for: Listen anonymously/Sources/
         ↓
         Status: ❌ Directory not found!
```

### What You Currently Have

```
Listen anonymously/
├── File1.swift            ← Tuist can't find this (wrong location)
├── File2.swift            ← Tuist can't find this (wrong location)
├── File3.swift            ← Tuist can't find this (wrong location)
├── Assets.xcassets        ← Tuist can't find this (wrong location)
└── Info.plist             ← Tuist can't find this (wrong location)
```

### What You Need

```
Listen anonymously/
├── Sources/                    ← Tuist looks here ✅
│   ├── File1.swift            ← Found! ✅
│   ├── File2.swift            ← Found! ✅
│   └── File3.swift            ← Found! ✅
└── Resources/                  ← Tuist looks here ✅
    ├── Assets.xcassets        ← Found! ✅
    └── Info.plist             ← Found! ✅
```

---

## 📊 Migration Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    STEP 1: Current State                     │
│                         (Broken)                             │
└─────────────────────────────────────────────────────────────┘
                               │
    Listen anonymously/        │
    ├── App.swift             │
    ├── View.swift            │
    └── Assets.xcassets       │
                               │
                Project.swift looks for:
                "Listen anonymously/Sources/**"
                               │
                               ▼
                        ❌ Not found!
                               │
                               │
┌──────────────────────────────┴──────────────────────────────┐
│                    STEP 2: Create Directories                │
│              mkdir -p Sources Resources                      │
└─────────────────────────────────────────────────────────────┘
                               │
    Listen anonymously/        │
    ├── Sources/     ← NEW!   │
    ├── Resources/   ← NEW!   │
    ├── App.swift             │
    ├── View.swift            │
    └── Assets.xcassets       │
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                    STEP 3: Move Files                        │
│                  mv *.swift Sources/                         │
│                  mv *.xcassets Resources/                    │
└─────────────────────────────────────────────────────────────┘
                               │
    Listen anonymously/        │
    ├── Sources/              │
    │   ├── App.swift    ✅    │
    │   └── View.swift   ✅    │
    └── Resources/            │
        └── Assets.xcassets ✅│
                               │
                Project.swift looks for:
                "Listen anonymously/Sources/**"
                               │
                               ▼
                        ✅ Found!
                               │
┌──────────────────────────────┴──────────────────────────────┐
│                    STEP 4: Generate                          │
│                      tuist generate                          │
└─────────────────────────────────────────────────────────────┘
                               │
                               ▼
                    ✅ Success! Build Ready!
```

---

## 🔄 Before → After Transformation

### Target 1: Main App

#### Before (❌ Broken)

```
Listen anonymously/
├── ListenAnonymouslyApp.swift      ← Not in Sources/
├── ContentView.swift               ← Not in Sources/
├── LATabView.swift                 ← Not in Sources/
├── InstructionsView.swift          ← Not in Sources/
├── Assets.xcassets                 ← Not in Resources/
└── Info.plist                      ← Not in Resources/

Tuist scans: "Listen anonymously/Sources/**"
Result: ❌ No files found
Build: ❌ Fails (empty target)
```

#### After (✅ Working)

```
Listen anonymously/
├── Sources/                        ← Tuist finds this! ✅
│   ├── ListenAnonymouslyApp.swift
│   ├── ContentView.swift
│   ├── LATabView.swift
│   └── InstructionsView.swift
└── Resources/                      ← Tuist finds this! ✅
    ├── Assets.xcassets
    └── Info.plist

Tuist scans: "Listen anonymously/Sources/**"
Result: ✅ 4 Swift files found
Build: ✅ Success!
```

### Target 2: Extension

#### Before (❌ Broken)

```
Listen anonymously Ext/
├── ActionViewController.swift      ← Not in Sources/
├── AudioPlayingView.swift          ← Not in Sources/
├── Assets.xcassets                 ← Not in Resources/
├── Info.plist                      ← Not in Resources/
└── MainInterface.storyboard        ← Not in Resources/

Tuist scans: "Listen anonymously Ext/Sources/**"
Result: ❌ No files found
```

#### After (✅ Working)

```
Listen anonymously Ext/
├── Sources/                        ← Tuist finds this! ✅
│   ├── ActionViewController.swift
│   └── AudioPlayingView.swift
└── Resources/                      ← Tuist finds this! ✅
    ├── Assets.xcassets
    ├── Info.plist
    └── MainInterface.storyboard

Tuist scans: "Listen anonymously Ext/Sources/**"
Result: ✅ 2 Swift files found
```

### Target 3: Shared Framework

#### Before (❌ Broken)

```
Listen Anonymously Shared/
├── AudioPlayingManager.swift       ← Not in Sources/
├── RevenueCatService.swift         ← Not in Sources/
├── PlayingAnimationView.swift     ← Not in Sources/
├── BorderedOrGlass.swift           ← Not in Sources/
├── Bundle+Extension.swift          ← Not in Sources/
└── Assets.xcassets                 ← Not in Resources/

Tuist scans: "Listen Anonymously Shared/Sources/**"
Result: ❌ No files found
```

#### After (✅ Working)

```
Listen Anonymously Shared/
├── Sources/                        ← Tuist finds this! ✅
│   ├── AudioPlayingManager.swift
│   ├── RevenueCatService.swift
│   ├── PlayingAnimationView.swift
│   ├── BorderedOrGlass.swift
│   └── Bundle+Extension.swift
└── Resources/                      ← Tuist finds this! ✅
    └── Assets.xcassets

Tuist scans: "Listen Anonymously Shared/Sources/**"
Result: ✅ 5 Swift files found
```

---

## 📋 Migration Steps (Visual)

### Step 1: Identify Current Files

```
$ ls "Listen anonymously/"

Results:
AppFile.swift             ← Swift file (needs moving)
ViewController.swift      ← Swift file (needs moving)
ViewModel.swift           ← Swift file (needs moving)
Assets.xcassets           ← Resource (needs moving)
Info.plist                ← Resource (needs moving)
LaunchScreen.storyboard   ← Resource (needs moving)
```

### Step 2: Create Destination Directories

```
$ mkdir -p "Listen anonymously/Sources"
$ mkdir -p "Listen anonymously/Resources"

New structure:
Listen anonymously/
├── Sources/              ← Created (empty)
├── Resources/            ← Created (empty)
├── AppFile.swift         ← Still at root
├── ViewController.swift  ← Still at root
├── ViewModel.swift       ← Still at root
├── Assets.xcassets       ← Still at root
├── Info.plist            ← Still at root
└── LaunchScreen.storyboard ← Still at root
```

### Step 3: Move Swift Files

```
$ cd "Listen anonymously"
$ mv *.swift Sources/

New structure:
Listen anonymously/
├── Sources/
│   ├── AppFile.swift         ← Moved! ✅
│   ├── ViewController.swift  ← Moved! ✅
│   └── ViewModel.swift       ← Moved! ✅
├── Resources/                ← Still empty
├── Assets.xcassets           ← Still at root
├── Info.plist                ← Still at root
└── LaunchScreen.storyboard   ← Still at root
```

### Step 4: Move Resources

```
$ mv Assets.xcassets Resources/
$ mv Info.plist Resources/
$ mv LaunchScreen.storyboard Resources/

Final structure:
Listen anonymously/
├── Sources/
│   ├── AppFile.swift         ✅
│   ├── ViewController.swift  ✅
│   └── ViewModel.swift       ✅
└── Resources/
    ├── Assets.xcassets       ✅
    ├── Info.plist            ✅
    └── LaunchScreen.storyboard ✅
```

### Step 5: Verify

```
$ ls "Listen anonymously/"

Results:
Sources/      ← Good! ✅
Resources/    ← Good! ✅

No loose files at root level! ✅
```

### Step 6: Generate & Build

```
$ tuist generate

Output:
Generating project Listen anonymously
Loading dependencies
Generating Listen anonymously.xcworkspace
Project generated at: Listen anonymously.xcworkspace

✅ Success!

$ open "Listen anonymously.xcworkspace"
# Build in Xcode (Cmd+B)
✅ Build succeeds!
```

---

## 🎨 Color-Coded Guide

### File Types

```
Types of files in your project:

🔵 Swift Files (.swift)
   → Destination: Sources/
   
🟢 Asset Catalogs (.xcassets)
   → Destination: Resources/
   
🟡 Property Lists (.plist)
   → Destination: Resources/
   
🟣 Storyboards (.storyboard)
   → Destination: Resources/
   
🟠 Localizations (.lproj)
   → Destination: Resources/
```

### Migration Map

```
Before:                              After:
───────                              ──────

Listen anonymously/                  Listen anonymously/
├── 🔵 App.swift                    ├── Sources/
├── 🔵 View.swift                   │   ├── 🔵 App.swift     ✅
├── 🔵 ViewModel.swift              │   ├── 🔵 View.swift    ✅
├── 🟢 Assets.xcassets              │   └── 🔵 ViewModel.swift ✅
├── 🟡 Info.plist                   └── Resources/
└── 🟣 Launch.storyboard                ├── 🟢 Assets.xcassets ✅
                                         ├── 🟡 Info.plist      ✅
                                         └── 🟣 Launch.storyboard ✅
```

---

## 🔍 Common Scenarios

### Scenario 1: Completely Flat Structure

**You have:**
```
Listen anonymously/
├── File1.swift
├── File2.swift
├── File3.swift
├── File4.swift
├── Assets.xcassets
└── Info.plist
```

**Quick fix:**
```fish
cd "Listen anonymously"
mkdir -p Sources Resources
mv *.swift Sources/
mv * Resources/ 2>/dev/null
```

**Result:**
```
Listen anonymously/
├── Sources/
│   ├── File1.swift
│   ├── File2.swift
│   ├── File3.swift
│   └── File4.swift
└── Resources/
    ├── Assets.xcassets
    └── Info.plist
```

### Scenario 2: Partially Organized

**You have:**
```
Listen anonymously/
├── Views/
│   ├── View1.swift
│   └── View2.swift
├── ViewModels/
│   └── ViewModel.swift
├── App.swift
└── Assets.xcassets
```

**Fix: Move everything under Sources/**
```fish
cd "Listen anonymously"
mkdir -p Sources Resources
mv Views Sources/
mv ViewModels Sources/
mv App.swift Sources/
mv Assets.xcassets Resources/
```

**Result:**
```
Listen anonymously/
├── Sources/
│   ├── Views/
│   │   ├── View1.swift
│   │   └── View2.swift
│   ├── ViewModels/
│   │   └── ViewModel.swift
│   └── App.swift
└── Resources/
    └── Assets.xcassets
```

### Scenario 3: Mixed Files

**You have:**
```
Listen anonymously/
├── SomeFile.swift
├── SomeOtherFile.swift
├── OldFolder/
│   └── LegacyCode.swift
├── Assets.xcassets
└── Info.plist
```

**Fix:**
```fish
cd "Listen anonymously"
mkdir -p Sources Resources

# Move Swift files
mv *.swift Sources/
mv OldFolder Sources/  # Move entire folder

# Move resources
mv Assets.xcassets Resources/
mv Info.plist Resources/
```

**Result:**
```
Listen anonymously/
├── Sources/
│   ├── SomeFile.swift
│   ├── SomeOtherFile.swift
│   └── OldFolder/
│       └── LegacyCode.swift
└── Resources/
    ├── Assets.xcassets
    └── Info.plist
```

---

## ✅ Success Indicators

### Before Migration (Broken)

```
$ tuist generate

⚠️  Warning: No source files found for target "Listen anonymously"
⚠️  Warning: No resources found for target "Listen anonymously"
❌ Build failed: Undefined symbols
```

### After Migration (Working)

```
$ tuist generate

✅ Generating project Listen anonymously
✅ Found 8 source files
✅ Found 3 resources
✅ Project generated successfully

$ xcodebuild build

✅ Build succeeded
```

---

## 🎯 Quick Verification

Run this to check your structure:

```fish
#!/usr/bin/env fish

function check_target
    set target $argv[1]
    
    echo "Checking: $target"
    
    if test -d "$target/Sources"
        echo "  ✅ Sources/ exists"
    else
        echo "  ❌ Sources/ missing"
    end
    
    if test -d "$target/Resources"
        echo "  ✅ Resources/ exists"
    else
        echo "  ❌ Resources/ missing"
    end
    
    set loose_swift (find "$target" -maxdepth 1 -name "*.swift" | wc -l)
    if test $loose_swift -eq 0
        echo "  ✅ No loose Swift files"
    else
        echo "  ❌ $loose_swift Swift files at root (should be in Sources/)"
    end
    
    echo ""
end

check_target "Listen anonymously"
check_target "Listen anonymously Ext"
check_target "Listen Anonymously Shared"
```

---

## Summary

**The Pattern:**

```
❌ Before:  TargetName/File.swift
✅ After:   TargetName/Sources/File.swift

❌ Before:  TargetName/Assets.xcassets
✅ After:   TargetName/Resources/Assets.xcassets
```

**The Commands:**

```fish
mkdir -p "TargetName/Sources" "TargetName/Resources"
cd "TargetName"
mv *.swift Sources/
mv * Resources/ 2>/dev/null
```

**The Result:**

```
✅ Tuist finds your files
✅ Project generates
✅ Build succeeds
```

---

Ready to migrate? See **QUICK_RESTRUCTURE_CHECKLIST.md** for the fastest path! 🚀
