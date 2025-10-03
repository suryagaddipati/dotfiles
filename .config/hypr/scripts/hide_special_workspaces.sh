#!/usr/bin/env bash
set -euo pipefail

# Get current workspace
workspace=$(hyprctl activeworkspace -j | jq -r '.id')

# Hide all workspace-specific stacks for current workspace
for stack_key in A S D; do
    stack_name="ws${workspace}_${stack_key}"
    # Check if this special workspace is visible
    if hyprctl monitors -j | jq -e ".[] | select(.specialWorkspace.name == \"special:$stack_name\")" >/dev/null 2>&1; then
        hyprctl dispatch togglespecialworkspace "$stack_name"
    fi
done

# Hide all singleton workspaces
for singleton in whatsapp chatgpt youtube messages; do
    if hyprctl monitors -j | jq -e ".[] | select(.specialWorkspace.name == \"special:$singleton\")" >/dev/null 2>&1; then
        hyprctl dispatch togglespecialworkspace "$singleton"
    fi
done

# Clear from cache
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/hypr"
CACHE_FILE="$CACHE_DIR/special_workspaces.json"

if [ -f "$CACHE_FILE" ]; then
    jq --arg ws "$workspace" 'del(.[$ws])' "$CACHE_FILE" > "$CACHE_FILE.tmp"
    mv "$CACHE_FILE.tmp" "$CACHE_FILE"
fi
