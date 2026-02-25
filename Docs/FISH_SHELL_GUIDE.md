# Fish Shell & mise Setup Guide

This guide explains how to set up the project using **Fish shell** and **mise** (the modern replacement for asdf).

## Prerequisites

### Install mise

```fish
# Using Homebrew (recommended)
brew install mise

# Or using the install script
curl https://mise.run | sh
```

### Configure Fish Shell

Add mise to your Fish configuration:

```fish
# Add to ~/.config/fish/config.fish
mise activate fish | source
```

Or for faster startup, you can use the shims method:

```fish
# Add to ~/.config/fish/config.fish
fish_add_path ~/.local/share/mise/shims
```

Reload your config:

```fish
source ~/.config/fish/config.fish
```

Verify mise is working:

```fish
mise --version
```

## Project Setup

### First Time Setup

```fish
# 1. Clone repository
git clone [repo-url]
cd listen-anonymously

# 2. Run the Fish setup script
chmod +x setup-tuist.fish
./setup-tuist.fish

# 3. Open workspace
open "Listen anonymously.xcworkspace"

# 4. Build & Run (Cmd+R in Xcode)
```

### What the Setup Script Does

1. **Checks for mise** - Ensures mise is installed and configured
2. **Creates .mise.toml** - If it doesn't exist
3. **Installs Tuist via mise** - Runs `mise install`
4. **Validates Secrets.xcconfig** - Ensures all required keys are present
5. **Fetches dependencies** - Runs `tuist install`
6. **Generates project** - Runs `tuist generate`

## Using mise with Tuist

### Version Management

The project uses `.mise.toml` to manage Tuist versions:

```toml
[tools]
tuist = "latest"
```

### Install Specific Version

If you need a specific version:

```fish
# Edit .mise.toml
echo '[tools]' > .mise.toml
echo 'tuist = "4.31.0"' >> .mise.toml

# Install
mise install
```

### Update Tuist

```fish
# Update to latest version
mise upgrade tuist

# Or edit .mise.toml and run
mise install
```

### Check Installed Version

```fish
mise list
# or
tuist --version
```

## Fish Shell Aliases

Add these to your `~/.config/fish/config.fish`:

```fish
# Tuist shortcuts
alias tg='tuist generate'
alias ti='tuist install'
alias tc='tuist clean'
alias tig='tuist install; and tuist generate'
alias tcg='tuist clean; and tuist generate'

# Project shortcuts
alias openla='open "Listen anonymously.xcworkspace"'

# Combined workflow
alias tsetup='mise install; and tuist clean; and tuist install; and tuist generate'
```

Usage:

```fish
tg          # Generate project
ti          # Install dependencies
tig         # Install + Generate
openla      # Open workspace
tsetup      # Full setup/refresh
```

## Fish Functions (Advanced)

Create reusable Fish functions in `~/.config/fish/functions/`:

### tuist-refresh.fish

```fish
function tuist-refresh --description "Clean and regenerate Tuist project"
    set_color yellow
    echo "Cleaning Tuist artifacts..."
    set_color normal
    
    tuist clean
    
    set_color yellow
    echo "Installing dependencies..."
    set_color normal
    
    tuist install
    
    set_color yellow
    echo "Generating project..."
    set_color normal
    
    tuist generate
    
    set_color green
    echo "✓ Project refreshed!"
    set_color normal
end
```

### tuist-open.fish

```fish
function tuist-open --description "Generate and open workspace"
    if not test -d "Listen anonymously.xcworkspace"
        set_color yellow
        echo "Workspace not found, generating..."
        set_color normal
        tuist generate
    end
    
    open "Listen anonymously.xcworkspace"
end
```

Usage:

```fish
tuist-refresh    # Clean + install + generate
tuist-open       # Generate if needed + open
```

## Environment Variables (Fish)

If you need to set environment variables for Tuist:

```fish
# Add to ~/.config/fish/config.fish
set -gx TUIST_CONFIG_CLOUD_URL "https://your-cloud.tuist.io"
set -gx TUIST_CONFIG_CLOUD_TOKEN "your-token"
```

## Daily Workflow (Fish)

### Starting Work

```fish
cd ~/Projects/listen-anonymously
mise install  # Ensures correct Tuist version
tuist generate  # If Project.swift changed
open "Listen anonymously.xcworkspace"
```

### After Pulling Changes

```fish
git pull

# If Project.swift or Package.swift changed:
tuist install; and tuist generate

# Or use alias:
tig
```

### When Things Break

```fish
# Full clean and regenerate
tuist clean
rm -rf .tuist
rm -rf Tuist/Dependencies
rm -rf *.xcodeproj
rm -rf *.xcworkspace

tuist install
tuist generate

# Or use the function:
tuist-refresh
```

## CI/CD with mise

Update your GitHub Actions workflow to use mise:

```yaml
- name: Install mise
  run: |
    curl https://mise.run | sh
    echo "$HOME/.local/bin" >> $GITHUB_PATH

- name: Install Tuist via mise
  run: |
    mise install
    
- name: Verify Tuist
  run: tuist --version

- name: Create Secrets.xcconfig
  run: |
    cat > Secrets.xcconfig << EOF
    DEV_TEAM_SECRET = ${{ secrets.DEVELOPMENT_TEAM }}
    POSTHOG_API_KEY = ${{ secrets.POSTHOG_API_KEY }}
    REVENUE_CAT_KEY = ${{ secrets.REVENUE_CAT_KEY }}
    EOF

- name: Generate Project
  run: |
    tuist install
    tuist generate
```

