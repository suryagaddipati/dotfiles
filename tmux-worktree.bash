#!/bin/bash

twc() {
    local branch="$1"
    local repo_root=$(git worktree list | head -1 | awk '{print $1}')
    local worktree_path="$repo_root/.worktrees/$branch"
    
    ~/code/dotfiles/git-commands/git-wt cr "$branch"
    
    if [ -n "$TMUX" ]; then
        if ! tmux list-windows -F '#W' | grep -q "^${branch}$"; then
            tmux new-window -n "$branch" -c "$worktree_path"
        else
            tmux select-window -t ":$branch"
        fi
    fi
}

tws() {
    local branch="$1"
    local repo_root=$(git worktree list | head -1 | awk '{print $1}')
    local worktree_path="$repo_root/.worktrees/$branch"
    
    if [ "$branch" = "master" ] || [ "$branch" = "main" ]; then
        worktree_path="$repo_root"
    fi
    
    cd "$worktree_path"
    
    if [ -n "$TMUX" ]; then
        if ! tmux list-windows -F '#W' | grep -q "^${branch}$"; then
            tmux new-window -n "$branch" -c "$worktree_path"
        else
            tmux select-window -t ":$branch"
        fi
    fi
}

twd() {
    local branch="$1"
    
    if [ -n "$TMUX" ] && tmux list-windows -F '#W' | grep -q "^${branch}$"; then
        tmux kill-window -t ":$branch"
    fi
    
    ~/code/dotfiles/git-commands/git-wt d "$branch"
}

twl() {
    ~/code/dotfiles/git-commands/git-wt l
}

twsync() {
    local repo_root=$(git worktree list | head -1 | awk '{print $1}')
    
    if [ -d "$repo_root/.worktrees" ]; then
        for worktree_path in "$repo_root"/.worktrees/*/; do
            if [ -d "$worktree_path" ]; then
                local branch=$(basename "$worktree_path")
                if ! tmux list-windows -F '#W' | grep -q "^${branch}$"; then
                    tmux new-window -n "$branch" -c "$worktree_path"
                fi
            fi
        done
    fi
}

twi() {
    local repo_root=$(git worktree list | head -1 | awk '{print $1}')
    local worktrees=()
    
    worktrees+=("master")
    
    if [ -d "$repo_root/.worktrees" ]; then
        for dir in "$repo_root"/.worktrees/*/; do
            if [ -d "$dir" ]; then
                worktrees+=($(basename "$dir"))
            fi
        done
    fi
    
    local selected=$(printf '%s\n' "${worktrees[@]}" | fzf --height=40% --reverse)
    
    if [ -n "$selected" ]; then
        tws "$selected"
    fi
}

