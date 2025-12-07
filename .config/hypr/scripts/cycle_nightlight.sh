#!/usr/bin/env bash
set -euo pipefail

STATE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/hypr/nightlight_state"
mkdir -p "$(dirname "$STATE_FILE")"

current_state=$(cat "$STATE_FILE" 2>/dev/null || echo "0")

pkill hyprsunset 2>/dev/null || true
sleep 0.2

case "$current_state" in
    0)
        hyprsunset -t 4000 >/dev/null 2>&1 &
        echo "1" > "$STATE_FILE"
        notify-send "Night Light" "Medium (4000K)" -t 2000
        ;;
    1)
        hyprsunset -t 3000 >/dev/null 2>&1 &
        echo "2" > "$STATE_FILE"
        notify-send "Night Light" "Warm (3000K)" -t 2000
        ;;
    2)
        hyprsunset -t 6500 >/dev/null 2>&1 &
        echo "0" > "$STATE_FILE"
        notify-send "Night Light" "Off (6500K)" -t 2000
        ;;
esac
