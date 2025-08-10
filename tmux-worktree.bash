#!/bin/bash

# tmux-worktree.bash - Tmux integration for git worktrees
# Provides tmux-aware wrapper functions around git-wt commands

# Helper: Check if we're in a git repository
_in_git_repo() {
    git rev-parse --show-toplevel &>/dev/null
}

# Helper: Get repository root
_get_repo_root() {
    git rev-parse --show-toplevel 2>/dev/null
}

# Helper: Check if we're in tmux
_in_tmux() {
    [ -n "$TMUX" ]
}

# Helper: Get current tmux session name
_get_tmux_session() {
    if _in_tmux; then
        tmux display-message -p '#S'
    fi
}

# Helper: Check if tmux window exists
_tmux_window_exists() {
    local window_name="$1"
    if _in_tmux; then
        tmux list-windows -F '#W' | grep -q "^${window_name}$"
    else
        return 1
    fi
}

# Create worktree + tmux window
twc() {
    local branch="$1"

    if [ -z "$branch" ]; then
        echo "Usage: twa <branch>"
        return 1
    fi

    if ! _in_git_repo; then
        echo "Error: Not in a git repository"
        return 1
    fi

    local repo_root=$(_get_repo_root)
    local worktree_path="$repo_root/.worktrees/$branch"

    # Create worktree using git-wt
    if git-wt create "$branch"; then
        # If in tmux, create and switch to window
        if _in_tmux; then
            if ! _tmux_window_exists "$branch"; then
                tmux new-window -n "$branch" -c "$worktree_path"
                echo "Created tmux window: $branch"
            else
                tmux select-window -t ":$branch"
                echo "Switched to existing window: $branch"
            fi
        else
            echo "Worktree created at: $worktree_path"
            echo "Run 'cd $worktree_path' to enter the worktree"
        fi
    fi
}

# Switch to worktree window
tws() {
    local branch="$1"

    if [ -z "$branch" ]; then
        echo "Usage: tws <branch>"
        return 1
    fi

    if ! _in_git_repo; then
        echo "Error: Not in a git repository"
        return 1
    fi

    local repo_root=$(_get_repo_root)
    local worktree_path="$repo_root/.worktrees/$branch"

    # Check if worktree exists
    if [ ! -d "$worktree_path" ]; then
        echo "Error: Worktree '$branch' does not exist"
        echo "Available worktrees:"
        ls -1 "$repo_root/.worktrees" 2>/dev/null || echo "  (none)"
        return 1
    fi

    if _in_tmux; then
        if _tmux_window_exists "$branch"; then
            tmux select-window -t ":$branch"
            echo "Switched to window: $branch"
        else
            tmux new-window -n "$branch" -c "$worktree_path"
            echo "Created and switched to window: $branch"
        fi
    else
        echo "cd $worktree_path"
        cd "$worktree_path"
    fi
}

# Delete worktree + window
twd() {
    local branch="$1"

    if [ -z "$branch" ]; then
        echo "Usage: twd <branch>"
        return 1
    fi

    if ! _in_git_repo; then
        echo "Error: Not in a git repository"
        return 1
    fi

    # Kill tmux window if it exists
    if _in_tmux && _tmux_window_exists "$branch"; then
        tmux kill-window -t ":$branch"
        echo "Killed tmux window: $branch"
    fi

    # Delete worktree using git-wt
    git-wt delete "$branch"
}

# List worktrees with tmux window status
twl() {
    if ! _in_git_repo; then
        echo "Error: Not in a git repository"
        return 1
    fi

    local repo_root=$(_get_repo_root)
    local repo_name=$(basename "$repo_root")

    echo "Worktrees in $repo_name:"
    echo "----------------------------------------"

    # Use git worktree list to get all worktrees
    git worktree list --porcelain | while IFS= read -r line; do
        if [[ $line == worktree* ]]; then
            worktree_path=${line#worktree }
            worktree_name=$(basename "$worktree_path")
        elif [[ $line == branch* ]]; then
            branch_name=${line#branch refs/heads/}

            # Check tmux window status
            local window_status=""
            if _in_tmux && _tmux_window_exists "$worktree_name"; then
                window_status=" [tmux]"
            fi

            printf "  %-20s -> %-20s%s\n" "$worktree_name" "$branch_name" "$window_status"
        elif [[ $line == detached ]]; then
            printf "  %-20s -> %-20s\n" "$worktree_name" "(detached)"
        fi
    done
}

# Sync tmux windows with existing worktrees
twsync() {
    if ! _in_git_repo; then
        echo "Error: Not in a git repository"
        return 1
    fi

    if ! _in_tmux; then
        echo "Error: Not in a tmux session"
        return 1
    fi

    local repo_root=$(_get_repo_root)
    local created_count=0

    echo "Syncing tmux windows with worktrees..."

    # Check each worktree directory
    if [ -d "$repo_root/.worktrees" ]; then
        for worktree_path in "$repo_root"/.worktrees/*/; do
            if [ -d "$worktree_path" ]; then
                local branch=$(basename "$worktree_path")

                if ! _tmux_window_exists "$branch"; then
                    tmux new-window -n "$branch" -c "$worktree_path"
                    echo "  Created window: $branch"
                    ((created_count++))
                fi
            fi
        done
    fi

    if [ $created_count -eq 0 ]; then
        echo "  All worktrees already have windows"
    else
        echo "Created $created_count new window(s)"
    fi
}

# Interactive switcher with FZF
twi() {
    if ! _in_git_repo; then
        echo "Error: Not in a git repository"
        return 1
    fi

    if ! command -v fzf >/dev/null 2>&1; then
        echo "Error: fzf is not installed"
        return 1
    fi

    local repo_root=$(_get_repo_root)

    # Get list of worktrees
    local selected=$(git worktree list --porcelain | awk '
        /^worktree/ {
            path = $2
            name = substr(path, match(path, /[^/]+$/))
        }
        /^branch/ {
            branch = substr($0, 18)
            print name " -> " branch
        }
        /^detached/ {
            print name " -> (detached)"
        }
    ' | fzf --header="Select worktree to switch to" --height=40% --reverse)

    if [ -n "$selected" ]; then
        local branch=$(echo "$selected" | awk '{print $1}')
        tws "$branch"
    fi
}

# Aliases for convenience
alias tw='twl'
alias twall='twl'

# Completion function for worktree commands
_tw_completion() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)

    if [ -n "$repo_root" ] && [ -d "$repo_root/.worktrees" ]; then
        local worktrees=$(ls -1 "$repo_root/.worktrees" 2>/dev/null)
        COMPREPLY=($(compgen -W "$worktrees" -- "$cur"))
    fi
}

# Register completions
complete -F _tw_completion tws
complete -F _tw_completion twd

# Print help
twhelp() {
    cat << EOF
Tmux Worktree Commands:
  twa <branch>   - Create worktree and tmux window
  tws <branch>   - Switch to worktree/window
  twd <branch>   - Delete worktree and window
  twl            - List worktrees with tmux status
  twsync         - Sync tmux windows with worktrees
  twi            - Interactive worktree switcher (requires fzf)
  twhelp         - Show this help

Aliases:
  tw             - Same as twl
  twall          - Same as twl
EOF
}
