#!/usr/bin/env bash
set -euo pipefail

# Check which stack workspaces are currently visible
get_active_stacks() {
    local active=""
    local workspace=$(hyprctl activeworkspace -j | jq -r '.id')

    # Check each workspace-specific stack
    if hyprctl -j monitors | jq -e '.[] | select(.specialWorkspace.name == "special:ws'$workspace'_A")' >/dev/null 2>&1; then
        active="${active}<span color='#e06c75'>A</span>"
    fi
    if hyprctl -j monitors | jq -e '.[] | select(.specialWorkspace.name == "special:ws'$workspace'_S")' >/dev/null 2>&1; then
        active="${active}<span color='#98c379'>S</span>"
    fi
    if hyprctl -j monitors | jq -e '.[] | select(.specialWorkspace.name == "special:ws'$workspace'_D")' >/dev/null 2>&1; then
        active="${active}<span color='#61afef'>D</span>"
    fi

    if [ -z "$active" ]; then
        exit 1  # Don't show indicator when no stacks are active
    else
        echo "$active"
    fi
}

# Output format for waybar
case "${1:-}" in
    "json")
        active=$(get_active_stacks)
        echo "{\"text\":\"$active\",\"tooltip\":\"Active stack workspaces: $active\",\"class\":\"stack-indicator\"}"
        ;;
    *)
        get_active_stacks
        ;;
esac