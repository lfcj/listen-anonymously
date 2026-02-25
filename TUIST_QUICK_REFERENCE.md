# Tuist Quick Reference Card

## 🚀 Essential Commands

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `tuist install` | Download SPM dependencies | After cloning, when Package.swift changes |
| `tuist generate` | Generate Xcode project | After cloning, when Project.swift changes |
| `tuist clean` | Remove cached artifacts | When things seem broken |
| `tuist edit` | Edit project manifest | Quick way to edit Project.swift |

## 📦 First Time Setup (New Developer)

### Using Bash

```bash
# 1. Clone repository
git clone [repo-url]
cd listen-anonymously

# 2. Run automated setup
chmod +x setup-tuist.sh
./setup-tuist.sh

# 3. Open workspace
open "Listen anonymously.xcworkspace"

# 4. Build & Run (Cmd+R)
```

### Using Fish Shell + mise (Recommended)

```fish
# 1. Clone repository
git clone [repo-url]
cd listen-anonymously

# 2. Run automated setup
chmod +x setup-tuist.fish
./setup-tuist.fish

# 3. Open workspace
open "Listen anonymously.xcworkspace"

# 4. Build & Run (Cmd+R)
```

**Time:** ~5 minutes  
**See also:** `FISH_SHELL_GUIDE.md` for detailed Fish + mise setup

## 🔄 Daily Workflow

### Scenario 1: Working on Code (Most Common)

```bash
# Just work in Xcode normally!
# No Tuist commands needed
```

### Scenario 2: Project Configuration Changed

```bash
# Someone updated Project.swift
git pull
tuist generate
# Continue working
```

### Scenario 3: Dependencies Changed

```bash
# Someone updated Package.swift
git pull
tuist install
tuist generate
# Continue working
```

### Scenario 4: You Update Project Configuration

```bash
# Edit Project.swift
tuist generate
# Test changes
git add Project.swift
git commit -m "Add new target"
```

## 📝 Common Tasks

### Add a New Swift File

```bash
# Just add it to your target folder!
# Project.swift uses wildcards (**), so it's automatic
# No Tuist commands needed
```

### Add a New Target

```swift
// Edit Project.swift
.target(
    name: "New Target",
    destinations: [.iPhone, .iPad],
    product: .framework,
    bundleId: "com.lfcj.new-target",
    deploymentTargets: .iOS("18.0"),
    sources: ["New Target/Sources/**"],
    dependencies: []
)
```

```bash
tuist generate
```

### Add a New SPM Package

```swift
// 1. Edit Package.swift
.package(url: "https://github.com/owner/package.git", from: "1.0.0")

// 2. Edit Project.swift target dependencies
dependencies: [
    .external(name: "PackageName")
]
```

```bash
tuist install
tuist generate
```

### Change Deployment Target

```xcconfig
# Edit Debug.xcconfig and Release.xcconfig
DEPLOYMENT_TARGET = 18
```

```bash
tuist generate
```

### Update Code Signing

```xcconfig
# Edit Secrets.xcconfig
DEV_TEAM_SECRET = YOUR_NEW_TEAM_ID
```

```bash
tuist generate
```

## 🔍 Troubleshooting

| Problem | Solution |
|---------|----------|
| "No such module" error | `tuist install` |
| Build settings not applied | `tuist clean && tuist generate` |
| Secrets not found | Create `Secrets.xcconfig` from example |
| Dependency not resolving | `tuist clean && tuist install && tuist generate` |
| Project seems corrupted | `tuist clean && rm -rf .tuist && tuist generate` |
| Xcode can't find workspace | Run `tuist generate` first |

## 🔐 Security Checklist

### ✅ Safe (Can Commit)
- `Project.swift`
- `Package.swift`
- `Debug.xcconfig`
- `Release.xcconfig`
- `Secrets.xcconfig.example`

