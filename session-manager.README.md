# session-manager

Persistent terminal sessions using tmux. Run multiple background instances of different apps with separate contexts and easily reattach to them.

## Quick Start

```bash
# List available apps
session-manager list-apps

# Create a new claude session (named "myproject")
session-manager claude myproject
# Creates session: claude-myproject

# Create a bash session
session-manager bash scratch
# Creates session: bash-scratch

# List all running sessions
session-manager list

# Attach to an existing session
session-manager attach claude-myproject
```

## Available Apps

| App | Description |
|-----|-------------|
| `claude` | Claude Code CLI (configure with `session-manager config`) |
| `bash` | Interactive bash shell |
| `opencode` | OpenCode editor TUI |

## Command Line Interface

```bash
session-manager <app> [name]           # Create or attach to <app> session
session-manager <app> [name] [options] # Create session with options
session-manager attach <name>          # Attach to specific session
session-manager list                   # List all sessions
session-manager list-apps              # List available apps
session-manager kill <name>            # Kill a session
session-manager info <name>            # Show session details
session-manager restart <name>         # Restart a session
session-manager config                 # Configure environment variables
session-manager --version              # Show version
session-manager                        # Interactive menu
session-manager help                   # Show help
```

### Command Options

| Option | Short | Description |
|--------|-------|-------------|
| `--detach` | `-d` | Create session without automatically attaching |
| `--dir <path>` | `-D <path>` | Specify working directory for the session |
| `--version` | `-V` | Show version information |

## Session Naming

Sessions follow the pattern: `<app>-<name>`

Examples:
- `session-manager claude myproject` → creates session `claude-myproject`
- `session-manager bash scratch` → creates session `bash-scratch`
- `session-manager claude` → creates session `claude-HHMM` (auto-generated name)

If a session with that name already exists, it will attach instead of creating a new one.

## Adding New Apps

To add a new app, edit the `session-manager` script and add a `register_app` call:

```bash
register_app "appname" "command to run" \
    "Description of the app" \
    "ENV_VAR=\${SESSION_MANAGER_ENV_VAR} DEBUG=true"
```

**Important**: Use `\$` to escape environment variables so they expand at runtime, not when the script is loaded.

### Example: Adding OpenCode

Edit `~/.local/bin/session-manager` and add in the "ADD YOUR CUSTOM APPS" section:

 ```bash
register_app "opencode" "opencode" \
    "OpenCode editor TUI" \
    ""
```

Now you can use it:
```bash
session-manager opencode myserver
# Creates session: opencode-myserver
```

### Example: Adding an app with environment variables

```bash
register_app "myapp" "myapp --daemon" \
    "My custom application" \
    "API_KEY=\${SESSION_MANAGER_API_KEY} DEBUG=\${SESSION_MANAGER_DEBUG} NODE_ENV=production"
```

Then configure the values:
```bash
# Either via interactive config
session-manager config

# Or set in ~/.config/session-manager/config
export SESSION_MANAGER_API_KEY="your-api-key"
export SESSION_MANAGER_DEBUG="true"
```

## Interactive Mode

Run `session-manager` without arguments for an interactive menu:

```
╔════════════════════════════════════════╗
║   Session Manager                     ║
╚════════════════════════════════════════╝

 Available apps:
   claude  Claude Code CLI
   bash    Interactive bash shell
  opencode  OpenCode editor TUI

Running sessions: 2

Options:
  [1] Create new session
  [2] Attach to session
  [3] List sessions
  [4] Kill session
  [5] List apps
  [6] Configure
  [q] Quit
```

## tmux Quick Reference

| Action | Keybinding |
|--------|------------|
| Detach | `Ctrl+B` then `d` |
| Scroll | `Ctrl+B` then `[`, arrows, `q` to quit |
| New window | `Ctrl+B` then `c` |
| Switch window | `Ctrl+B` then `0-9` |
| List windows | `Ctrl+B` then `w` |
| Rename session | `Ctrl+B` then `$` |

## Advanced Usage

### Session Information

Use the `info` command to get detailed information about a session:

```bash
session-manager info claude-myproject
```

This shows:
- Session status (attached/detached)
- Working directory
- Running windows

### Session Management

Create multiple sessions for different projects or tasks:

```bash
# Create sessions for different work contexts
session-manager claude frontend --dir ~/projects/frontend
session-manager claude backend --dir ~/projects/backend
session-manager bash logs --dir ~/logs

# List and manage them
session-manager list

# Restart a session when needed
session-manager restart claude-frontend
```

### Detached Sessions

Use `--detach` to create sessions that run in the background:

```bash
# Start a long-running task in background
session-manager bash build --dir ~/myproject --detach

# Check on it later
session-manager list
session-manager attach bash-build
```

## Direct tmux Commands

```bash
# List all sessions
tmux ls

# Attach to session
tmux attach -t <name>

# Kill session
tmux kill-session -t <name>

# Show session info
tmux list-sessions -F "#{session_name}: #{?session_attached,(attached),(detached)} - #{window_name}"
```

## Examples

```bash
# Start a claude session for frontend work
session-manager claude frontend

# Start a bash session for quick commands
session-manager bash shell1

# Create a detached session (runs in background)
session-manager claude myproject --detach

# Create a session in a specific directory
session-manager bash dev --dir ~/projects/myapp

# Later, reattach to the frontend session
session-manager attach claude-frontend

# Show session details
session-manager info claude-frontend

# Restart a session (kill and recreate)
session-manager restart claude-frontend

# Or just use the app+name shortcut (auto-adds prefix)
session-manager claude frontend
```

## Backward Compatibility

The old `claude-session` command still works through a compatibility wrapper:

```bash
# Old commands still work
claude-session new myproject
claude-session attach myproject
claude-session list
claude-session kill myproject
```

## How It Works

Each session runs the app's command in a persistent tmux session with:
- The app's configured environment variables
- The current working directory (or specified directory)
- Full terminal context preserved on detach

Detaching (`Ctrl+B` then `d`) keeps the session running in the background.

## Configuration

### Setting Environment Variables

Run the interactive configuration:
```bash
session-manager config
```

This creates `~/.config/session-manager/config` with your settings.

Or set environment variables in your shell config (~/.bashrc, ~/.zshrc):
```bash
export SESSION_MANAGER_ANTHROPIC_AUTH_TOKEN="your-token-here"
export SESSION_MANAGER_ANTHROPIC_BASE_URL="https://api.anthropic.com"
```

### Config File Location

- Linux/macOS: `~/.config/session-manager/config`
- Config file is sourced automatically when session-manager runs

### Claude Code CLI Variables

- `SESSION_MANAGER_ANTHROPIC_AUTH_TOKEN` - Your Anthropic API token (required)
- `SESSION_MANAGER_ANTHROPIC_BASE_URL` - API base URL (default: https://api.anthropic.com)
- `SESSION_MANAGER_API_TIMEOUT_MS` - API timeout (default: 3000000)
- `SESSION_MANAGER_HAIKU_MODEL` - Haiku model (default: claude-3-5-haiku)
- `SESSION_MANAGER_SONNET_MODEL` - Sonnet model (default: claude-3-5-sonnet)
- `SESSION_MANAGER_OPUS_MODEL` - Opus model (default: claude-3-opus)

### Adding/Modifying Apps

Edit `~/.local/bin/session-manager` to add new apps or modify existing ones (see "Adding New Apps" above).
