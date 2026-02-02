# Session Manager

Launch and manage persistent terminal sessions on remote machines via SSH.

## Install

```bash
git clone https://github.com/yourusername/session-manager.git
cd session-manager
./install.sh
```

## Quick Start

```bash
# See your available SSH hosts
sm hosts

# Connect to a host
sm dev

# Detach: Ctrl+B, then D

# Reconnect later (same session)
sm dev
```

## Common Commands

| Command | Description |
|---------|-------------|
| `sm <host>` | Connect to host |
| `sm <host> <name>` | Named session on host |
| `sm status` | Dashboard of all sessions |
| `sm hosts` | List SSH hosts |
| `sm sessions <host>` | List sessions on remote host |
| `sm list` | List local sessions |
| `sm kill-remote <host> <sess>` | Kill remote session |

## Configuration

Configure what command runs on remote hosts:

```bash
# Edit ~/.config/session-manager/config

# Default shell
export SESSION_MANAGER_REMOTE_CMD="bash"

# Or run a specific tool:
export SESSION_MANAGER_REMOTE_CMD="agent-deck"   # AgentDeck
export SESSION_MANAGER_REMOTE_CMD="htop"         # System monitor
export SESSION_MANAGER_REMOTE_CMD="nvim"         # Neovim
```

Or specify per-session:
```bash
sm dev --cmd htop
sm dev --cmd agent-deck
```

## How It Works

```
Local Machine                     Remote Server
┌──────────────┐    SSH    ┌──────────────────────┐
│ Local tmux   │ ───────── │ Remote tmux          │
│ session      │           │  └── your command    │
└──────────────┘           └──────────────────────┘
```

Sessions run in tmux on the remote, so they **persist even if SSH disconnects**.

## Requirements

- `tmux` installed locally and on remote hosts
- SSH hosts configured in `~/.ssh/config`

## Documentation

See [session-manager.README.md](session-manager.README.md) for full documentation.

## License

MIT
