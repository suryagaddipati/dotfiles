#!/bin/bash

# tmux-worktree.bash - Tmux integration for git worktrees
# Provides tmux-aware wrapper functions around git-wt commands

# Helper: Check if we're in a git repository
_in_git_repo() {
    git rev-parse --show-toplevel &>/dev/null
}

# Helper: Get main repository root (not worktree root)
_get_repo_root() {
    # Get the main repository path, not the worktree path
    local main_repo=$(git worktree list | head -1 | awk '{print $1}')
    if [ -n "$main_repo" ]; then
        echo "$main_repo"
    else
        git rev-parse --show-toplevel 2>/dev/null
    fi
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

# Helper: Extract branch name from worktree path
_extract_branch_from_path() {
    local path="$1"
    if [[ "$path" =~ \.worktrees/([^/]+) ]]; then
        echo "${BASH_REMATCH[1]}"
    else
        basename "$path"
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

# Create worktree + tmux session/window
twc() {
    local branch="$1"

    if [ -z "$branch" ]; then
        echo "Usage: twc <branch>"
        return 1
    fi

    if ! _in_git_repo; then
        echo "Error: Not in a git repository"
        return 1
    fi

    local repo_root=$(_get_repo_root)
    local repo_name=$(basename "$repo_root")
    local worktree_path="$repo_root/.worktrees/$branch"

    # Create worktree using git-wt
    echo "Creating worktree for branch: $branch"
    
    # Call the actual git-wt binary directly to avoid wrapper issues
    local output=$(/usr/local/bin/git-wt create "$branch" 2>&1)
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        # Extract and execute cd command if present
        if echo "$output" | grep -q '^cd '; then
            local cd_cmd=$(echo "$output" | grep '^cd ')
            eval "$cd_cmd"
        fi
        
        # Handle tmux session/window creation
        if _in_tmux; then
            local session=$(_get_tmux_session)
            local window_name="$branch"
            
            # Create or switch to window
            if ! _tmux_window_exists "$window_name"; then
                tmux new-window -n "$window_name" -c "$worktree_path"
                echo "Created tmux window: $window_name in session: $session"
            else
                tmux select-window -t ":$window_name"
                echo "Switched to existing window: $window_name"
            fi
        else
            # Not in tmux, offer to create a session
            echo "Worktree created at: $worktree_path"
            echo "To create a tmux session: tmux new -s $repo_name-$branch -c $worktree_path"
        fi
    else
        echo "Failed to create worktree: $output"
        return 1
    fi
}

# Switch to worktree with tmux session/window management
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
    local repo_name=$(basename "$repo_root")
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    local worktree_path
    local window_name

    # Determine the worktree path and window name
    if [ "$branch" = "$repo_name" ] || [ "$branch" = "master" ] || [ "$branch" = "main" ]; then
        # Main worktree
        worktree_path="$repo_root"
        window_name="master"
    else
        # Feature branch worktree
        worktree_path="$repo_root/.worktrees/$branch"
        window_name="$branch"
    fi

    # Check if worktree exists
    if [ ! -d "$worktree_path" ]; then
        echo "Error: Worktree '$branch' does not exist"
        echo "Available worktrees:"
        twl
        return 1
    fi

    # Change to the worktree directory
    cd "$worktree_path"
    echo "Switched to worktree: $branch at $worktree_path"

    # Handle tmux session/window management
    if _in_tmux; then
        local session=$(_get_tmux_session)
        
        # Check if we should create a new session or just a window
        # Use convention: repo-branch for feature branches
        if [ "$window_name" != "master" ]; then
            # For feature branches, check if we want separate sessions
            if [ "${TMUX_WORKTREE_SESSIONS:-false}" = "true" ]; then
                # Create/switch to dedicated session
                local session_name="${repo_name}-${branch}"
                if ! tmux has-session -t "$session_name" 2>/dev/null; then
                    # Create new session in background
                    tmux new-session -d -s "$session_name" -c "$worktree_path"
                    echo "Created tmux session: $session_name"
                fi
                # Switch to the session
                tmux switch-client -t "$session_name"
                echo "Switched to tmux session: $session_name"
            else
                # Use windows within current session (default behavior)
                if ! _tmux_window_exists "$window_name"; then
                    tmux new-window -n "$window_name" -c "$worktree_path"
                    echo "Created tmux window: $window_name"
                else
                    tmux select-window -t ":$window_name"
                    echo "Switched to tmux window: $window_name"
                fi
            fi
        else
            # For master branch, always use window in current session
            if ! _tmux_window_exists "$window_name"; then
                tmux new-window -n "$window_name" -c "$worktree_path"
                echo "Created tmux window: $window_name"
            else
                tmux select-window -t ":$window_name"
                echo "Switched to tmux window: $window_name"
            fi
        fi
    else
        # Not in tmux, suggest creating a session
        if [ "$window_name" != "master" ]; then
            echo "Tip: Create tmux session with: tmux new -s ${repo_name}-${branch}"
        else
            echo "Tip: Create tmux session with: tmux new -s ${repo_name}"
        fi
    fi
}

# Delete worktree + tmux window + git branch
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

    # Delete worktree and branch using git-wt (it handles both)
    git-wt delete "$branch"
}

