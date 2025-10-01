#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "Usage: $0 <workspace_number>"
    exit 1
fi

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/hypr"
CACHE_FILE="$CACHE_DIR/special_workspaces.json"

hyprctl dispatch workspace "$1"

# Check if cache file exists
if [ -f "$CACHE_FILE" ]; then
    # Get the special workspace name for this workspace number
    special_name=$(jq -r --arg ws "$1" '.[$ws] // empty' "$CACHE_FILE")

    # Hide all visible special workspaces first
    hyprctl monitors -j | jq -r '.[].specialWorkspace.name // empty' | grep "^special:" | sed 's/special://' | while read -r ws; do
        hyprctl dispatch togglespecialworkspace "$ws" >/dev/null 2>&1
    done

    # If there's a special workspace for this workspace, show it
    if [ -n "$special_name" ]; then
        hyprctl dispatch togglespecialworkspace "$special_name"
    fi
fi