### ❌ Never Commit
- `Secrets.xcconfig` (contains actual secrets)
- `*.xcodeproj` (generated)
- `*.xcworkspace` (generated)

### 🔒 Verify Secrets are Hidden

```bash
# Check that your team ID is NOT in committed files
git grep "G7YAMEJH7M"  # Should find nothing

# Check that variable references ARE present
git grep "DEV_TEAM_SECRET"  # Should find xcconfig and Project.swift
```

## 📁 File Structure Quick Map

```
Where is...                    Located in...
─────────────────────────────────────────────────────
Target configuration           Project.swift
SPM dependencies              Package.swift
Build settings                Debug/Release.xcconfig
Secrets                       Secrets.xcconfig (local)
Main app code                 Listen anonymously/Sources/
Extension code                Listen anonymously Ext/Sources/
Shared code                   Listen Anonymously Shared/Sources/
Tests                         [Target Name] Tests/
Generated project             *.xcodeproj (not committed)
```

## 🎯 Build Configurations

| Configuration | xcconfig File | Use Case |
|---------------|---------------|----------|
| Debug | `Debug.xcconfig` | Development, debugging |
| Release | `Release.xcconfig` | App Store, TestFlight |

Both include `Secrets.xcconfig` for sensitive data.

## 🧪 Testing

### Run All Tests

```bash
# In Xcode: Cmd+U

# Or command line:
xcodebuild test \
  -workspace "Listen anonymously.xcworkspace" \
  -scheme "Listen anonymously" \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

### Run Tests with Coverage

```bash
# In Xcode: Cmd+U (coverage is enabled in scheme)

# Or command line:
xcodebuild test \
  -workspace "Listen anonymously.xcworkspace" \
  -scheme "Listen anonymously" \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  -enableCodeCoverage YES
```

### Via Fastlane

```bash
bundle exec fastlane ios all_tests
```

## 🚢 CI/CD Quick Check

### Required GitHub Secrets

| Secret Name | Description |
|------------|-------------|
| `DEVELOPMENT_TEAM` | Apple Developer Team ID |
| `POSTHOG_API_KEY` | PostHog analytics key |
| `REVENUE_CAT_KEY` | RevenueCat API key |
| `CODECOV_TOKEN` | Codecov upload token |

### Workflow Steps

1. Install Tuist
2. Create Secrets.xcconfig from secrets
3. Run `tuist install`
4. Run `tuist generate`
5. Run tests
6. Upload coverage

## 📚 Documentation Map

| Need to... | Read... |
|-----------|---------|
| Set up for first time | `TUIST_SETUP.md` |
| Use Fish shell + mise | `FISH_SHELL_GUIDE.md` |
| Migrate from pbxproj | `TUIST_MIGRATION_CHECKLIST.md` |
| Understand structure | `PROJECT_STRUCTURE.md` |
| See what changed | `BEFORE_AFTER_COMPARISON.md` |
| View architecture | `ARCHITECTURE_DIAGRAMS.md` |
| Get complete overview | `TUIST_INTEGRATION_SUMMARY.md` |
| Quick commands | This file! |

## ⌨️ Useful Aliases (Optional)

### Bash/Zsh

Add to your `~/.zshrc` or `~/.bashrc`:

```bash
# Tuist shortcuts
alias tg='tuist generate'
alias ti='tuist install'
alias tc='tuist clean'
alias tig='tuist install && tuist generate'
alias tcg='tuist clean && tuist generate'

# Project shortcuts
alias openla='open "Listen anonymously.xcworkspace"'
```

### Fish Shell

Add to your `~/.config/fish/config.fish`:

```fish
# Tuist shortcuts
alias tg='tuist generate'
alias ti='tuist install'
alias tc='tuist clean'
alias tig='tuist install; and tuist generate'
alias tcg='tuist clean; and tuist generate'

