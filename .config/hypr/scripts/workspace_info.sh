#!/usr/bin/env bash
set -euo pipefail

# Get current workspace number
workspace=$(hyprctl activeworkspace -j | jq -r '.id')

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