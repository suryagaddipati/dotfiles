#!/usr/bin/env bash
set -euo pipefail

# Check if any monitor has a visible special workspace (singleton)
special_workspace=$(hyprctl monitors -j | jq -r '.[] | select(.specialWorkspace.id != 0) | .specialWorkspace.name' | head -n1)

if [[ -n "$special_workspace" ]]; then
    case "$special_workspace" in
        "special:whatsapp") echo "W" ;;
        "special:chatgpt") echo "C" ;;
        "special:youtube") echo "Y" ;;
        "special:messages") echo "Alt+G" ;;
        "special:btop") echo "T" ;;
        "special:obsidian") echo "O" ;;
        *) echo "${special_workspace#special:}" ;;
    esac
    exit 0
fi

# Get current workspace info
workspace_info=$(hyprctl activeworkspace -j)
workspace=$(echo "$workspace_info" | jq -r '.id')
workspace_name=$(echo "$workspace_info" | jq -r '.name')

# Get active stacks for current workspace
active_stacks=""
for stack_key in A S D; do
    if hyprctl -j monitors | jq -e '.[] | select(.specialWorkspace.name == "special:ws'$workspace'_'$stack_key'")' >/dev/null 2>&1; then
        case $stack_key in
            A) active_stacks="${active_stacks}<span color='#e06c75'>A</span>" ;;
            S) active_stacks="${active_stacks}<span color='#98c379'>S</span>" ;;
            D) active_stacks="${active_stacks}<span color='#61afef'>D</span>" ;;
        esac
    fi
done

# Format output: workspace number + stacks (if any)
if [[ -n "$active_stacks" ]]; then
    echo "$workspace $active_stacks"
else
    echo "$workspace"
fi