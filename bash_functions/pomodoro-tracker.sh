#!/usr/bin/env bash

# Pomodoro tracker with daily counter
# Usage: pomodoro-tracker.sh [status|start|pause|stop|count]

# Ensure HOME is set
if [[ -z "$HOME" ]]; then
    HOME="/home/$(whoami)"
fi

POMO_DATA_DIR="$HOME/.local/share/pomodoro-tracker"
POMO_DAILY_FILE="$POMO_DATA_DIR/daily-$(date +%Y-%m-%d).json"
POMO_STATE_FILE="$HOME/.cache/pomodoro-cli-info.json"

# Ensure PATH includes cargo bin for pomodoro-cli
export PATH="$HOME/.cargo/bin:$PATH"

# Ensure data directory exists
mkdir -p "$POMO_DATA_DIR"

# Initialize daily file if it doesn't exist
init_daily_file() {
    if [[ ! -f "$POMO_DAILY_FILE" ]]; then
        echo '{"date":"'$(date +%Y-%m-%d)'","completed":0,"sessions":[]}' > "$POMO_DAILY_FILE"
    fi
}

# Get current daily count
get_daily_count() {
    init_daily_file
    jq -r '.completed' "$POMO_DAILY_FILE" 2>/dev/null || echo "0"
}

# Increment daily count
increment_daily_count() {
    init_daily_file
    local timestamp=$(date -Iseconds)
    local temp_file=$(mktemp)
    
    jq --arg ts "$timestamp" '.completed += 1 | .sessions += [$ts]' "$POMO_DAILY_FILE" > "$temp_file" && mv "$temp_file" "$POMO_DAILY_FILE"
}

# Check if a pomodoro just finished
check_completion() {
    if [[ -f "$POMO_STATE_FILE" ]]; then
        local state=$(jq -r '.state' "$POMO_STATE_FILE" 2>/dev/null)
        local duration=$(jq -r '.duration' "$POMO_STATE_FILE" 2>/dev/null)
        
        # Only count work sessions (24+ minutes) that are finished
        if [[ "$state" == "Finished" && "$duration" -ge 1440 ]]; then
            # Check if this completion was already counted
            local start_time=$(jq -r '.start_time' "$POMO_STATE_FILE" 2>/dev/null)
            local last_counted_file="$POMO_DATA_DIR/last-counted"
            
            if [[ ! -f "$last_counted_file" ]] || [[ "$(cat "$last_counted_file" 2>/dev/null)" != "$start_time" ]]; then
                increment_daily_count
                echo "$start_time" > "$last_counted_file"
                echo "🍅 Pomodoro completed! Daily count: $(get_daily_count)"
            fi
        fi
    fi
}

# Enhanced status with daily count
enhanced_status() {
    local pomo_status
    local daily_count
    
    # Get standard pomodoro status
    pomo_status=$(pomodoro-cli status --format json --time-format digital 2>/dev/null)
    
    if [[ $? -eq 0 && -n "$pomo_status" ]]; then
        daily_count=$(get_daily_count)
        
        # Parse the existing JSON and add daily count (compact output for Waybar)
        echo "$pomo_status" | jq -c --argjson count "$daily_count" '
            .text = (.text + " (" + ($count | tostring) + ")") |
            .tooltip = (.tooltip + "\nToday: " + ($count | tostring) + " completed") |
            .daily_count = $count
        '
    else
        # Fallback if pomodoro-cli fails
        daily_count=$(get_daily_count)
        echo '{"text":"--:-- ('$daily_count')","tooltip":"Timer not running\nToday: '$daily_count' completed","class":"","percentage":0,"daily_count":'$daily_count'}'
    fi
}

case "$1" in
    "status")
        enhanced_status
        ;;
    "start")
        shift
        pomodoro-cli start "$@"
        ;;
    "pause")
        pomodoro-cli pause
        ;;
    "stop")
        pomodoro-cli stop
        ;;
    "toggle")
        # Smart toggle: start if not running, pause/resume if running
        if [[ -f "$POMO_STATE_FILE" ]]; then
            state=$(jq -r '.state' "$POMO_STATE_FILE" 2>/dev/null)
            case "$state" in
                "Running")
                    pomodoro-cli pause
                    ;;
                "Paused")
                    pomodoro-cli pause  # pomodoro-cli pause toggles pause/resume
                    ;;
                "Finished"|*)
                    pomodoro-cli start --add 25m --notify
                    ;;
            esac
        else
            # No state file, start new session
            pomodoro-cli start --add 25m --notify
        fi
        ;;
    "count")
        get_daily_count
        ;;
    "check-completion")
        check_completion
        ;;
    *)
        echo "Usage: $0 [status|start|pause|stop|toggle|count|check-completion]"
        echo "  status           - Get status with daily count"
        echo "  start [options]  - Start timer (pass options to pomodoro-cli)"
        echo "  pause            - Pause/resume timer"
        echo "  stop             - Stop timer"
        echo "  toggle           - Smart toggle: start/pause/resume"
        echo "  count            - Get today's completion count"
        echo "  check-completion - Check and count completed sessions"
        exit 1
        ;;
esac