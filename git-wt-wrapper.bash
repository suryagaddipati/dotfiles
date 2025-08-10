#!/bin/bash

# git-wt wrapper functions for proper cd handling

git-wt() {
    local cmd="$1"
    shift
    
    case "$cmd" in
        create|cr)
            local output=$(/usr/local/bin/git-wt "$cmd" "$@")
            local exit_code=$?
            
            if [ $exit_code -eq 0 ]; then
                # Extract cd command if present
                if echo "$output" | grep -q '^cd '; then
                    local cd_cmd=$(echo "$output" | grep '^cd ')
                    eval "$cd_cmd"
                else
                    echo "$output"
                fi
            else
                echo "$output"
                return $exit_code
            fi
            ;;
            
        change|c|goto|cd)
            local output=$(/usr/local/bin/git-wt "$cmd" "$@")
            local exit_code=$?
            
            if [ $exit_code -eq 0 ]; then
                # Extract cd command if present
                if echo "$output" | grep -q '^cd '; then
                    local cd_cmd=$(echo "$output" | grep '^cd ')
                    eval "$cd_cmd"
                else
                    echo "$output"
                fi
            else
                echo "$output"
                return $exit_code
            fi
            ;;
            
        *)
            # For other commands, just pass through
            /usr/local/bin/git-wt "$cmd" "$@"
            ;;
    esac
}

# Export the function so it's available in subshells
export -f git-wt