#!/usr/bin/env bash
set -euo pipefail

if [ -z "$1" ]; then
    echo "Usage: $0 <offset>"
    exit 1
fi

offset="$1"
current=$(hyprctl activeworkspace -j | jq -r '.id')
target=$((current + offset))

if [ "$target" -lt 1 ]; then
    target=1
fi

exec ~/.config/hypr/scripts/workspace_switch.sh "$target"
