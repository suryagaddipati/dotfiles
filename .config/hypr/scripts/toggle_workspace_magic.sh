#!/usr/bin/env bash
set -euo pipefail

# Get current workspace ID
current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')

# Create magic workspace name for current workspace
magic_name="magic${current_workspace}"

# Toggle the magic workspace for current workspace
hyprctl dispatch togglespecialworkspace "$magic_name"