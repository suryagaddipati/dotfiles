#!/bin/bash
wayfreeze & PID=$!
sleep 0.1
region=$(slurp 2>/dev/null)
kill $PID 2>/dev/null
[ -n "$region" ] && grim -g "$region" - | wl-copy
