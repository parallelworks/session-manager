# Session Manager - Full Documentation

Persistent remote terminal session management via SSH and tmux.

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [SSH Configuration](#ssh-configuration)
- [Command Reference](#command-reference)
- [Configuration](#configuration)
- [Use Cases](#use-cases)
- [Architecture](#architecture)
- [tmux Quick Reference](#tmux-quick-reference)
- [Troubleshooting](#troubleshooting)
- [Advanced Usage](#advanced-usage)

## Overview

Session Manager connects to remote machines via SSH and runs commands inside persistent tmux sessions. This means:

- **Sessions persist** even if your SSH connection drops
- **Reconnect seamlessly** to the same session later
- **Manage multiple hosts** from a single interface
- **Run any command** - shells, editors, monitoring tools, AI agents

## Installation

```bash
git clone https://github.com/yourusername/session-manager.git
cd session-manager
./install.sh
```

The installer:
- Copies `session-manager` to `~/.local/bin/`
- Creates `sm` symlink for quick access
- Adds `~/.local/bin` to your PATH

After installation, use `sm` command.

## SSH Configuration

Session Manager reads hosts from `~/.ssh/config`.

### Example SSH Config

```
Host dev
    Hostname 192.168.1.100
    User myuser
    IdentityFile ~/.ssh/id_rsa

Host production
    Hostname prod.example.com
    User deploy
    Port 2222

Host gpu
    Hostname gpu.mycompany.com
    User researcher
```

Verify hosts are detected:
```bash
sm hosts
```

## Command Reference

### Core Commands

| Command | Description |
|---------|-------------|
| `sm <host>` | Connect to host (creates or attaches) |
| `sm <host> <name>` | Named session on host |
| `sm status` | Dashboard showing all sessions |
| `sm hosts` | List available SSH hosts |

### Session Management

| Command | Description |
|---------|-------------|
| `sm list` | List local tmux sessions |
| `sm attach <name>` | Attach to local session |
| `sm kill <name>` | Kill local session |
| `sm info <name>` | Show session details |
| `sm restart <name>` | Restart a session |

### Remote Management

| Command | Description |
|---------|-------------|
| `sm sessions <host>` | List tmux sessions on remote host |
| `sm kill-remote <host> <session>` | Kill a session on remote host |
| `sm test <host>` | Test SSH connection |

### Options

| Option | Short | Description |
|--------|-------|-------------|
| `--detach` | `-d` | Create session without attaching |
| `--dir <path>` | `-D` | Set remote working directory |
| `--cmd <command>` | | Override the command to run |
| `--version` | `-V` | Show version |
| `--help` | `-h` | Show help |

## Configuration

### Config File

Location: `~/.config/session-manager/config`

```bash
# Command to run on remote (default: bash)
export SESSION_MANAGER_REMOTE_CMD="bash"

# Default remote working directory
export SESSION_MANAGER_REMOTE_DIR="~"

# SSH config file location
export SESSION_MANAGER_SSH_CONFIG="$HOME/.ssh/config"
```

### Example Configurations

**Default shell:**
```bash
export SESSION_MANAGER_REMOTE_CMD="bash"
```

**AgentDeck (AI coding agent):**
```bash
export SESSION_MANAGER_REMOTE_CMD="agent-deck"
```

**System monitoring:**
```bash
export SESSION_MANAGER_REMOTE_CMD="htop"
```

**Editor:**
```bash
export SESSION_MANAGER_REMOTE_CMD="nvim"
```

### Per-Session Override

```bash
sm dev --cmd htop          # Run htop on dev
sm dev --cmd agent-deck    # Run agent-deck on dev
sm dev --cmd "tail -f /var/log/syslog"  # Watch logs
```

## Use Cases

### Remote Development with AgentDeck

```bash
# Configure AgentDeck as default
echo 'export SESSION_MANAGER_REMOTE_CMD="agent-deck"' >> ~/.config/session-manager/config

# Connect to dev server
sm dev

# Work with AgentDeck...
# Detach: Ctrl+B, D

# Later, reconnect to same session
sm dev
```

### Multiple Projects on Same Host

```bash
sm dev frontend -D ~/projects/frontend
sm dev backend -D ~/projects/backend
sm dev infra -D ~/infrastructure

# List all sessions
sm list
```

### System Monitoring

```bash
sm server1 --cmd htop
sm server2 --cmd "watch df -h"
sm logs --cmd "tail -f /var/log/app.log"
```

### Quick Shell Access

```bash
# Default bash session
sm dev

# Named session for specific task
sm dev debugging
```

## Architecture

### How It Works

When you run `sm dev`:

```
┌─────────────────────────────────────────────────────────────┐
│ Local Machine                                               │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ Local tmux session: "remote-dev"                     │   │
│  │   └── SSH connection                                 │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                            │
                            │ SSH
                            ▼
┌─────────────────────────────────────────────────────────────┐
│ Remote Server (dev)                                         │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ Remote tmux session: "dev"                           │   │
│  │   └── your command (bash, agent-deck, etc.)          │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### Persistence

The dual-tmux architecture provides resilience:

| Event | What Happens |
|-------|--------------|
| SSH drops | Remote tmux keeps your command running |
| Close terminal | Local session persists, reconnect with `sm dev` |
| Reboot local machine | Remote session still running |

### Session Naming

| Command | Local Session | Remote Session |
|---------|---------------|----------------|
| `sm dev` | `remote-dev` | `dev` |
| `sm dev project` | `remote-dev-project` | `dev-project` |

## tmux Quick Reference

| Action | Keybinding |
|--------|------------|
| **Detach** | `Ctrl+B`, then `D` |
| Scroll | `Ctrl+B`, then `[`, arrows, `Q` to exit |
| New window | `Ctrl+B`, then `C` |
| Switch window | `Ctrl+B`, then `0-9` |
| List windows | `Ctrl+B`, then `W` |
| Command mode | `Ctrl+B`, then `:` |

## Troubleshooting

### "Unknown host: xyz"

Add the host to `~/.ssh/config`:
```
Host xyz
    Hostname xyz.example.com
    User myuser
```

### "command not found" on remote

The command isn't in PATH on the remote. Either:
1. Install it on the remote
2. Use full path: `sm dev --cmd "/home/user/.local/bin/agent-deck"`
3. Ensure it's in a standard location

### Can't detach (Ctrl+B D not working)

1. Make sure you're pressing `Ctrl+B`, release, then `D`
2. Try `Ctrl+B` then `:` to open tmux command mode - if it works, type `detach`
3. Check your local tmux config for prefix changes

### Session won't reconnect

```bash
# Check local sessions
sm list

# Check remote sessions
sm sessions dev

# Kill stale local session and reconnect
sm kill remote-dev
sm dev
```

## Advanced Usage

### Batch Operations

```bash
# Start sessions on multiple hosts
for host in dev staging prod; do
    sm $host --detach
done

# Check status
sm status
```

### Direct tmux Commands

```bash
# Local
tmux list-sessions
tmux attach -t remote-dev
tmux kill-session -t remote-dev

# Remote
ssh dev "tmux list-sessions"
ssh dev "tmux kill-session -t dev"
```

### Custom Working Directories

```bash
sm dev -D ~/projects/myapp
sm dev frontend -D ~/projects/frontend
```

## Version History

### v2.1.0
- Added `sm status` dashboard
- Added `sm sessions <host>` for remote session listing
- Added `sm kill-remote` for remote cleanup
- Smart connect with session picker
- Generalized command configuration

### v2.0.0
- Complete rewrite for remote SSH focus
- SSH config parsing
- Dual tmux architecture
- Configurable remote command

### v1.x
- Local session management only
