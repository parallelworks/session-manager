# Changelog

All notable changes to session-manager will be documented in this file.

## [2.2.0] - 2025-02-02

### Added
- **Local session support restored** - Run bash, opencode, claude locally
- `sm local <app> [name]` command for creating local app sessions
- `sm local-apps` command to list available local apps
- `sm rename <old> <new>` command to rename running sessions
- SessionManager.app for macOS (opens Terminal in full-screen mode)
- SwiftBar/xbar menu bar plugin (`session-manager-menubar.1h.sh`)
- App icons included in `icons/` directory
- Interactive menu option for renaming sessions

### Changed
- Install script now prompts to create SessionManager.app on macOS
- Install script configures SwiftBar plugin to `~/swiftbar-plugins`
- Interactive menu reorganized with local and remote session options
- Status dashboard shows local app sessions with app name

## [2.1.0] - 2025-02-01

### Added
- **Remote SSH session management** - Connect to hosts via SSH with persistent tmux
- Dual-tmux architecture (local + remote) for network resilience
- SSH config parser - auto-discovers hosts from `~/.ssh/config`
- `sm <host> [name]` for quick remote connections
- `sm hosts` to list available SSH hosts
- `sm sessions <host>` to list remote tmux sessions
- `sm kill-remote <host> <session>` to kill remote sessions
- `sm status` dashboard showing local and remote sessions
- `sm test <host>` to test SSH connections
- `--cmd <command>` flag to override default remote command
- Smart connect with session picker for multiple sessions per host

### Changed
- Complete architectural rewrite for remote-first workflow
- Session naming pattern: `remote-<host>[-name]`
- Configuration focused on SSH and remote commands

## [1.2.0] - 2025-01-09

### Added
- `--detach` / `-d` flag to create sessions without automatically attaching
- `--dir` / `-D` flag to specify working directory when creating sessions
- `info` command to show detailed session information
- `restart` command to kill and recreate a session
- `--version` / `-V` flag to display version information

### Changed
- Updated OpenCode app to run as TUI instead of server mode
- Improved color handling using $'' syntax for better compatibility

## [1.1.0] - 2025-01-08

### Added
- Initial release with core session management functionality
- Interactive TUI menu for session management
- CLI mode for scripting and quick operations
- Support for multiple apps (bash, claude, opencode)
- Environment variable configuration
- Session creation, attachment, listing, and killing