## Comparison: mise vs Direct Installation

| Aspect | Direct Install | mise |
|--------|---------------|------|
| **Version Management** | Manual | Automatic per-project |
| **Team Consistency** | Hope everyone has same version | .mise.toml ensures consistency |
| **Updates** | Manual reinstall | `mise upgrade tuist` |
| **Multiple Projects** | Same version everywhere | Different versions per project |
| **CI/CD** | Install script each time | `mise install` |

## Fish-Specific Commands

### Check if Tuist is Available

```fish
if command -v tuist &> /dev/null
    echo "Tuist is installed"
    tuist --version
else
    echo "Tuist not found, run: mise install"
end
```

### Conditional Generation

```fish
# Only generate if Project.swift is newer than .xcodeproj
if test Project.swift -nt "Listen anonymously.xcodeproj"
    echo "Project.swift changed, regenerating..."
    tuist generate
else
    echo "Project is up to date"
end
```

### Loop Through Targets

```fish
# Example: Find all test targets
for target in (grep -o '".*Tests"' Project.swift)
    echo "Found test target: $target"
end
```

## Troubleshooting (Fish)

### mise not found after installation

```fish
# Add to ~/.config/fish/config.fish
fish_add_path ~/.local/bin
fish_add_path ~/.local/share/mise/shims

# Reload
source ~/.config/fish/config.fish
```

### Tuist not in PATH

```fish
# Check mise is activated
type -q mise
# If not found, add to config.fish:
mise activate fish | source

# Or check shims:
ls ~/.local/share/mise/shims/tuist
```

### mise install fails

```fish
# Update mise
mise self-update

# Try installing specific version
mise install tuist@4.31.0

# Check logs
mise doctor
```

## Fish Completions

mise provides Fish completions automatically:

```fish
# Test completions
mise <TAB>
tuist <TAB>
```

If completions don't work:

```fish
# Regenerate completions
mise completion fish > ~/.config/fish/completions/mise.fish
source ~/.config/fish/config.fish
```

## .mise.toml Location

mise looks for `.mise.toml` in:

1. **Current directory** (project-specific) ✅ Recommended
2. **Parent directories** (workspace-level)
3. **~/.config/mise/config.toml** (global)

For this project, `.mise.toml` is at the root:

```fish
listen-anonymously/
├── .mise.toml              # Project-specific Tuist version
├── Project.swift
├── Package.swift
└── ...
```

## Best Practices

### 1. Pin Tuist Version (Recommended)

```toml
# .mise.toml
[tools]
tuist = "4.31.0"  # Pin to specific version for team consistency
```

### 2. Use mise for Other Tools

```toml
# .mise.toml
[tools]
tuist = "4.31.0"
ruby = "3.2.0"      # For fastlane
node = "20.0.0"     # For scripts
```

### 3. Commit .mise.toml

```fish
git add .mise.toml
git commit -m "Add mise configuration for Tuist version management"
```

### 4. Team Onboarding

New team members just run:

```fish
mise install    # Installs exact versions from .mise.toml
./setup-tuist.fish
```

## Quick Reference

### Essential Commands

```fish
# mise
mise install              # Install all tools from .mise.toml
mise upgrade tuist        # Update Tuist to latest
mise list                 # Show installed tools
mise doctor              # Check mise health

# Tuist (via mise)
tuist generate           # Generate Xcode project
tuist install            # Install SPM dependencies
tuist clean              # Clean cache

# Combined
mise install; and tuist install; and tuist generate
```

### File Locations

```fish
# mise configuration
~/.config/mise/config.toml           # Global config
~/.local/share/mise/installs/tuist/  # Tuist installations
~/.local/share/mise/shims/tuist      # Tuist shim

# Project files
.mise.toml                           # Project-specific versions
Secrets.xcconfig                     # Local secrets (git-ignored)
```

## Migration from Bash Script

If you previously used the Bash script:

```fish
# Old way (Bash)
./setup-tuist.sh

# New way (Fish)
./setup-tuist.fish
```

Both scripts do the same thing, but the Fish version:
- ✅ Uses Fish syntax and idioms
- ✅ Integrates with mise
- ✅ Provides better error messages in Fish
- ✅ Uses Fish-style colors and formatting

## Summary

| Task | Command |
|------|---------|
| **First time setup** | `./setup-tuist.fish` |
| **Install Tuist** | `mise install` |
| **Update Tuist** | `mise upgrade tuist` |
| **Generate project** | `tuist generate` |
| **Clean + regenerate** | `tuist clean && tuist generate` |
| **Open workspace** | `open "Listen anonymously.xcworkspace"` |

## Additional Resources

- [mise Documentation](https://mise.jdx.dev/)
- [mise GitHub](https://github.com/jdx/mise)
- [Fish Shell Documentation](https://fishshell.com/docs/current/)
- [Tuist Documentation](https://docs.tuist.io)

---

**Note**: The Fish script (`setup-tuist.fish`) and Bash script (`setup-tuist.sh`) are functionally equivalent. Use whichever matches your shell preference. Both work with mise.
