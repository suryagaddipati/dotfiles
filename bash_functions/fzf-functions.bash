# FZF Functions for Bash
# Fuzzy finding utilities for git, processes, directories, and more

# Enhanced FZF functions
if command -v fzf >/dev/null 2>&1; then
    # Fuzzy git functions
    fgit() {
        local cmd="${1:-branch}"
        case "$cmd" in
            branch|br)
                local branch=$(git branch -a | grep -v '^*' | sed 's/^[ ]*//g' | sed 's/remotes\/origin\///g' | sort -u | fzf --prompt="Git Branch> ")
                [ -n "$branch" ] && git checkout "$branch"
                ;;
            log)
                git log --oneline --color=always | fzf --ansi --prompt="Git Log> " | cut -d' ' -f1 | xargs git show
                ;;
            status|files)
                local file=$(git status --porcelain | awk '{print $2}' | fzf --prompt="Git Files> ")
                [ -n "$file" ] && echo "Selected: $file"
                ;;
            *)
                echo "Usage: fgit [branch|log|status|files]"
                echo "  branch: fuzzy checkout branch"
                echo "  log: fuzzy browse git log"
                echo "  status: fuzzy browse modified files"
                ;;
        esac
    }
    
    # Fuzzy process killer
    fkill() {
        local pid=$(ps -ef | sed 1d | fzf -m --prompt="Kill Process> " --header="[TAB:select multiple]" | awk '{print $2}')
        if [ -n "$pid" ]; then
            echo "$pid" | xargs kill -"${1:-9}"
        fi
    }
    
    # Fuzzy directory navigation
    fcd() {
        local dir
        if [ $# -eq 0 ]; then
            dir=$(find . -type d -not -path "*/\.*" 2>/dev/null | fzf --prompt="Change Directory> ")
        else
            dir=$(find "$1" -type d 2>/dev/null | fzf --prompt="Change Directory> ")
        fi
        [ -n "$dir" ] && cd "$dir"
    }
    
    # Enhanced grep with fzf integration
    fgrp() {
        if [ "$#" -lt 1 ]; then
            echo "Usage: fgrp <pattern> [ext1] [ext2] ..."
            echo "Example: fgrp TODO js ts py"
            return 1
        fi
        
        local pattern="$1"
        shift
        
        if [ "$#" -eq 0 ]; then
            # No extensions specified, search all files
            git ls-files --cached --others --exclude-standard 2>/dev/null \
                | xargs grep -l "$pattern" 2>/dev/null \
                | fzf --prompt="Files containing '$pattern'> "
        else
            # Use original grp function with fzf
            local ext_regex=$(printf "\\.%s$|" "$@" | sed 's/|$//')
            git ls-files --cached --others --exclude-standard 2>/dev/null \
                | grep -E "$ext_regex" \
                | xargs grep -l "$pattern" 2>/dev/null \
                | fzf --prompt="Files containing '$pattern'> "
        fi
    }
    
    # Fuzzy tmux session management
    ft() {
        if [ $# -eq 0 ]; then
            # Show existing sessions and allow selection
            local session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --prompt="Tmux Session> " --header="[Enter:attach] [Ctrl-c:cancel]")
            if [ -n "$session" ]; then
                tmux attach -t "$session"
            fi
        else
            # Use original tmux_smart_session function
            tmux_smart_session "$@"
        fi
    }
fi

# FZF configuration and integration
if command -v fzf >/dev/null 2>&1; then
    # Enable FZF shell integration if available
    if [ -f ~/.fzf.bash ]; then
        source ~/.fzf.bash
    elif command -v mise >/dev/null 2>&1; then
        # Use mise-installed fzf integration
        eval "$(fzf --bash)"
    fi
    
    # Custom FZF options
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --multi --bind=esc:abort,ctrl-c:abort'
    export FZF_DEFAULT_COMMAND='git ls-files --cached --others --exclude-standard 2>/dev/null || find . -type f -not -path "*/\.git/*" 2>/dev/null'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='find . -type d -not -path "*/\.git/*" 2>/dev/null'
fi
