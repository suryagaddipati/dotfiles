#!/usr/bin/env bash
set -euo pipefail

# Get current workspace
workspace=$(hyprctl activeworkspace -j | jq -r '.id')

# Hide current workspace's stacks
for stack_key in A S D; do
    stack_name="ws${workspace}_${stack_key}"
    if hyprctl -j monitors | jq -e '.[] | select(.specialWorkspace.name == "special:'$stack_name'")' >/dev/null 2>&1; then
        hyprctl dispatch togglespecialworkspace "$stack_name" >/dev/null 2>&1 || true
    fi
done