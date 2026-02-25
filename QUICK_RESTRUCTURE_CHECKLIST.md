# Quick Restructuring Checklist

Use this checklist to quickly reorganize your project structure.

## ⚠️ The Problem

Your Project.swift expects:
```
sources: ["Listen anonymously/Sources/**"]
resources: ["Listen anonymously/Resources/**"]
```

But your files are currently at:
```
Listen anonymously/
├── YourFile.swift        ← Directly here (wrong!)
└── Assets.xcassets       ← Directly here (wrong!)
```

They need to be at:
```
Listen anonymously/
├── Sources/
│   └── YourFile.swift    ← In Sources/ (correct!)
└── Resources/
    └── Assets.xcassets   ← In Resources/ (correct!)
```

---

## ✅ Quick Fix (5 Minutes)

### Step 1: Backup

```fish
git checkout -b backup-before-restructure
git add .
git commit -m "Backup before restructuring"
git checkout main
```

### Step 2: Create Directories

```fish
# Main app
mkdir -p "Listen anonymously/Sources"
mkdir -p "Listen anonymously/Resources"

# Extension
mkdir -p "Listen anonymously Ext/Sources"
mkdir -p "Listen anonymously Ext/Resources"

# Shared framework
mkdir -p "Listen Anonymously Shared/Sources"
mkdir -p "Listen Anonymously Shared/Resources"
```

### Step 3: Move Main App Files

```fish
cd "Listen anonymously"

# Move Swift files
mv *.swift Sources/ 2>/dev/null
echo "Moved Swift files to Sources/"

# Move resources
mv *.xcassets Resources/ 2>/dev/null
mv Info.plist Resources/ 2>/dev/null
mv *.storyboard Resources/ 2>/dev/null
mv *.lproj Resources/ 2>/dev/null
echo "Moved resources to Resources/"

cd ..
```

### Step 4: Move Extension Files

```fish
cd "Listen anonymously Ext"

# Move Swift files
mv *.swift Sources/ 2>/dev/null

# Move resources
mv *.xcassets Resources/ 2>/dev/null
mv Info.plist Resources/ 2>/dev/null
mv *.storyboard Resources/ 2>/dev/null

cd ..
```

### Step 5: Move Shared Framework Files

```fish
cd "Listen Anonymously Shared"

# Move Swift files
mv *.swift Sources/ 2>/dev/null

# Move resources
mv *.xcassets Resources/ 2>/dev/null

cd ..
```

### Step 6: Clean & Generate

```fish
# Clean old generated files
rm -rf *.xcodeproj
rm -rf *.xcworkspace
rm -rf .tuist

# Generate fresh project
tuist generate
```

### Step 7: Open & Build

```fish
open "Listen anonymously.xcworkspace"
```

Build in Xcode (Cmd+B) and verify everything works!

### Step 8: Commit

```fish
git add .
git commit -m "Restructure: Organize files into Sources and Resources directories"
```

---

## 📋 Verification Checklist

After restructuring, verify:

- [ ] `Listen anonymously/Sources/` exists and contains .swift files
- [ ] `Listen anonymously/Resources/` exists and contains assets
- [ ] `Listen anonymously Ext/Sources/` exists and contains .swift files
- [ ] `Listen anonymously Ext/Resources/` exists and contains assets
- [ ] `Listen Anonymously Shared/Sources/` exists and contains .swift files
- [ ] `Listen Anonymously Shared/Resources/` exists (may be empty)
- [ ] `tuist generate` runs without errors
- [ ] Project opens in Xcode
- [ ] Project builds successfully (Cmd+B)
- [ ] All tests pass (Cmd+U)
- [ ] No files left at target root level (except subdirectories)

---

## 🔍 Quick Verification Commands

```fish
# Check structure
echo "Main App:"
ls -la "Listen anonymously/Sources" | head -n 5
ls -la "Listen anonymously/Resources" | head -n 5

echo "\nExtension:"
ls -la "Listen anonymously Ext/Sources" | head -n 5
ls -la "Listen anonymously Ext/Resources" | head -n 5

echo "\nShared:"
ls -la "Listen Anonymously Shared/Sources" | head -n 5
ls -la "Listen Anonymously Shared/Resources" | head -n 5
```

