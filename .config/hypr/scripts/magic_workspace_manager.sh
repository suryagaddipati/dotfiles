#!/usr/bin/env bash

# Magic Workspace Manager
# Automatically hides magic workspaces when switching away from their parent workspace

set -euo pipefail

LOG_FILE="/tmp/magic-workspace-manager.log"
LOCK_FILE="${XDG_RUNTIME_DIR:-/tmp}/magic_workspace_manager.lock"
exec 9>"$LOCK_FILE"
if ! flock -n 9; then
    echo "$(date): Magic workspace manager already running, exiting" >> "$LOG_FILE"
    exit 0
fi

echo "$(date): Magic workspace manager started" >> "$LOG_FILE"

STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/hypr/magic-workspaces"
mkdir -p "$STATE_DIR"

state_file() {
    printf '%s/workspace_%s' "$STATE_DIR" "$1"
}

get_state() {
    local file
    file="$(state_file "$1")"
    if [ -f "$file" ]; then
        cat "$file"
    else
        printf '0\n'
    fi
}

set_state() {
    local file
    file="$(state_file "$1")"
    printf '%s\n' "$2" > "$file"
}

# Function to get currently visible magic workspaces
get_visible_magic_workspaces() {
    # Check which special workspaces are currently active/visible using hyprctl monitors
    hyprctl -j monitors | jq -r '.[] | select(.specialWorkspace.name) | select(.specialWorkspace.name | startswith("special:magic")) | .specialWorkspace.name'
}

# Function to extract workspace ID from magic workspace name
# special:magic1 -> 1
extract_workspace_id() {
    echo "$1" | sed 's/special:magic//'
}

# Function to hide magic workspace
hide_magic_workspace() {
    local magic_name="$1"
    local workspace_id=$(extract_workspace_id "$magic_name")
    echo "$(date): Hiding magic workspace: $magic_name (for workspace $workspace_id)" >> "$LOG_FILE"
    hyprctl dispatch togglespecialworkspace "magic${workspace_id}" >/dev/null 2>&1 || true
}

is_magic_visible() {
    local workspace_id="$1"
    local special_name="special:magic${workspace_id}"
    hyprctl -j monitors | jq -e '.[] | select(.specialWorkspace.name == "'"$special_name"'")' >/dev/null 2>&1
}

restore_magic_workspace() {
    local workspace_id="$1"
    local state
    state=$(get_state "$workspace_id")

    if [ "$state" != "1" ]; then
        echo "$(date): No restore needed for workspace $workspace_id (state $state)" >> "$LOG_FILE"
        return
    fi

    if is_magic_visible "$workspace_id"; then
        echo "$(date): Magic workspace already visible for workspace $workspace_id" >> "$LOG_FILE"
        return
    fi

    echo "$(date): Restoring magic workspace for workspace $workspace_id" >> "$LOG_FILE"
    hyprctl dispatch togglespecialworkspace "magic${workspace_id}" >/dev/null 2>&1 || true
}

# Function to check and hide inappropriate magic workspaces
check_magic_workspaces() {
    local current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')
    
    echo "$(date): Checking magic workspaces for current workspace $current_workspace" >> "$LOG_FILE"
    
    # Get all currently visible magic workspaces
    local visible_magic=()
    while IFS= read -r magic_workspace; do
        if [[ -n "$magic_workspace" ]]; then
            visible_magic+=("$magic_workspace")
            echo "$(date): Found visible magic workspace: $magic_workspace" >> "$LOG_FILE"
        fi
    done < <(get_visible_magic_workspaces)
    
    local has_visible_current=false

    # Hide magic workspaces that don't belong to the current workspace
    for magic_workspace in "${visible_magic[@]}"; do
        local magic_workspace_id=$(extract_workspace_id "$magic_workspace")
        echo "$(date): Magic workspace $magic_workspace belongs to workspace $magic_workspace_id" >> "$LOG_FILE"
        if [[ "$magic_workspace_id" != "$current_workspace" ]]; then
            hide_magic_workspace "$magic_workspace"
        else
            has_visible_current=true
            set_state "$current_workspace" "1"
            echo "$(date): Keeping $magic_workspace visible (matches current workspace $current_workspace)" >> "$LOG_FILE"
        fi
    done

    if [[ "$has_visible_current" == false ]]; then
        echo "$(date): Magic workspace not visible for current workspace $current_workspace" >> "$LOG_FILE"
        restore_magic_workspace "$current_workspace"
    fi
}

# Monitor workspace changes by polling (simpler than socat)
previous_workspace=$(hyprctl activeworkspace -j | jq -r '.id')

while true; do
    current_workspace=$(hyprctl activeworkspace -j | jq -r '.id' 2>/dev/null) || {
        echo "$(date): Failed to get workspace, retrying..." >> "$LOG_FILE"
        sleep 1
        continue
    }
    
    if [[ "$current_workspace" != "$previous_workspace" ]]; then
        echo "$(date): Workspace changed: $previous_workspace -> $current_workspace" >> "$LOG_FILE"
        check_magic_workspaces
        previous_workspace="$current_workspace"
    fi
    
    sleep 0.2  # Check every 200ms for responsiveness
done
