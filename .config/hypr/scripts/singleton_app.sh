#!/usr/bin/env bash
set -euo pipefail

APP_NAME="$1"
APP_CLASS="$2"
LAUNCH_CMD="$3"
APP_TITLE="${4:-}"

SPECIAL_WS="special:${APP_NAME}"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/hypr"
STACK_STATE_FILE="$CACHE_DIR/stack_before_singleton.txt"

mkdir -p "$CACHE_DIR"

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

get_current_stack_workspace() {
    hyprctl monitors -j | jq -r '.[].specialWorkspace.name // empty' | grep -E '^special:ws[0-9]+_[ASD]$' | head -n1
}

window_exists=$(check_window)

if [ -z "$window_exists" ]; then
    current_stack=$(get_current_stack_workspace)
    if [ -n "$current_stack" ]; then
        echo "$current_stack" > "$STACK_STATE_FILE"
    else
        rm -f "$STACK_STATE_FILE"
    fi

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
    is_visible=$(hyprctl monitors -j | jq -e ".[] | select(.specialWorkspace.name == \"$SPECIAL_WS\")" >/dev/null 2>&1 && echo 1 || echo 0)

    if [ "$is_visible" -eq 1 ]; then
        hyprctl dispatch togglespecialworkspace "$APP_NAME"

        if [ -f "$STACK_STATE_FILE" ]; then
            saved_stack=$(cat "$STACK_STATE_FILE")
            if [ -n "$saved_stack" ]; then
                stack_name=${saved_stack#special:}
                hyprctl dispatch togglespecialworkspace "$stack_name"
            fi
            rm -f "$STACK_STATE_FILE"
        fi
    else
        current_stack=$(get_current_stack_workspace)
        if [ -n "$current_stack" ]; then
            echo "$current_stack" > "$STACK_STATE_FILE"
        else
            rm -f "$STACK_STATE_FILE"
        fi

        hyprctl dispatch togglespecialworkspace "$APP_NAME"
    fi
fi
