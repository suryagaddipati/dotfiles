#!/bin/bash -x

# Claude CLI helper functions

run_claude() {
    local prompt="$1"
    local output_format="${2:-text}"
    local allowed_tools="${3:-}"

    local cmd="~/.claude/local/claude -p \"$prompt\" --output-format \"$output_format\""

    # Add allowedTools if provided
    if [ -n "$allowed_tools" ]; then
        cmd="$cmd --allowedTools \"$allowed_tools\""
    fi

    if eval "$cmd"; then
        echo "Success!"
    else
        echo "Error: Claude failed with exit code $?" >&2
        return 1
    fi
}

