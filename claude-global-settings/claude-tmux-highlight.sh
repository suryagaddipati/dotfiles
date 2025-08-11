#!/bin/bash

STATE="${1:-waiting}"

# Get the current working directory where Claude is running
CLAUDE_DIR="${CLAUDE_WORKING_DIR:-$(pwd)}"

# Find window with matching working directory
CLAUDE_WINDOW=$(tmux list-windows -F "#{window_index} #{pane_current_path}" 2>/dev/null | grep "$CLAUDE_DIR" | head -1 | cut -d' ' -f1)

# If not found by exact match, try parent directory
if [ -z "$CLAUDE_WINDOW" ]; then
    PARENT_DIR=$(dirname "$CLAUDE_DIR")
    CLAUDE_WINDOW=$(tmux list-windows -F "#{window_index} #{pane_current_path}" 2>/dev/null | grep "$PARENT_DIR" | head -1 | cut -d' ' -f1)
fi

# If still not found, use the current active window
if [ -z "$CLAUDE_WINDOW" ]; then
    CLAUDE_WINDOW=$(tmux display-message -p '#{window_index}' 2>/dev/null)
fi

if [ -n "$CLAUDE_WINDOW" ]; then
    if [ "$STATE" = "waiting" ]; then
        # Highlight in red when waiting for input
        tmux set-window-option -t ":$CLAUDE_WINDOW" window-status-style "bg=red,fg=white,bold" 2>/dev/null
        tmux set-window-option -t ":$CLAUDE_WINDOW" window-status-current-style "bg=red,fg=white,bold" 2>/dev/null
    else
        # Reset to default when processing
        tmux set-window-option -t ":$CLAUDE_WINDOW" -u window-status-style 2>/dev/null
        tmux set-window-option -t ":$CLAUDE_WINDOW" -u window-status-current-style 2>/dev/null
    fi
fi