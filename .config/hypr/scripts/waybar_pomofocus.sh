#!/usr/bin/env bash
title=$(hyprctl clients -j | jq -r '.[] | select(.class == "chrome-pomofocus.io__-Profile_2") | .title' | head -n1)

if [ -z "$title" ]; then
    echo '{"text": "󰔛", "tooltip": "Pomofocus (Super+Ctrl+P)", "class": "inactive"}'
else
    timer=$(echo "$title" | grep -oE '^[0-9]+:[0-9]+' || echo "")
    if [ -n "$timer" ]; then
        echo "{\"text\": \"󰔛 $timer\", \"tooltip\": \"$title\", \"class\": \"active\"}"
    else
        echo '{"text": "󰔛", "tooltip": "'"$title"'", "class": "active"}'
    fi
fi
