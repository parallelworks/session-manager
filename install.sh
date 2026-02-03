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
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}Installing session-manager v2.2.0...${NC}"
echo "Local and remote session manager"
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

# =============================================================================
# macOS App Installation
# =============================================================================

create_macos_app() {
    local APP_PATH="/Applications/SessionManager.app"

    echo ""
    echo -e "${CYAN}Creating SessionManager.app...${NC}"

    # Create app bundle structure
    mkdir -p "$APP_PATH/Contents/MacOS"
    mkdir -p "$APP_PATH/Contents/Resources"

    # Create launcher script
    cat > "$APP_PATH/Contents/MacOS/SessionManager" << 'LAUNCHER'
#!/bin/bash
osascript << 'EOF'
tell application "Terminal"
    -- Create new window and run session-manager
    do script "$HOME/.local/bin/sm"
    activate
    delay 0.3

    -- Enter full screen mode using menu
    tell application "System Events"
        tell process "Terminal"
            click menu item "Enter Full Screen" of menu "View" of menu bar 1
        end tell
    end tell
end tell
EOF
LAUNCHER
    chmod +x "$APP_PATH/Contents/MacOS/SessionManager"

    # Create Info.plist
    cat > "$APP_PATH/Contents/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>SessionManager</string>
    <key>CFBundleIdentifier</key>
    <string>com.sessionmanager.app</string>
    <key>CFBundleName</key>
    <string>Session Manager</string>
    <key>CFBundleDisplayName</key>
    <string>Session Manager</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleVersion</key>
    <string>2.2.0</string>
    <key>CFBundleShortVersionString</key>
    <string>2.2.0</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.13</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
PLIST

    # Copy icon if available in repo
    if [ -f "icons/AppIcon.icns" ]; then
        cp "icons/AppIcon.icns" "$APP_PATH/Contents/Resources/"
    fi

    echo -e "${GREEN}Created SessionManager.app${NC}"
    echo "  Opens Terminal in full-screen mode"
    echo "  Launch from Spotlight or Dock"
}

# =============================================================================
# SwiftBar/xbar Plugin Installation
# =============================================================================

install_menubar_plugin() {
    local PLUGIN_NAME="session-manager-menubar.1h.sh"
    local PLUGIN_DIR="$HOME/swiftbar-plugins"

    if [ ! -f "$PLUGIN_NAME" ]; then
        echo -e "${YELLOW}Menu bar plugin not found in repo${NC}"
        return 1
    fi

    echo ""
    echo -e "${CYAN}Installing SwiftBar plugin...${NC}"

    # Create plugins directory
    mkdir -p "$PLUGIN_DIR"
    cp "$PLUGIN_NAME" "$PLUGIN_DIR/"
    chmod +x "$PLUGIN_DIR/$PLUGIN_NAME"

    # Configure SwiftBar to use this directory
    defaults write com.ameba.SwiftBar PluginDirectory -string "$PLUGIN_DIR"

    echo -e "${GREEN}Installed SwiftBar plugin to ~/swiftbar-plugins${NC}"

    # Check if SwiftBar is installed
    if ! command -v swiftbar &>/dev/null && [ ! -d "/Applications/SwiftBar.app" ]; then
        echo ""
        echo -e "${YELLOW}SwiftBar not installed. Install with:${NC}"
        echo "  brew install swiftbar"
    else
        # Restart SwiftBar to pick up the plugin
        pkill -x SwiftBar 2>/dev/null
        sleep 1
        open -a SwiftBar 2>/dev/null
        echo "SwiftBar restarted - look for ⚡ in menu bar"
    fi
}

# =============================================================================
# Platform-specific installation
# =============================================================================

if [ "$(uname)" = "Darwin" ]; then
    echo ""
    read -p "Install macOS app (SessionManager.app)? [Y/n]: " install_app
    case "$install_app" in
        [Nn]*) ;;
        *) create_macos_app ;;
    esac

    if [ -f "session-manager-menubar.1h.sh" ]; then
        read -p "Install menu bar plugin (requires SwiftBar/xbar)? [y/N]: " install_menubar
        case "$install_menubar" in
            [Yy]*) install_menubar_plugin ;;
        esac
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
echo "  sm local bash               # Start local bash session"
echo "  sm local claude             # Start Claude Code session"
echo "  sm <host>                   # Connect to remote host"
echo "  sm status                   # View all sessions"
echo "  sm --help                   # Full help"
echo ""
echo -e "${YELLOW}Local apps: bash, claude, opencode${NC}"
echo -e "${YELLOW}SSH hosts are read from ~/.ssh/config${NC}"
