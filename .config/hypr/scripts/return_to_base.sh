#!/usr/bin/env bash
set -euo pipefail

# Get current workspace ID
current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')

# Hide all visible stack workspaces
for i in 1 2 3; do
    if hyprctl -j monitors | jq -e '.[] | select(.specialWorkspace.name == "special:stack'$i'")' >/dev/null 2>&1; then
        echo "Hiding stack workspace $i"
        hyprctl dispatch togglespecialworkspace "stack$i" >/dev/null
    fi
done

echo "Returned to base workspace $current_workspace"