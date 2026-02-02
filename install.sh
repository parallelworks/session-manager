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

echo -e "${BLUE}Installing session-manager v2.1.0...${NC}"
echo "Remote AgentDeck session manager via SSH"
echo ""

# Create directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Creating $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"
fi

# Copy script
echo "Copying $SCRIPT_NAME to $INSTALL_DIR"
cp "$SCRIPT_NAME" "$INSTALL_DIR/"
chmod +x "$SCRIPT_PATH"

# Create symlink for 'sm' command
echo "Creating 'sm' symlink"
ln -sf "$SCRIPT_PATH" "$INSTALL_DIR/sm"

# Copy README
if [ -f "session-manager.README.md" ]; then
    echo "Copying README to $INSTALL_DIR"
    cp "session-manager.README.md" "$INSTALL_DIR/"
fi

# Detect shell config file
SHELL_RC=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
elif [ -f "$HOME/.bash_profile" ]; then
    SHELL_RC="$HOME/.bash_profile"
fi

# Add to PATH if not already there
if [ -n "$SHELL_RC" ]; then
    if ! grep -q "$INSTALL_DIR" "$SHELL_RC" 2>/dev/null; then
        echo ""
        echo "Adding $INSTALL_DIR to PATH in $SHELL_RC"
        echo "" >> "$SHELL_RC"
        echo "# session-manager" >> "$SHELL_RC"
        echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$SHELL_RC"
    fi
fi

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "To use immediately, run:"
echo "  export PATH=\"\$PATH:$INSTALL_DIR\""
echo ""
echo "Or restart your terminal."
echo ""
echo -e "${YELLOW}Quick start:${NC}"
echo "  sm hosts                    # List available SSH hosts"
echo "  sm <host>                   # Connect to a host"
echo "  sm status                   # View all sessions"
echo "  sm --help                   # Full help"
echo ""
echo -e "${YELLOW}Your SSH hosts are read from ~/.ssh/config${NC}"
