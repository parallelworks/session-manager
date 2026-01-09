#!/bin/bash
# session-manager install script

set -e

INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME="session-manager"
SCRIPT_PATH="$INSTALL_DIR/$SCRIPT_NAME"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/session-manager"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Installing session-manager...${NC}"

# Create directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Creating $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"
fi

# Copy script
echo "Copying $SCRIPT_NAME to $INSTALL_DIR"
cp "$SCRIPT_NAME" "$INSTALL_DIR/"
chmod +x "$SCRIPT_PATH"

# Copy README
if [ -f "session-manager.README.md" ]; then
    echo "Copying README to $INSTALL_DIR"
    cp "session-manager.README.md" "$INSTALL_DIR/"
fi

# Add to PATH if not already there
if ! grep -q "$INSTALL_DIR" "$HOME/.bashrc" 2>/dev/null; then
    echo ""
    echo "Adding $INSTALL_DIR to PATH in ~/.bashrc"
    echo "" >> "$HOME/.bashrc"
    echo "# session-manager" >> "$HOME/.bashrc"
    echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$HOME/.bashrc"
fi

# Add alias if not already there
if ! grep -q "^alias sm=" "$HOME/.bashrc" 2>/dev/null; then
    echo "Adding 'sm' alias to ~/.bashrc"
    echo "alias sm='session-manager'" >> "$HOME/.bashrc"
fi

echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "Sourcing ~/.bashrc..."
source "$HOME/.bashrc"
echo ""
echo "Next steps:"
echo "  1. Configure your environment variables:"
echo "     session-manager config"
echo ""
echo -e "${YELLOW}Note: Your config file will be created at $CONFIG_DIR/config${NC}"
echo ""
echo "You can now use 'session-manager' or the alias 'sm' to get started."