# Project shortcuts
alias openla='open "Listen anonymously.xcworkspace"'
```

Then:

```bash
tg          # Generate project
ti          # Install dependencies
tig         # Install + Generate
openla      # Open workspace
```

## 🎨 Xcode Schemes

| Scheme | Purpose |
|--------|---------|
| Listen anonymously | Build app, run all tests |

All test targets are included in the main scheme.

## 🔄 Update Workflow

### Tuist New Version Available

```bash
# Update Tuist
curl -Ls https://install.tuist.io | bash

# Or with Homebrew
brew upgrade tuist

# Verify version
tuist version

# Regenerate project
tuist clean
tuist generate
```

### Dependencies Update Available

```bash
# Update Package.swift version constraints
# Then:
tuist clean
tuist install
tuist generate
```

## 💡 Tips & Tricks

### Speed Up Generation

```bash
# Generate without dependencies check
tuist generate --no-open

# Then open manually
open "Listen anonymously.xcworkspace"
```

### Clean Everything

```bash
# Nuclear option - removes all generated/cached files
tuist clean
rm -rf .tuist
rm -rf Tuist/Dependencies
rm -rf *.xcodeproj
rm -rf *.xcworkspace
rm -rf DerivedData

# Then regenerate
tuist install
tuist generate
```

### Edit Project.swift with Xcode

```bash
# Opens Project.swift in special Xcode project
tuist edit

# With autocomplete and syntax highlighting!
```

### Validate Project Definition

```bash
# Generate will validate configuration
tuist generate

# If successful, your project is valid!
```

## 🐛 Debug Mode

### Verbose Output

```bash
tuist generate --verbose

# Or for install
tuist install --verbose
```

### Check Configuration

```bash
# Print resolved configuration
tuist graph
```

## 🎓 Learning Resources

| Resource | URL |
|----------|-----|
| Tuist Docs | https://docs.tuist.io |
| Tuist Examples | https://github.com/tuist/tuist/tree/main/fixtures |
| Project Structure | `PROJECT_STRUCTURE.md` in this repo |
| Migration Guide | `TUIST_SETUP.md` in this repo |

## 📞 Getting Help

1. **Check documentation** (see map above)
2. **Run troubleshooting** (see table above)
3. **Check Tuist docs** (https://docs.tuist.io)
4. **Ask team** (they might have seen it)
5. **Tuist Community** (https://community.tuist.io)

## ✅ Pre-Commit Checklist

Before committing Project.swift or Package.swift changes:

- [ ] Run `tuist generate` successfully
- [ ] Build succeeds in Xcode
- [ ] Tests pass
- [ ] No secrets in committed files
- [ ] Updated documentation if needed

## 🎯 Quick Verification

### Check Setup is Correct

```bash
# All these should exist:
ls Project.swift          # ✅
ls Package.swift          # ✅
ls Secrets.xcconfig       # ✅
ls Debug.xcconfig         # ✅
ls Release.xcconfig       # ✅

# These should NOT be committed:
git ls-files | grep xcodeproj    # Should be empty
git ls-files | grep xcworkspace  # Should be empty
git ls-files | grep "Secrets.xcconfig$"  # Should be empty
```

### Verify Secrets are Hidden

```bash
# Your actual team ID should NOT appear in committed files
git grep "G7YAMEJH7M"  # Should find nothing

# Variable references SHOULD appear
git grep "DEV_TEAM_SECRET"  # Should find xcconfig files
```

## 🔢 Version Info

| Component | Version |
|-----------|---------|
| Xcode | 16.0+ |
| Swift | 6.0 |
| iOS Deployment | 18.0 |
| Tuist | Latest (installed via script) |

---

## 📋 Most Common Commands Summary

```bash
# First time setup
./setup-tuist.sh

# After pulling changes
tuist generate

# After dependency changes
tuist install && tuist generate

# When things break
tuist clean && tuist generate

# Open project
open "Listen anonymously.xcworkspace"
```

---

**Keep this file handy!** Bookmark it or print it out. It covers 90% of what you'll need day-to-day.
