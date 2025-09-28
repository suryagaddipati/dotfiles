#!/usr/bin/env bash

# Stack Workspace Manager
# Automatically hides stack workspaces when switching away from their parent workspace

set -euo pipefail

LOG_FILE="/tmp/stack-workspace-manager.log"
LOCK_FILE="${XDG_RUNTIME_DIR:-/tmp}/stack_workspace_manager.lock"
exec 9>"$LOCK_FILE"
if ! flock -n 9; then
    echo "$(date): Stack workspace manager already running, exiting" >> "$LOG_FILE"
    exit 0
fi

echo "$(date): Stack workspace manager started" >> "$LOG_FILE"

STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/hypr/stack-workspaces"
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

# Function to get currently visible stack workspaces
get_visible_stack_workspaces() {
    # Check which special workspaces are currently active/visible using hyprctl monitors
    hyprctl -j monitors | jq -r '.[] | select(.specialWorkspace.name) | select(.specialWorkspace.name | startswith("special:stack")) | .specialWorkspace.name'
}

# Function to extract workspace ID from stack workspace name
# special:stack1 -> 1
extract_workspace_id() {
    echo "$1" | sed 's/special:stack//'
}

# Function to hide stack workspace
hide_stack_workspace() {
    local stack_name="$1"
    local workspace_id=$(extract_workspace_id "$stack_name")
    echo "$(date): Hiding stack workspace: $stack_name (for workspace $workspace_id)" >> "$LOG_FILE"
    hyprctl dispatch togglespecialworkspace "stack${workspace_id}" >/dev/null 2>&1 || true
}

is_stack_visible() {
    local workspace_id="$1"
    local special_name="special:stack${workspace_id}"
    hyprctl -j monitors | jq -e '.[] | select(.specialWorkspace.name == "'"$special_name"'")' >/dev/null 2>&1
}

restore_stack_workspace() {
    local workspace_id="$1"
    local state
    state=$(get_state "$workspace_id")

    if [ "$state" != "1" ]; then
        echo "$(date): No restore needed for workspace $workspace_id (state $state)" >> "$LOG_FILE"
        return
    fi

    if is_stack_visible "$workspace_id"; then
        echo "$(date): Stack workspace already visible for workspace $workspace_id" >> "$LOG_FILE"
        return
    fi

    echo "$(date): Restoring stack workspace for workspace $workspace_id" >> "$LOG_FILE"
    hyprctl dispatch togglespecialworkspace "stack${workspace_id}" >/dev/null 2>&1 || true
}

# Function to check and hide inappropriate stack workspaces
check_stack_workspaces() {
    local current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')

    echo "$(date): Checking stack workspaces for current workspace $current_workspace" >> "$LOG_FILE"

    # Get all currently visible stack workspaces
    local visible_stack=()
    while IFS= read -r stack_workspace; do
        if [[ -n "$stack_workspace" ]]; then
            visible_stack+=("$stack_workspace")
            echo "$(date): Found visible stack workspace: $stack_workspace" >> "$LOG_FILE"
        fi
    done < <(get_visible_stack_workspaces)

    local has_visible_current=false

    # Hide stack workspaces that don't belong to the current workspace
    for stack_workspace in "${visible_stack[@]}"; do
        local stack_workspace_id=$(extract_workspace_id "$stack_workspace")
        echo "$(date): Stack workspace $stack_workspace belongs to workspace $stack_workspace_id" >> "$LOG_FILE"
        if [[ "$stack_workspace_id" != "$current_workspace" ]]; then
            hide_stack_workspace "$stack_workspace"
        else
            has_visible_current=true
            set_state "$current_workspace" "1"
            echo "$(date): Keeping $stack_workspace visible (matches current workspace $current_workspace)" >> "$LOG_FILE"
        fi
    done

    if [[ "$has_visible_current" == false ]]; then
        echo "$(date): Stack workspace not visible for current workspace $current_workspace" >> "$LOG_FILE"
        restore_stack_workspace "$current_workspace"
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
        check_stack_workspaces
        previous_workspace="$current_workspace"
    fi
    
    sleep 0.2  # Check every 200ms for responsiveness
done
