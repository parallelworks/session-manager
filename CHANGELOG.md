# Changelog

All notable changes to session-manager will be documented in this file.

## [Unreleased]

### Added
- `--detach` / `-d` flag to create sessions without automatically attaching
- `--dir` / `-D` flag to specify working directory when creating sessions from CLI
- `info` command to show detailed session information (status, working directory, windows)
- `restart` command to kill and recreate a session with the same configuration
- `--version` / `-V` flag to display version information
- Interactive menu options for session info and restart functionality
- Version constant (1.2.0) for tracking releases

### Changed
- Updated OpenCode app to run as TUI instead of server mode
- Improved color handling in session-manager using $'' syntax for better compatibility
- Changed print functions to use `printf` instead of `echo -e` for improved portability
- Enhanced session creation with working directory validation
- Expanded interactive menu to include 8 options instead of 6

### Added
- Automatic PATH configuration during installation - adds `~/.local/bin` to PATH if not present
- `sm` alias created during installation for quick access to session-manager
- Enhanced installation output with clearer messaging

## [1.1.0] - 2025-01-08

### Added
- Initial release with core session management functionality
- Interactive TUI menu for session management
- CLI mode for scripting and quick operations
- Support for multiple apps (bash, claude, opencode)
- Environment variable configuration
- Session creation, attachment, listing, and killing
- Comprehensive documentation

### Features
- Persistent tmux-based sessions
- App registry system for easy app management
- Automatic session naming with patterns
- Working directory support
- Interactive and command-line interfaces
