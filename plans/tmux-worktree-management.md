# Tmux Worktree Management System

## Goal
Seamlessly work on multiple git worktrees concurrently with tmux, where each worktree gets its own tmux window and you can switch between them instantly with keyboard shortcuts.

## Architecture
- **Layer 1**: Git worktree commands (existing `git-wt` script) - pure git operations
- **Layer 2**: Bash functions that wrap git commands and add tmux integration
- **Layer 3**: Tmux keybindings for quick navigation

## Core Concept
- **Tmux Sessions** = Git repositories/projects
- **Tmux Windows** = Git worktrees (branches)
- **Navigation** = Alt+1-9 for windows, Alt+w for interactive switcher

## Implementation Steps

### 1. Keep existing git-wt script as-is
The current `git-commands/git-wt` handles pure git worktree operations:
- Creates worktrees in `.worktrees/` directory
- No tmux dependencies
- Works standalone

### 2. Create tmux-worktree.bash
New file with bash functions that wrap git commands and add tmux functionality:

```bash
# tmux-worktree.bash - Tmux integration for git worktrees

# Create worktree + tmux window
twa() {
    # Call git-wt to create worktree
    # If in tmux, create window named after branch
    # Switch to new window
}

# Switch to worktree window
tws() {
    # If window exists, switch to it
    # If not, create window and switch
}

# Delete worktree + window
twd() {
    # Kill tmux window if exists
    # Call git-wt to delete worktree
}

# List worktrees with tmux window status
twl() {
    # Show worktrees and indicate which have tmux windows
}

# Sync tmux windows with existing worktrees
twsync() {
    # Create windows for all worktrees that don't have them
}

# Interactive switcher with FZF
twi() {
    # FZF selector with preview
    # Switch tmux window on selection
}
```

### 3. Create FZF-based interactive switcher
Separate script `git-commands/worktree-switch`:
- Lists all worktrees with branch info
- Preview shows recent commits and status
- On selection, switches tmux window or creates one

### 4. Update .tmux.conf
Add keybindings that call the bash functions:
- `Alt+w` - Run interactive switcher
- `Alt+W` - List worktrees
- `Ctrl+y W` - Sync windows with worktrees
- `Ctrl+y N` - New worktree prompt
- `Ctrl+y D` - Delete worktree prompt

Add to status bar:
- Show current git branch

### 5. Update .bashrc
Source the new tmux-worktree.bash file:
```bash
source ~/code/dotfiles/tmux-worktree.bash
```

## File Structure
```
dotfiles/
├── git-commands/
│   ├── git-wt              # Existing pure git worktree script
│   └── worktree-switch     # FZF interactive switcher
├── tmux-worktree.bash      # Tmux integration functions
├── .tmux.conf              # Keybindings and status bar
└── .bashrc                 # Sources tmux-worktree.bash
```

## Workflow

### Creating a feature
```bash
twa feature-auth        # Creates worktree AND tmux window
# Automatically switches to new window
```

### Switching between worktrees
- `Alt+1` - Switch to window 1 (main)
- `Alt+2` - Switch to window 2 (feature-auth)
- `Alt+w` - Interactive switcher with preview
- `tws feature-auth` - Command line switch

### Syncing after cloning
```bash
cd existing-repo
twsync                  # Creates tmux windows for all existing worktrees
```

## Benefits of Separation
- Git commands remain pure and work without tmux
- Tmux integration is optional layer
- Can use git-wt directly when not in tmux
- Easier to debug and maintain
- Functions can be selectively loaded

## Progress

### Todo
- [ ] Create `worktree-switch` FZF interactive switcher (separate script)
- [ ] Update `.tmux.conf` with keybindings for worktree navigation
- [ ] Update `.tmux.conf` with git branch in status bar
- [ ] Test workflow with multiple worktrees

### Done
- [x] Create high-level plan and architecture
- [x] Define separation between git and tmux layers
- [x] Document file structure and workflow
- [x] Create `tmux-worktree.bash` with wrapper functions (twc, tws, twd, twl, twsync, twi)
- [x] Update `.bashrc` to source tmux-worktree.bash
- [x] Add completion functions for worktree commands
- [x] Add help function (twhelp)
- [x] Implement FZF interactive switcher as function (twi) within tmux-worktree.bash

## Implementation Priority
1. Start with basic `twa`, `tws`, `twd` functions
2. Add `twsync` for existing repositories
3. Add interactive switcher last
4. Refine keybindings based on usage