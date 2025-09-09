#!/usr/bin/env bash

# Magic Workspace Manager
# Automatically hides magic workspaces when switching away from their parent workspace

set -euo pipefail

LOG_FILE="/tmp/magic-workspace-manager.log"
echo "$(date): Magic workspace manager started" >> "$LOG_FILE"

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
    
    # Hide magic workspaces that don't belong to the current workspace
    for magic_workspace in "${visible_magic[@]}"; do
        local magic_workspace_id=$(extract_workspace_id "$magic_workspace")
        echo "$(date): Magic workspace $magic_workspace belongs to workspace $magic_workspace_id" >> "$LOG_FILE"
        if [[ "$magic_workspace_id" != "$current_workspace" ]]; then
            hide_magic_workspace "$magic_workspace"
        else
            echo "$(date): Keeping $magic_workspace visible (matches current workspace $current_workspace)" >> "$LOG_FILE"
        fi
    done
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