#!/usr/bin/env bash
set -euo pipefail

STATE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/hypr/nightlight_state"
mkdir -p "$(dirname "$STATE_FILE")"

current_state=$(cat "$STATE_FILE" 2>/dev/null || echo "0")

pkill hyprsunset 2>/dev/null || true
sleep 0.2

set_brightness() {
    brightnessctl set "$1" 2>/dev/null || true
    ddcutil setvcp 10 "$2" 2>/dev/null &
}

set_theme() {
    if [ "$1" = "dark" ]; then
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    else
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    fi
}

case "$current_state" in
    0)
        hyprsunset -t 5500 >/dev/null 2>&1 &
        set_brightness "85%" 85
        set_theme "light"
        echo "1" > "$STATE_FILE"
        notify-send "Night Light" "Dim (5500K, 85%) - Light" -t 2000
        ;;
    1)
        hyprsunset -t 5000 >/dev/null 2>&1 &
        set_brightness "70%" 70
        set_theme "dark"
        echo "2" > "$STATE_FILE"
        notify-send "Night Light" "Light (5000K, 70%) - Dark" -t 2000
        ;;
    2)
        hyprsunset -t 4000 >/dev/null 2>&1 &
        set_brightness "50%" 50
        set_theme "dark"
        echo "3" > "$STATE_FILE"
        notify-send "Night Light" "Medium (4000K, 50%) - Dark" -t 2000
        ;;
    3)
        hyprsunset -t 3000 >/dev/null 2>&1 &
        set_brightness "30%" 30
        set_theme "dark"
        echo "4" > "$STATE_FILE"
        notify-send "Night Light" "Warm (3000K, 30%) - Dark" -t 2000
        ;;
    4)
        hyprsunset -t 6500 >/dev/null 2>&1 &
        set_brightness "100%" 100
        set_theme "light"
        echo "0" > "$STATE_FILE"
        notify-send "Night Light" "Off (6500K, 100%) - Light" -t 2000
        ;;
esac
