#!/usr/bin/env bash
set -euo pipefail

# Get current workspace ID
current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')

# Create stack workspace name for current workspace
stack_name="stack${current_workspace}"

state_dir="${XDG_CACHE_HOME:-$HOME/.cache}/hypr/stack-workspaces"
mkdir -p "$state_dir"
state_file="$state_dir/workspace_${current_workspace}"

# Determine whether the stack workspace is currently visible
is_visible=false
if hyprctl -j monitors | jq -e '.[] | select(.specialWorkspace.name == "special:'"$stack_name"'")' >/dev/null 2>&1; then
    is_visible=true
fi

# Toggle the stack workspace for current workspace
hyprctl dispatch togglespecialworkspace "$stack_name"

# Persist the desired visibility state so the manager can restore it later
if [ "$is_visible" = true ]; then
    printf '%s\n' "0" > "$state_file"
else
    printf '%s\n' "1" > "$state_file"
fi
