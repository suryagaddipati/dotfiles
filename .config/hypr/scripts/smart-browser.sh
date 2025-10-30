#!/usr/bin/env bash

URL="$1"

WORKSPACE_INFO=$(hyprctl activeworkspace -j)
WORKSPACE_ID=$(echo "$WORKSPACE_INFO" | jq -r '.id')

FALLBACK_PROFILE="Profile_2"

find_browser_on_workspace() {
    local workspace="$1"
    hyprctl clients -j | jq -r --arg ws "$workspace" '
        .[] | select(.class | contains("chromium") or contains("chrome"))
        | select(.workspace.name == $ws or (.workspace.id == ($ws | tonumber? // -999)))
        | "\(.address)|\(.pid)|\(.workspace.name)"
    ' | head -n1
}

get_chromium_profile() {
    local pid="$1"
    if [ -z "$pid" ]; then
        return 1
    fi

    local cmdline=$(cat /proc/$pid/cmdline 2>/dev/null | tr '\0' '\n')
    local profile=$(echo "$cmdline" | grep -oP '(?<=--profile-directory=)[^[:space:]]+' | head -n1)

    if [ -n "$profile" ]; then
        echo "$profile"
        return 0
    fi
    return 1
}

BROWSER_INFO=""
BROWSER_WORKSPACE=""

BROWSER_INFO=$(find_browser_on_workspace "$WORKSPACE_ID")

if [ -z "$BROWSER_INFO" ]; then
    for stack in A S D; do
        STACK_NAME="special:ws${WORKSPACE_ID}_${stack}"
        BROWSER_INFO=$(find_browser_on_workspace "$STACK_NAME")
        if [ -n "$BROWSER_INFO" ]; then
            BROWSER_WORKSPACE="$STACK_NAME"
            break
        fi
    done
else
    BROWSER_WORKSPACE="$WORKSPACE_ID"
fi

if [ -n "$BROWSER_INFO" ]; then
    WINDOW_ADDRESS=$(echo "$BROWSER_INFO" | cut -d'|' -f1)
    BROWSER_PID=$(echo "$BROWSER_INFO" | cut -d'|' -f2)
    PROFILE=$(get_chromium_profile "$BROWSER_PID")

    if [ -n "$WINDOW_ADDRESS" ]; then
        hyprctl dispatch focuswindow address:0x$WINDOW_ADDRESS >/dev/null 2>&1
        sleep 0.1
    fi
else
    PROFILE="$FALLBACK_PROFILE"
fi

if [ -z "$PROFILE" ]; then
    PROFILE="$FALLBACK_PROFILE"
fi

exec chromium --profile-directory="$PROFILE" "$URL"
