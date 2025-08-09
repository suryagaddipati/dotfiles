#!/bin/bash

# Claude CLI helper functions

run_claude() {
    local prompt="$1"
    local output_format="${2:-text}"
    local allowed_tools="${3:-}"

    # Use bypassPermissions mode since we have git permissions in settings.local.json
    local cmd="~/.claude/local/claude -p \"$prompt\" --output-format \"$output_format\" --permission-mode bypassPermissions"
    
    if eval "$cmd"; then
        echo "Success!"
    else
        echo "Error: Claude failed with exit code $?" >&2
        return 1
    fi
}

