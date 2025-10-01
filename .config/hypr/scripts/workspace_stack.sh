#!/usr/bin/env bash
set -euo pipefail

stack_key="$2"  # A, S, or D

# Get current workspace
workspace=$(hyprctl activeworkspace -j | jq -r '.id')
stack_name="ws${workspace}_${stack_key}"

hyprctl dispatch togglespecialworkspace "$stack_name"
