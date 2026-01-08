# session-manager

A tmux-based session manager for running persistent terminal sessions with different applications.

## Quick Start

```bash
# Clone and install
git clone https://github.com/yourusername/session-manager.git
cd session-manager
./install.sh

# Start managing sessions
session-manager
```

## Features

- **Persistent Sessions**: Run apps in background tmux sessions
- **Easy Reconnection**: Detach and reattach to any session
- **App Registry**: Register and manage multiple apps
- **Interactive TUI**: Interactive menu for easy navigation
- **CLI Mode**: Full command-line interface for scripting
- **Environment Variables**: Set app-specific environment variables

## Usage

```bash
# Interactive mode
session-manager

# Configure environment variables
session-manager config

# Quick start a session
session-manager claude myproject
session-manager bash scratch

# List sessions
session-manager list

# Attach to session
session-manager attach claude-myproject

# Kill session
session-manager kill claude-myproject
```

## Configuration

Configure app environment variables:

```bash
# Interactive configuration
session-manager config

# Or manually create ~/.config/session-manager/config
export SESSION_MANAGER_ANTHROPIC_AUTH_TOKEN="your-token-here"
export SESSION_MANAGER_ANTHROPIC_BASE_URL="https://api.anthropic.com"
```

Environment variables can also be set in your shell config (~/.bashrc, ~/.zshrc):

```bash
export SESSION_MANAGER_ANTHROPIC_AUTH_TOKEN="your-token-here"
```

## Adding New Apps

Edit the `session-manager` script and add a `register_app` call:

```bash
register_app "appname" "command to run" \
    "Description of the app" \
    "ENV_VAR=\${SESSION_MANAGER_ENV_VAR} DEBUG=true"
```

Use `\$` to escape environment variables so they expand at runtime, not registration time.

## Requirements

- `tmux` - Install with `sudo apt install tmux` (Debian/Ubuntu) or `brew install tmux` (macOS)

## License

MIT
