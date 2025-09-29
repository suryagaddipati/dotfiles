#!/usr/bin/env bash
set -euo pipefail

# Get current workspace ID
current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')

# Use workspace number directly as profile number
profile_name="Profile_${current_workspace}"

echo "Launching browser with profile: $profile_name (Workspace $current_workspace)"

# Launch browser with workspace-specific profile
exec chromium --profile-directory="$profile_name" "$@"