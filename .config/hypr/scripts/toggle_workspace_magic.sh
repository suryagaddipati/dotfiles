#!/usr/bin/env bash
set -euo pipefail

# Get current workspace ID
current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')

# Create magic workspace name for current workspace
magic_name="magic${current_workspace}"

state_dir="${XDG_CACHE_HOME:-$HOME/.cache}/hypr/magic-workspaces"
mkdir -p "$state_dir"
state_file="$state_dir/workspace_${current_workspace}"

# Determine whether the magic workspace is currently visible
is_visible=false
if hyprctl -j monitors | jq -e '.[] | select(.specialWorkspace.name == "special:'"$magic_name"'")' >/dev/null 2>&1; then
    is_visible=true
fi

# Toggle the magic workspace for current workspace
hyprctl dispatch togglespecialworkspace "$magic_name"

# Persist the desired visibility state so the manager can restore it later
if [ "$is_visible" = true ]; then
    printf '%s\n' "0" > "$state_file"
else
    printf '%s\n' "1" > "$state_file"
fi
