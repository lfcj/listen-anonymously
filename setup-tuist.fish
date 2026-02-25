#!/usr/bin/env fish

# Tuist Setup Script for Fish Shell
# This script helps with initial Tuist setup and project generation

set YELLOW (set_color yellow)
set GREEN (set_color green)
set RED (set_color red)
set BLUE (set_color blue)
set NC (set_color normal)

echo "$BLUE========================================$NC"
echo "$BLUE  Listen anonymously - Tuist Setup$NC"
echo "$BLUE========================================$NC"
echo ""

# Check if mise is installed
if not command -v mise &> /dev/null
    echo "$RED✗ mise is not installed.$NC"
    echo "$YELLOW Installing mise...$NC"
    echo ""
    echo "Please install mise first:"
    echo "  curl https://mise.run | sh"
    echo ""
    echo "Or via Homebrew:"
    echo "  brew install mise"
    echo ""
    echo "Then add to your config.fish:"
    echo '  mise activate fish | source'
    echo ""
    exit 1
end

echo "$GREEN✓ mise is installed$NC"
mise --version
echo ""

# Check if .mise.toml or .tool-versions exists
if not test -f .mise.toml; and not test -f .tool-versions
    echo "$YELLOW⚠ No .mise.toml or .tool-versions found$NC"
    echo "$YELLOW Creating .mise.toml...$NC"
    echo ""
    
    echo '[tools]' > .mise.toml
    echo 'tuist = "latest"' >> .mise.toml
    
    echo "$GREEN✓ Created .mise.toml$NC"
    echo ""
end

# Install tools via mise
echo "$BLUE Installing Tuist via mise...$NC"
mise install
echo "$GREEN✓ Tuist installed via mise$NC"
echo ""

# Verify Tuist is available
if not command -v tuist &> /dev/null
    echo "$RED✗ Tuist not found in PATH$NC"
    echo "$YELLOW Make sure mise is properly configured in your Fish shell$NC"
    echo "Add to your ~/.config/fish/config.fish:"
    echo '  mise activate fish | source'
    exit 1
end

echo "$GREEN✓ Tuist is available$NC"
tuist --version
echo ""

# Check if Secrets.xcconfig exists
if not test -f Secrets.xcconfig
    echo "$YELLOW⚠ Secrets.xcconfig not found$NC"
    echo "$YELLOW Creating from example...$NC"
    
    if test -f Secrets.xcconfig.example
        cp Secrets.xcconfig.example Secrets.xcconfig
        echo "$YELLOW⚠ Please edit Secrets.xcconfig with your credentials:$NC"
        echo "$YELLOW  - DEV_TEAM_SECRET (Apple Developer Team ID)$NC"
        echo "$YELLOW  - POSTHOG_API_KEY$NC"
        echo "$YELLOW  - REVENUE_CAT_KEY$NC"
        echo ""
        echo "$RED Press Enter after updating Secrets.xcconfig to continue...$NC"
        read
    else
        echo "$RED✗ Secrets.xcconfig.example not found$NC"
        echo "$RED Please create Secrets.xcconfig manually with the following format:$NC"
        echo ""
        echo "DEV_TEAM_SECRET = YOUR_TEAM_ID"
        echo "POSTHOG_API_KEY = your_api_key"
        echo "REVENUE_CAT_KEY = your_api_key"
        echo ""
        exit 1
    end
else
    echo "$GREEN✓ Secrets.xcconfig exists$NC"
    echo ""
end

# Verify Secrets.xcconfig has required keys
echo "$BLUE Verifying Secrets.xcconfig...$NC"
if grep -q "YOUR_TEAM_ID_HERE" Secrets.xcconfig; or grep -q "your_.*_key_here" Secrets.xcconfig
    echo "$RED✗ Secrets.xcconfig contains placeholder values$NC"
    echo "$RED Please update it with your actual credentials before continuing$NC"
    exit 1
end

if grep -q "DEV_TEAM_SECRET" Secrets.xcconfig; and \
   grep -q "POSTHOG_API_KEY" Secrets.xcconfig; and \
   grep -q "REVENUE_CAT_KEY" Secrets.xcconfig
    echo "$GREEN✓ Secrets.xcconfig is properly configured$NC"
    echo ""
else
    echo "$RED✗ Secrets.xcconfig is missing required keys$NC"
    exit 1
end

# Clean previous builds
echo "$BLUE Cleaning previous builds...$NC"
tuist clean
echo "$GREEN✓ Cleaned$NC"
echo ""

# Install SPM dependencies
echo "$BLUE Installing SPM dependencies...$NC"
tuist install
echo "$GREEN✓ Dependencies installed$NC"
echo ""

# Generate Xcode project
echo "$BLUE Generating Xcode project...$NC"
tuist generate
echo "$GREEN✓ Project generated successfully$NC"
echo ""

echo "$GREEN========================================$NC"
echo "$GREEN  Setup Complete!$NC"
echo "$GREEN========================================$NC"
echo ""
echo "$BLUE To open the project:$NC"
echo "  $YELLOW open \"Listen anonymously.xcworkspace\"$NC"
echo ""
echo "$BLUE To regenerate after changes:$NC"
echo "  $YELLOW tuist generate$NC"
echo ""
echo "$BLUE For more information:$NC"
echo "  $YELLOW cat TUIST_SETUP.md$NC"
echo ""
