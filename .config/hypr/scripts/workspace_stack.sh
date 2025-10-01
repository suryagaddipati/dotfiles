#!/usr/bin/env bash
set -euo pipefail

stack_key="$2"  # A, S, or D

# Get current workspace
workspace=$(hyprctl activeworkspace -j | jq -r '.id')
stack_name="ws${workspace}_${stack_key}"

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/hypr"
CACHE_FILE="$CACHE_DIR/special_workspaces.json"

mkdir -p "$CACHE_DIR"

# Initialize JSON file if it doesn't exist
if [ ! -f "$CACHE_FILE" ]; then
    echo '{}' > "$CACHE_FILE"
fi

# Check if the special workspace is currently visible
is_visible=$(hyprctl workspaces -j | jq -r ".[] | select(.name == \"special:$stack_name\") | .id" | wc -l)

if [ "$is_visible" -eq 0 ]; then
    # Special workspace is hidden, add it to JSON (we're showing it)
    jq --arg ws "$workspace" --arg name "$stack_name" '.[$ws] = $name' "$CACHE_FILE" > "$CACHE_FILE.tmp"
    mv "$CACHE_FILE.tmp" "$CACHE_FILE"
else
    # Special workspace is visible, remove it from JSON (we're hiding it)
    jq --arg ws "$workspace" 'del(.[$ws])' "$CACHE_FILE" > "$CACHE_FILE.tmp"
    mv "$CACHE_FILE.tmp" "$CACHE_FILE"
fi

hyprctl dispatch togglespecialworkspace "$stack_name"
