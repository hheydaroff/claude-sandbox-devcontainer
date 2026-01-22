#!/bin/bash
# Install Claude Code Sandbox DevContainer template
#
# Usage: curl -fsSL https://raw.githubusercontent.com/hheydaroff/claude-sandbox-devcontainer/main/install.sh | bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Claude Code Sandbox DevContainer Installer${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

TEMPLATE_DIR="$HOME/.config/devcontainer-templates/claude-sandbox"
BIN_DIR="$HOME/.local/bin"
REPO_URL="https://raw.githubusercontent.com/hheydaroff/claude-sandbox-devcontainer/main"

# Create directories
echo -e "${GREEN}Creating directories...${NC}"
mkdir -p "$TEMPLATE_DIR"
mkdir -p "$BIN_DIR"

# Download template files
echo -e "${GREEN}Downloading template files...${NC}"
curl -fsSL "$REPO_URL/.devcontainer/devcontainer.json" -o "$TEMPLATE_DIR/devcontainer.json"
curl -fsSL "$REPO_URL/.devcontainer/Dockerfile" -o "$TEMPLATE_DIR/Dockerfile"
curl -fsSL "$REPO_URL/.devcontainer/claude-settings.json" -o "$TEMPLATE_DIR/claude-settings.json"

# Download CLI tool
echo -e "${GREEN}Installing CLI tool...${NC}"
curl -fsSL "$REPO_URL/claude-sandbox" -o "$BIN_DIR/claude-sandbox"
chmod +x "$BIN_DIR/claude-sandbox"

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  echo ""
  echo -e "${YELLOW}Note: $BIN_DIR is not in your PATH.${NC}"
  echo -e "${YELLOW}Add this to your shell config (~/.zshrc or ~/.bashrc):${NC}"
  echo ""
  echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
  echo ""
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  ✅ Installation complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "Usage:"
echo -e "  ${BLUE}cd /path/to/your/project${NC}"
echo -e "  ${BLUE}claude-sandbox${NC}"
echo ""
echo -e "Then open in VS Code and:"
echo -e "  Cmd+Shift+P → 'Dev Containers: Reopen in Container'"
echo ""