---

## 🆘 Troubleshooting

### Files Not Moving?

If `mv` says "No such file or directory", the files might already be organized or have different extensions.

**Check what's actually in the directory:**

```fish
ls -la "Listen anonymously/"
```

Look for:
- `.swift` files (should go to Sources/)
- `.xcassets` folders (should go to Resources/)
- `.plist` files (should go to Resources/)
- `.storyboard` files (should go to Resources/)

Then move manually:

```fish
cd "Listen anonymously"
mv SomeFile.swift Sources/
mv SomeAsset.xcassets Resources/
```

### Build Fails After Restructuring?

1. Clean build folder in Xcode (Cmd+Shift+K)
2. Clean Tuist cache: `tuist clean`
3. Regenerate: `tuist generate`
4. Open workspace: `open "Listen anonymously.xcworkspace"`
5. Build again (Cmd+B)

### Files Still in Wrong Place?

Check if there are still files at the root:

```fish
# List files that should have been moved
cd "Listen anonymously"
ls *.swift 2>/dev/null  # Should be empty
ls *.xcassets 2>/dev/null  # Should be empty
```

If you see files, move them:

```fish
mv remaining-file.swift Sources/
mv remaining-asset.xcassets Resources/
```

---

## 📚 Detailed Guides

For more information, see:

- **RESTRUCTURING_GUIDE.md** - Complete guide with detailed explanations
- **DIRECTORY_STRUCTURE_BEFORE_AFTER.md** - Visual before/after comparison
- **ARCHITECTURE_DIAGRAMS.md** - Updated diagrams showing structure

---

## 🎯 One-Liner (Automated)

If you want to automate the whole process:

```fish
# Create and run this script
cat > quick-restructure.fish << 'EOF'
#!/usr/bin/env fish

echo "Creating directories..."
mkdir -p "Listen anonymously/Sources" "Listen anonymously/Resources"
mkdir -p "Listen anonymously Ext/Sources" "Listen anonymously Ext/Resources"
mkdir -p "Listen Anonymously Shared/Sources" "Listen Anonymously Shared/Resources"

echo "Moving main app files..."
cd "Listen anonymously"
mv *.swift Sources/ 2>/dev/null
mv *.xcassets Resources/ 2>/dev/null
mv Info.plist Resources/ 2>/dev/null
mv *.storyboard Resources/ 2>/dev/null
mv *.lproj Resources/ 2>/dev/null
cd ..

echo "Moving extension files..."
cd "Listen anonymously Ext"
mv *.swift Sources/ 2>/dev/null
mv *.xcassets Resources/ 2>/dev/null
mv Info.plist Resources/ 2>/dev/null
mv *.storyboard Resources/ 2>/dev/null
cd ..

echo "Moving shared files..."
cd "Listen Anonymously Shared"
mv *.swift Sources/ 2>/dev/null
mv *.xcassets Resources/ 2>/dev/null
cd ..

echo "Cleaning..."
rm -rf *.xcodeproj *.xcworkspace .tuist

echo "Regenerating..."
tuist generate

echo "✅ Done! Open workspace:"
echo "   open \"Listen anonymously.xcworkspace\""
EOF

chmod +x quick-restructure.fish
./quick-restructure.fish
```

---

## Summary

**Before:**
```
Listen anonymously/
├── File.swift              ❌ Wrong!
└── Assets.xcassets         ❌ Wrong!
```

**After:**
```
Listen anonymously/
├── Sources/
│   └── File.swift          ✅ Correct!
└── Resources/
    └── Assets.xcassets     ✅ Correct!
```

**Commands:**
```fish
mkdir -p "Listen anonymously/Sources" "Listen anonymously/Resources"
cd "Listen anonymously"
mv *.swift Sources/
mv * Resources/ 2>/dev/null
cd ..
tuist generate
```

**Done!** 🎉
