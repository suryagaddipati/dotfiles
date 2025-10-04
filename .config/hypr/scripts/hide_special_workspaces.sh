#!/usr/bin/env bash
set -euo pipefail

# Get current workspace
workspace=$(hyprctl activeworkspace -j | jq -r '.id')

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/hypr"
CACHE_FILE="$CACHE_DIR/special_workspaces.json"

# Hide all workspace-specific stacks for current workspace and clear from cache
for stack_key in A S D; do
    stack_name="ws${workspace}_${stack_key}"
    # Check if this special workspace is visible
    if hyprctl monitors -j | jq -e ".[] | select(.specialWorkspace.name == \"special:$stack_name\")" >/dev/null 2>&1; then
        hyprctl dispatch togglespecialworkspace "$stack_name"
        # Clear this workspace from cache since we hid its stack
        if [ -f "$CACHE_FILE" ]; then
            jq --arg ws "$workspace" 'del(.[$ws])' "$CACHE_FILE" > "$CACHE_FILE.tmp"
            mv "$CACHE_FILE.tmp" "$CACHE_FILE"
        fi
    fi
done

# Hide all singleton workspaces
for singleton in whatsapp chatgpt youtube messages; do
    if hyprctl monitors -j | jq -e ".[] | select(.specialWorkspace.name == \"special:$singleton\")" >/dev/null 2>&1; then
        hyprctl dispatch togglespecialworkspace "$singleton"
    fi
done
