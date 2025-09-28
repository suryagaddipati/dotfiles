#!/usr/bin/env bash
set -euo pipefail

# Get current workspace ID
current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')

# Create stack workspace name for current workspace
stack_name="stack${current_workspace}"
special_workspace="special:${stack_name}"

# Check if the stack workspace is currently visible
visible=false
if hyprctl -j workspaces | jq -r '.[] | select(.name == "'"$special_workspace"'") | .visible' | grep -q true; then
    visible=true
fi

# Ensure stack workspace is shown (creates it if missing), move window, then restore visibility
if [ "$visible" != true ]; then 
    hyprctl dispatch togglespecialworkspace "$stack_name" >/dev/null
fi

hyprctl dispatch movetoworkspace "$special_workspace" >/dev/null

if [ "$visible" != true ]; then 
    hyprctl dispatch togglespecialworkspace "$stack_name" >/dev/null
fi