#!/usr/bin/env bash
set -euo pipefail

APP_NAME="$1"
APP_CLASS="$2"
LAUNCH_CMD="$3"

SPECIAL_WS="special:${APP_NAME}"

# Check if window with this class exists
window_exists=$(hyprctl clients -j | jq -r ".[] | select(.class == \"$APP_CLASS\") | .address" | head -n1)

if [ -z "$window_exists" ]; then
    # App not running, launch it
    eval "$LAUNCH_CMD" &

    # Wait for window to appear (max 5 seconds)
    for i in {1..50}; do
        sleep 0.1
        window_exists=$(hyprctl clients -j | jq -r ".[] | select(.class == \"$APP_CLASS\") | .address" | head -n1)
        if [ -n "$window_exists" ]; then
            # Move window to special workspace
            hyprctl dispatch movetoworkspacesilent "$SPECIAL_WS,address:$window_exists"
            # Show the special workspace
            hyprctl dispatch togglespecialworkspace "$APP_NAME"
            exit 0
        fi
    done
    exit 1
else
    # App exists, just toggle visibility
    hyprctl dispatch togglespecialworkspace "$APP_NAME"
fi
