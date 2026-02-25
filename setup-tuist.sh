#!/bin/bash

# Tuist Setup Script
# This script helps with initial Tuist setup and project generation

set -e  # Exit on error

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Listen anonymously - Tuist Setup${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if Tuist is installed
if ! command -v tuist &> /dev/null; then
    echo -e "${YELLOW}Tuist is not installed.${NC}"
    echo -e "${YELLOW}Installing Tuist...${NC}"
    curl -Ls https://install.tuist.io | bash
    
    # Add to PATH for current session
    export PATH="$HOME/.tuist/bin:$PATH"
    
    echo -e "${GREEN}✓ Tuist installed successfully${NC}"
    echo ""
else
    echo -e "${GREEN}✓ Tuist is already installed${NC}"
    tuist version
    echo ""
fi

# Check if Secrets.xcconfig exists
if [ ! -f "Secrets.xcconfig" ]; then
    echo -e "${YELLOW}⚠ Secrets.xcconfig not found${NC}"
    echo -e "${YELLOW}Creating from example...${NC}"
    
    if [ -f "Secrets.xcconfig.example" ]; then
        cp Secrets.xcconfig.example Secrets.xcconfig
        echo -e "${YELLOW}⚠ Please edit Secrets.xcconfig with your credentials:${NC}"
        echo -e "${YELLOW}  - DEV_TEAM_SECRET (Apple Developer Team ID)${NC}"
        echo -e "${YELLOW}  - POSTHOG_API_KEY${NC}"
        echo -e "${YELLOW}  - REVENUE_CAT_KEY${NC}"
        echo ""
        echo -e "${RED}Press Enter after updating Secrets.xcconfig to continue...${NC}"
        read -r
    else
        echo -e "${RED}✗ Secrets.xcconfig.example not found${NC}"
        echo -e "${RED}Please create Secrets.xcconfig manually with the following format:${NC}"
        echo ""
        echo "DEV_TEAM_SECRET = YOUR_TEAM_ID"
        echo "POSTHOG_API_KEY = your_api_key"
        echo "REVENUE_CAT_KEY = your_api_key"
        echo ""
        exit 1
    fi
else
    echo -e "${GREEN}✓ Secrets.xcconfig exists${NC}"
    echo ""
fi

# Verify Secrets.xcconfig has required keys
echo -e "${BLUE}Verifying Secrets.xcconfig...${NC}"
if grep -q "YOUR_TEAM_ID_HERE" Secrets.xcconfig || grep -q "your_.*_key_here" Secrets.xcconfig; then
    echo -e "${RED}✗ Secrets.xcconfig contains placeholder values${NC}"
    echo -e "${RED}Please update it with your actual credentials before continuing${NC}"
    exit 1
fi

if grep -q "DEV_TEAM_SECRET" Secrets.xcconfig && \
   grep -q "POSTHOG_API_KEY" Secrets.xcconfig && \
   grep -q "REVENUE_CAT_KEY" Secrets.xcconfig; then
    echo -e "${GREEN}✓ Secrets.xcconfig is properly configured${NC}"
    echo ""
else
    echo -e "${RED}✗ Secrets.xcconfig is missing required keys${NC}"
    exit 1
fi

# Clean previous builds
echo -e "${BLUE}Cleaning previous builds...${NC}"
tuist clean
echo -e "${GREEN}✓ Cleaned${NC}"
echo ""

# Install SPM dependencies
echo -e "${BLUE}Installing SPM dependencies...${NC}"
tuist install
echo -e "${GREEN}✓ Dependencies installed${NC}"
echo ""

# Generate Xcode project
echo -e "${BLUE}Generating Xcode project...${NC}"
tuist generate
echo -e "${GREEN}✓ Project generated successfully${NC}"
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}To open the project:${NC}"
echo -e "  ${YELLOW}open \"Listen anonymously.xcworkspace\"${NC}"
echo ""
echo -e "${BLUE}To regenerate after changes:${NC}"
echo -e "  ${YELLOW}tuist generate${NC}"
echo ""
echo -e "${BLUE}For more information:${NC}"
echo -e "  ${YELLOW}cat TUIST_SETUP.md${NC}"
echo ""
