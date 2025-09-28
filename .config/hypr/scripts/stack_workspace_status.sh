#!/usr/bin/env bash
set -euo pipefail

# Check which stack workspaces are currently visible
get_active_stacks() {
    local active=""

    # Check each stack workspace
    for i in 1 2 3; do
        if hyprctl -j monitors | jq -e '.[] | select(.specialWorkspace.name == "special:stack'$i'")' >/dev/null 2>&1; then
            case $i in
                1) active="${active}A" ;;
                2) active="${active}S" ;;
                3) active="${active}D" ;;
            esac
        fi
    done

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