#!/bin/bash

ACTIVITY_LOG="$HOME/.claude/activity.log"
touch "$ACTIVITY_LOG"
COUNT=$(wc -l < "$ACTIVITY_LOG" 2>/dev/null | tr -d ' ')

if [ "$COUNT" -eq 0 ]; then
    echo "🟢 | size=16"
else
    echo "🔴 $COUNT | size=18 font='SF Pro Display Black'"
fi

echo "---"
if [ "$COUNT" -gt 0 ]; then
    cat "$ACTIVITY_LOG"
    echo "---"
fi
echo "Clear | bash='> \"$ACTIVITY_LOG\"' terminal=false refresh=true"