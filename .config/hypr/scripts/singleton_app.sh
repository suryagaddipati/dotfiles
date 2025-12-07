#!/usr/bin/env bash
set -euo pipefail

APP_NAME="$1"
APP_CLASS="$2"
LAUNCH_CMD="$3"
APP_TITLE="${4:-}"

SPECIAL_WS="special:${APP_NAME}"

check_window() {
    local clients
    clients=$(hyprctl clients -j)
    if [ -n "$APP_TITLE" ]; then
        echo "$clients" | jq -r ".[] | select(.workspace.name == \"$SPECIAL_WS\" and .class == \"$APP_CLASS\" and (.title | test(\"$APP_TITLE\"))) | .address" | head -n1
    else
        echo "$clients" | jq -r ".[] | select(.workspace.name == \"$SPECIAL_WS\" and .class == \"$APP_CLASS\") | .address" | head -n1
    fi
}

find_new_window() {
    local clients
    clients=$(hyprctl clients -j)
    if [ -n "$APP_TITLE" ]; then
        echo "$clients" | jq -r ".[] | select(.class == \"$APP_CLASS\" and (.title | test(\"$APP_TITLE\"))) | .address" | head -n1
    else
        echo "$clients" | jq -r ".[] | select(.class == \"$APP_CLASS\") | .address" | head -n1
    fi
}

window_exists=$(check_window)

if [ -z "$window_exists" ]; then
    bash -c "$LAUNCH_CMD" &

    for _ in {1..100}; do
        sleep 0.1
        window_exists=$(find_new_window)
        if [ -n "$window_exists" ]; then
            current_ws=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$window_exists\") | .workspace.name")
            if [ "$current_ws" = "$SPECIAL_WS" ]; then
                hyprctl dispatch focuswindow "address:$window_exists"
            else
                hyprctl dispatch movetoworkspace "$SPECIAL_WS,address:$window_exists"
            fi
            exit 0
        fi
    done
    notify-send "Singleton App" "Failed to launch $APP_NAME (timeout)" -u warning
    exit 1
else
    hyprctl dispatch togglespecialworkspace "$APP_NAME"
fi
