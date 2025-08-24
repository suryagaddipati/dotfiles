#!/bin/bash

ACTIVITY_LOG="$HOME/.claude/activity.log"
ACTION="${1:-add}"

if [ -n "$TMUX" ]; then
    SESSION=$(tmux display-message -p '#{session_name}' 2>/dev/null)
    WINDOW=$(tmux display-message -p '#{window_index}' 2>/dev/null)
    PANE=$(tmux display-message -p '#{pane_index}' 2>/dev/null)
    PANE_PATH=$(tmux display-message -p '#{pane_current_path}' 2>/dev/null)
    
    CURRENT_LINE="$SESSION:$WINDOW:$PANE:$PANE_PATH"
    
    if [ "$ACTION" = "remove" ] || [ "$ACTION" = "stop" ]; then
        # Remove all lines matching current tmux context
        grep -v "^$CURRENT_LINE$" "$ACTIVITY_LOG" > "$ACTIVITY_LOG.tmp" 2>/dev/null && mv "$ACTIVITY_LOG.tmp" "$ACTIVITY_LOG"
    else
        # Add new line
        echo "$CURRENT_LINE" >> "$ACTIVITY_LOG"
    fi
    
    # Update tmux status with notification count
    COUNT=$(wc -l < "$ACTIVITY_LOG" 2>/dev/null || echo "0")
    tmux set-environment -g CLAUDE_NOTIFICATIONS "$COUNT" 2>/dev/null
fi

