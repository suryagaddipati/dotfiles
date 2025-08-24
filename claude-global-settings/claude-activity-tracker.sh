#!/bin/bash

ACTIVITY_LOG="$HOME/.claude/activity.log"
ACTION="${1:-notification}"

# Ensure directory and file exist
mkdir -p "$(dirname "$ACTIVITY_LOG")"
touch "$ACTIVITY_LOG"

if [ -n "$TMUX" ]; then
    SESSION=$(tmux display-message -p '#{session_name}' 2>/dev/null)
    WINDOW=$(tmux display-message -p '#{window_index}' 2>/dev/null)

    CURRENT_LINE="$SESSION:$WINDOW"

    if [ "$ACTION" = "notification" ]; then
        # Check if this session:window already exists
        if ! grep -q "^$CURRENT_LINE$" "$ACTIVITY_LOG" 2>/dev/null; then
            # Add new line only if not already present
            echo "$CURRENT_LINE" >> "$ACTIVITY_LOG"
        fi
    else
        # For all other actions (add, remove, stop, start), remove the entry
        if [ -f "$ACTIVITY_LOG" ]; then
            grep -v "^$CURRENT_LINE$" "$ACTIVITY_LOG" > "$ACTIVITY_LOG.tmp" 2>/dev/null || true
            mv "$ACTIVITY_LOG.tmp" "$ACTIVITY_LOG" 2>/dev/null || true
            # Ensure file exists even if now empty
            touch "$ACTIVITY_LOG"
        fi
    fi

    # Update tmux status with notification count
    COUNT=$(wc -l < "$ACTIVITY_LOG" 2>/dev/null || echo "0")
    tmux set-environment -g CLAUDE_NOTIFICATIONS "$COUNT" 2>/dev/null
fi

