#!/usr/bin/env bash
set -euo pipefail

action="$1"  # toggle or move
stack_key="$2"  # A, S, or D

# Get current workspace
workspace=$(hyprctl activeworkspace -j | jq -r '.id')
stack_name="ws${workspace}_${stack_key}"

case "$action" in
    "toggle")
        hyprctl dispatch togglespecialworkspace "$stack_name"
        ;;
    "move")
        hyprctl dispatch movetoworkspace "special:$stack_name"
        ;;
esac