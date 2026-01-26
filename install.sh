#!/bin/bash
# Install claude-sandbox from local clone
#
# Usage:
#   git clone https://github.com/hheydaroff/claude-sandbox-devcontainer.git
#   cd claude-sandbox-devcontainer
#   ./install.sh

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get the directory where this script lives
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$HOME/.local/bin"

echo -e "${BLUE}Installing claude-sandbox...${NC}"
echo ""

# Check that we're in the right directory
if [ ! -f "$SCRIPT_DIR/claude-sandbox" ]; then
  echo -e "${YELLOW}Error: claude-sandbox not found in $SCRIPT_DIR${NC}"
  echo "Make sure you're running this from the cloned repository."
  exit 1
fi

if [ ! -f "$SCRIPT_DIR/.devcontainer/Dockerfile" ]; then
  echo -e "${YELLOW}Error: .devcontainer/Dockerfile not found${NC}"
  echo "Make sure you have the complete repository."
  exit 1
fi

# Create bin directory
mkdir -p "$BIN_DIR"

# Create symlink (force overwrite if exists)
ln -sf "$SCRIPT_DIR/claude-sandbox" "$BIN_DIR/claude-sandbox"
echo -e "${GREEN}Created:${NC} $BIN_DIR/claude-sandbox -> $SCRIPT_DIR/claude-sandbox"

# Check PATH
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  echo ""
  echo -e "${YELLOW}Note:${NC} $BIN_DIR is not in your PATH."
  echo "Add this to your ~/.zshrc or ~/.bashrc:"
  echo ""
  echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
  echo ""
fi

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "Usage:"
echo "  cd /path/to/any/project"
echo "  claude-sandbox              # Initialize devcontainer"
echo "  claude-sandbox -o           # Initialize and open in VS Code"
echo "  claude-sandbox --help       # Show all options"
echo ""
echo "First run will prompt for authentication method."
echo ""
echo "To update:"
echo "  cd $SCRIPT_DIR && git pull"
