#!/usr/bin/env bash
set -euo pipefail

APP_NAME="$1"
APP_CLASS="$2"
LAUNCH_CMD="$3"
APP_TITLE="${4:-}"  # Optional title pattern

SPECIAL_WS="special:${APP_NAME}"

# Check if window exists in the special workspace
if [ -n "$APP_TITLE" ]; then
    window_exists=$(hyprctl clients -j | jq -r ".[] | select(.workspace.name == \"$SPECIAL_WS\" and .class == \"$APP_CLASS\" and (.title | test(\"$APP_TITLE\"))) | .address" | head -n1)
else
    window_exists=$(hyprctl clients -j | jq -r ".[] | select(.workspace.name == \"$SPECIAL_WS\" and .class == \"$APP_CLASS\") | .address" | head -n1)
fi

if [ -z "$window_exists" ]; then
    # App not running, launch it
    eval "$LAUNCH_CMD" &

    # Wait for window to appear (max 10 seconds)
    for i in {1..100}; do
        sleep 0.1
        if [ -n "$APP_TITLE" ]; then
            window_exists=$(hyprctl clients -j | jq -r ".[] | select(.class == \"$APP_CLASS\" and (.title | test(\"$APP_TITLE\"))) | .address" | head -n1)
        else
            window_exists=$(hyprctl clients -j | jq -r ".[] | select(.class == \"$APP_CLASS\") | .address" | head -n1)
        fi
        if [ -n "$window_exists" ]; then
            # Check if window is already in the special workspace (window rules)
            current_ws=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$window_exists\") | .workspace.name")
            if [ "$current_ws" = "$SPECIAL_WS" ]; then
                # Already in special workspace, focus it to show
                hyprctl dispatch focuswindow "address:$window_exists"
            else
                # Move to special workspace and show it
                hyprctl dispatch movetoworkspace "$SPECIAL_WS,address:$window_exists"
            fi
            exit 0
        fi
    done
    exit 1
else
    # App exists, just toggle visibility
    hyprctl dispatch togglespecialworkspace "$APP_NAME"
fi
