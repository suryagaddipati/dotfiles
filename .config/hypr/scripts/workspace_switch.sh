#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "Usage: $0 <workspace_number>"
    exit 1
fi

hyprctl dispatch workspace "$1"
