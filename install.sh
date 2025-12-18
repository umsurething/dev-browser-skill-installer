#!/bin/bash
#
# dev-browser skill installer for Claude Code
# Installs Sawyer Hood's dev-browser as a lightweight on-demand skill
# Original project: https://github.com/SawyerHood/dev-browser
#

set -e

echo "=== dev-browser skill installer ==="
echo ""

# Check for bun
if ! command -v bun &> /dev/null; then
    echo "Installing bun..."
    curl -fsSL https://bun.sh/install | bash
    export PATH="$HOME/.bun/bin:$PATH"
    echo "Bun installed. You may need to restart your terminal or run: source ~/.zshrc"
fi

echo "Bun version: $(bun --version)"

# Create skills directory
mkdir -p ~/.claude/skills

# Clone the repo to temp location
echo ""
echo "Cloning dev-browser..."
TEMP_DIR=$(mktemp -d)
git clone --depth 1 https://github.com/SawyerHood/dev-browser "$TEMP_DIR/dev-browser"

# Move just the skill portion to the correct location
if [ -d ~/.claude/skills/dev-browser ]; then
    echo "Removing existing dev-browser skill..."
    rm -rf ~/.claude/skills/dev-browser
fi

mv "$TEMP_DIR/dev-browser/skills/dev-browser" ~/.claude/skills/dev-browser
rm -rf "$TEMP_DIR"

# Install dependencies
echo ""
echo "Installing dependencies..."
cd ~/.claude/skills/dev-browser
bun install

# Install Playwright Chromium
echo ""
echo "Installing Chromium browser..."
bunx playwright install chromium

echo ""
echo "=== Installation complete ==="
echo ""
echo "Next steps:"
echo "  1. Restart Claude Code for the skill to be detected"
echo "  2. When you need browser automation, start the server:"
echo "     cd ~/.claude/skills/dev-browser && ./server.sh &"
echo ""
echo "The skill triggers on phrases like:"
echo "  - 'go to [url]'"
echo "  - 'click on', 'fill out the form'"
echo "  - 'take a screenshot'"
echo "  - 'test the website'"
echo ""
echo "Original project: https://github.com/SawyerHood/dev-browser"
