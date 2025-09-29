#!/usr/bin/env bash
set -euo pipefail

STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/hypr/stack-workspaces"
mkdir -p "$STATE_DIR"

save_stacks() {
    local workspace="$1"
    local visible=""

    for stack in 1 2 3; do
        if hyprctl -j monitors | jq -e '.[] | select(.specialWorkspace.name == "special:stack'$stack'")' >/dev/null 2>&1; then
            visible="${visible}${visible:+,}$stack"
        fi
    done

    echo "$visible" > "$STATE_DIR/workspace_$workspace"
}

restore_stacks() {
    local workspace="$1"

    # Hide all stacks
    for stack in 1 2 3; do
        if hyprctl -j monitors | jq -e '.[] | select(.specialWorkspace.name == "special:stack'$stack'")' >/dev/null 2>&1; then
            hyprctl dispatch togglespecialworkspace "stack$stack" >/dev/null 2>&1 || true
        fi
    done

    # Show saved stacks
    if [[ -f "$STATE_DIR/workspace_$workspace" ]]; then
        local stacks
        stacks=$(cat "$STATE_DIR/workspace_$workspace")
        if [[ -n "$stacks" ]]; then
            IFS=',' read -ra STACK_ARRAY <<< "$stacks"
            for stack in "${STACK_ARRAY[@]}"; do
                hyprctl dispatch togglespecialworkspace "stack$stack" >/dev/null 2>&1 || true
            done
        fi
    fi
}

# Monitor workspace changes
previous=$(hyprctl activeworkspace -j | jq -r '.id')

while true; do
    current=$(hyprctl activeworkspace -j | jq -r '.id' 2>/dev/null) || {
        sleep 1
        continue
    }

    if [[ "$current" != "$previous" ]]; then
        save_stacks "$previous"
        restore_stacks "$current"
        previous="$current"
    fi

    sleep 0.2
done