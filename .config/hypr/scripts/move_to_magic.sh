#!/usr/bin/env bash
set -euo pipefail

# Preserve whether special:magic is currently visible
visible=false
if hyprctl -j workspaces | rg -P -q '(?s)"name"\s*:\s*"special:magic".*?"visible"\s*:\s*true'; then
  visible=true
fi

# Ensure it's shown (creates it if missing), move, then restore visibility
if [ "$visible" != true ]; then hyprctl dispatch togglespecialworkspace magic >/dev/null; fi
hyprctl dispatch movetoworkspace special:magic >/dev/null
if [ "$visible" != true ]; then hyprctl dispatch togglespecialworkspace magic >/dev/null; fi
