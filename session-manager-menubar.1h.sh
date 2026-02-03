#!/bin/bash

# <xbar.title>Session Manager</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>mattshax</xbar.author>
# <xbar.author.github>mattshax</xbar.author.github>
# <xbar.desc>Quick launcher for Session Manager</xbar.desc>
# <xbar.dependencies>bash,tmux</xbar.dependencies>

# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>

SM_PATH="$HOME/.local/bin/sm"
SSH_CONFIG="$HOME/.ssh/config"

# Menu bar icon
echo "⚡"
echo "---"

# Count active sessions
session_count=$(tmux list-sessions 2>/dev/null | wc -l | tr -d ' ')
if [ "$session_count" -gt 0 ]; then
    echo "Active Sessions: $session_count | color=green"
    echo "---"

    # List active sessions
    tmux list-sessions -F "#{session_name}" 2>/dev/null | while read -r sess; do
        case "$sess" in
            remote-*)
                echo "📡 $sess | bash='$SM_PATH' param1=attach param2='$sess' terminal=true"
                ;;
            bash-*|claude-*|opencode-*)
                echo "💻 $sess | bash='$SM_PATH' param1=attach param2='$sess' terminal=true"
                ;;
            *)
                echo "● $sess | bash='$SM_PATH' param1=attach param2='$sess' terminal=true"
                ;;
        esac
    done
    echo "---"
fi

# Launch Session Manager
echo "🚀 Open Session Manager | bash='$SM_PATH' terminal=true"
echo "---"

# Quick connect to SSH hosts
echo "Remote Hosts"
if [ -f "$SSH_CONFIG" ]; then
    grep -i "^Host " "$SSH_CONFIG" | grep -v '\*' | sed 's/^Host //' | head -10 | while read -r host; do
        echo "--$host | bash='$SM_PATH' param1='$host' terminal=true"
    done
else
    echo "--No SSH config found"
fi
echo "---"

# Local apps submenu
echo "Local Apps"
echo "--bash | bash='$SM_PATH' param1=local param2=bash terminal=true"
echo "--claude | bash='$SM_PATH' param1=local param2=claude terminal=true"
echo "--opencode | bash='$SM_PATH' param1=local param2=opencode terminal=true"
echo "---"

# Quick actions
echo "Status Dashboard | bash='$SM_PATH' param1=status terminal=true"
echo "List All Sessions | bash='$SM_PATH' param1=list terminal=true"
echo "---"
echo "Refresh | refresh=true"