# List worktrees with enhanced status
twl() {
    if ! _in_git_repo; then
        echo "Error: Not in a git repository"
        return 1
    fi

    local repo_root=$(_get_repo_root)
    local repo_name=$(basename "$repo_root")
    local current_path=$(pwd)
    local current_worktree=""

    # Determine current worktree
    if [[ "$current_path" =~ \.worktrees/([^/]+) ]]; then
        current_worktree="${BASH_REMATCH[1]}"
    elif [ "$current_path" = "$repo_root" ]; then
        current_worktree="master"
    fi

    echo "Worktrees in $repo_name:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    printf "%-20s %-25s %-10s %s\n" "Branch" "Path" "Status" "Tmux"
    echo "────────────────────────────────────────"

    # List main worktree
    local main_status=""
    local main_tmux=""
    
    if [ "$current_worktree" = "master" ]; then
        main_status="[current]"
    fi
    
    if _in_tmux && _tmux_window_exists "master"; then
        main_tmux="[window]"
    fi
    
    printf "%-20s %-25s %-10s %s\n" "master" "$repo_name/" "$main_status" "$main_tmux"

    # List feature worktrees
    if [ -d "$repo_root/.worktrees" ]; then
        for dir in "$repo_root"/.worktrees/*/; do
            if [ -d "$dir" ]; then
                local branch=$(basename "$dir")
                local status=""
                local tmux_status=""
                
                if [ "$current_worktree" = "$branch" ]; then
                    status="[current]"
                fi
                
                if _in_tmux; then
                    if _tmux_window_exists "$branch"; then
                        tmux_status="[window]"
                    fi
                    
                    # Check for session too if sessions are enabled
                    if [ "${TMUX_WORKTREE_SESSIONS:-false}" = "true" ]; then
                        local session_name="${repo_name}-${branch}"
                        if tmux has-session -t "$session_name" 2>/dev/null; then
                            tmux_status="[session]"
                        fi
                    fi
                fi
                
                printf "%-20s %-25s %-10s %s\n" "$branch" ".worktrees/$branch/" "$status" "$tmux_status"
            fi
        done
    fi
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Show tips
    echo ""
    echo "Commands:"
    echo "  twc <branch>  - Create new worktree"
    echo "  tws <branch>  - Switch to worktree"
    echo "  twd <branch>  - Delete worktree"
    echo "  twi          - Interactive switcher"
    
    if [ "${TMUX_WORKTREE_SESSIONS:-false}" != "true" ]; then
        echo ""
        echo "Tip: Set TMUX_WORKTREE_SESSIONS=true to use separate tmux sessions"
    fi
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

    if ! command -v fzf &> /dev/null; then
        echo "Error: fzf is not installed"
        return 1
    fi

    local repo_root=$(_get_repo_root)
    local repo_name=$(basename "$repo_root")

    # Get list of worktrees with enhanced info
    local worktrees=$()
    
    # Add main worktree
    worktrees+=("master (main repository)")
    
    # Add feature worktrees
    if [ -d "$repo_root/.worktrees" ]; then
        for dir in "$repo_root"/.worktrees/*/; do
            if [ -d "$dir" ]; then
                local branch=$(basename "$dir")
                local status=""
                
                # Check if tmux window exists
                if _in_tmux && _tmux_window_exists "$branch"; then
                    status=" [tmux]"
                fi
                
                worktrees+=("$branch (feature branch)$status")
            fi
        done
    fi

    # Show FZF selector
    local selected=$(printf '%s\n' "${worktrees[@]}" | fzf \
        --header="Select worktree to switch to" \
        --height=40% \
        --reverse \
        --preview-window=hidden)

    if [ -n "$selected" ]; then
        # Extract branch name (first word)
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
  twc <branch>   - Create worktree and tmux window
  tws <branch>   - Switch to worktree/window
  twd <branch>   - Delete worktree, window, and branch
  twl            - List worktrees with tmux status
  twsync         - Sync tmux windows with worktrees
  twi            - Interactive worktree switcher (requires fzf)
  twhelp         - Show this help

Aliases:
  tw             - Same as twl
  twall          - Same as twl
EOF
}
