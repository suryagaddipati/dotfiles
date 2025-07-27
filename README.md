# Dotfiles

Optimized configuration for bash, git, tmux, and neovim with vim-style navigation and productivity shortcuts.

## Quick Setup

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
just full-install    # Complete setup with dependencies
```

## Essential Commands

```bash
just install        # Install dotfiles with backup
just status         # Check installation status  
just backup         # Backup existing configs
just update         # Update from git
```

## Core Shortcuts

### Navigation (Works Everywhere)
```bash
Alt+h/j/k/l         # Navigate tmux panes (instant)
Ctrl+h/j/k/l        # Navigate neovim splits
Alt+1-9             # Switch tmux windows (instant)
Tab/Shift+Tab       # Cycle neovim buffers
```

### Terminal (Bash)
```bash
g                   # git alias
t [session]         # smart tmux session manager
ll                  # detailed file listing
grp pattern ext     # multi-extension search (e.g., grp TODO js py)
```

### Tmux (Prefix: Ctrl-Space)
```bash
# Panes
Ctrl-Space s        # Split horizontal
Ctrl-Space v        # Split vertical
Ctrl-Space x        # Kill pane
Alt+h/j/k/l         # Navigate panes (no prefix)

# Windows  
Alt+1-9             # Switch to window 1-9 (no prefix)
Ctrl-Space c        # New window
Ctrl-Space ,        # Rename window

# Sessions
Alt+s               # Choose session (no prefix)
Ctrl-Space S        # New session
```

## Neovim Shortcuts (Leader: Space)

### File Operations
```vim
<leader>w           " Save file
<leader>q           " Quit
<leader>x           " Save and quit
<leader>/           " Clear search highlighting
```

### File Management
```vim
<leader>p           " Find files in project
<leader>f           " Live grep (search text in files)
<leader>b           " Find buffers
<leader>hr          " Recent files history
<leader>e           " Toggle file tree
```

### Navigation & Movement
```vim
Ctrl+h/j/k/l        " Move between splits
j/k                 " Move by visual lines
n/N                 " Next/previous search result (centered)
gd                  " Go to definition (LSP)
gr                  " Go to references (LSP) 
K                   " Hover documentation (LSP)
```

### Buffer Management
```vim
Tab                 " Next buffer
Shift+Tab           " Previous buffer
<leader>bd          " Delete buffer (smart)
```

### Window Management
```vim
<leader>+/-         " Resize window vertically
<leader>>/<         " Resize window horizontally
<leader>z           " Toggle maximize split
```

### Editing & Text
```vim
< >                 " Indent/unindent (visual mode, keeps selection)
gcc                 " Comment/uncomment current line
gc                  " Comment selection (visual mode)
```

### Auto-pairs (Insert Mode)
```vim
"                   " Inserts ""| (cursor between)
'                   " Inserts ''|
(                   " Inserts ()|
[                   " Inserts []|
{                   " Inserts {}|
{<CR>               " Inserts block with proper indentation
```

## 🔥 Unified Git Workflow Cheatsheet

All git operations unified under `<leader>g*` for seamless workflow progression:

### 🔍 Git Inspection & Navigation
```vim
<leader>gg          " Git status overview (diffview)
<leader>gh          " Git file history
<leader>gf          " Git files panel
<leader>gb          " Git blame current line
<leader>gp          " Preview current hunk
<leader>gn          " Next hunk with preview
<leader>gN          " Previous hunk with preview
```

### ⚡ Git Actions
```vim
<leader>gs          " Stage current hunk
<leader>gS          " Stage entire buffer
<leader>gu          " Unstage/undo hunk
<leader>gr          " Reset/discard hunk
<leader>gR          " Reset entire buffer
```

### 💬 Git Commits (3 Methods)
```vim
<leader>gc          " Quick commit (auto-generated message)
<leader>gC          " Interactive commit (manual message)
<leader>gm          " Commit with Claude-generated message
```

### 🤖 Git + Claude AI Integration
```vim
<leader>ga          " Add current hunk to Claude context
<leader>gA          " Add entire buffer to Claude context
<leader>gi          " Send hunk to Claude for explanation
<leader>gI          " Send entire diff to Claude for review
```

### 🚀 Example Workflow
```bash
# 1. Inspect your changes
<leader>gg          # Open git overview
<leader>gp          # Preview current hunk
<leader>gn          # Navigate to next hunk

# 2. Get AI assistance (optional)
<leader>ga          # Add hunk to Claude for review
<leader>gi          # Ask Claude to explain changes

# 3. Stage your changes
<leader>gs          # Stage current hunk
# OR
<leader>gS          # Stage entire buffer

# 4. Commit (choose your method)
<leader>gc          # Quick auto-commit
# OR
<leader>gC          # Interactive commit with custom message
# OR
<leader>gm          # Let Claude write your commit message
```

### Claude Code Integration
```vim
<leader>cc          " Toggle Claude Code interface
<leader>cf          " Focus Claude Code panel
<leader>cr          " Resume Claude Code session
<leader>cC          " Continue Claude Code conversation
<leader>cb          " Add current buffer to Claude context
<leader>cs          " Send visual selection to Claude (visual mode)
<leader>ca          " Accept Claude Code diff
<leader>cd          " Deny Claude Code diff
```

### Terminal Integration
```vim
Ctrl+\              " Toggle terminal (global)
<leader>tt          " Toggle terminal
<leader>tf          " Float terminal
<leader>th          " Horizontal terminal
<leader>tv          " Vertical terminal
<leader>t1-t9       " Access terminal 1-9
<Esc> or jk         " Exit terminal mode
```

### LSP Features
```vim
gd                  " Go to definition
gr                  " Go to references
K                   " Hover documentation
<leader>r           " Rename symbol
```

## 📚 Complete Keybinding Reference

### Core Navigation
```vim
Ctrl+h/j/k/l        " Navigate between splits
Alt+h/j/k/l         " Navigate tmux panes (no prefix)
Alt+1-9             " Switch tmux windows (no prefix)
Tab/Shift+Tab       " Next/previous buffer
```

### File Operations
```vim
<leader>w           " Save file
<leader>q           " Quit
<leader>x           " Save and quit
<leader>/           " Clear search highlighting
```

### File Management
```vim
<leader>f           " Find files in project (Telescope)
<leader>e           " Live grep (search text in files)
<leader>b           " Find buffers
<leader>hr          " Recent files history
<leader>p           " Toggle file tree (nvim-tree)
```

### Window Management
```vim
<leader>+/-         " Resize window vertically
<leader>>/<         " Resize window horizontally
<leader>z           " Toggle maximize split
```

### Editing & Text Manipulation
```vim
< >                 " Indent/unindent (visual mode, keeps selection)
gcc                 " Comment/uncomment current line
gc                  " Comment selection (visual mode)
<leader>sr          " Search and replace word under cursor
```

### Terminal Integration
```vim
Ctrl+\              " Toggle terminal (global)
<leader>tt          " Toggle terminal
<leader>tf          " Float terminal
<leader>th          " Horizontal terminal
<leader>tv          " Vertical terminal
<leader>t1-t9       " Access terminal 1-9
<Esc> or jk         " Exit terminal mode
```

## 🎯 Common Workflow Examples

### 🔄 Daily Development Flow
```bash
# Start your day
t project           # Smart tmux session (attach or create)
<leader>p           # Open file tree to explore
<leader>f           # Find specific file to work on

# While coding
<leader>e TODO      # Search for TODOs across project
gd                  # Go to definition
<leader>w           # Save frequently
```

### 🚀 Git Review & Commit Flow
```bash
# Review your changes
<leader>gg          # Open git status overview
<leader>gp          # Preview current hunk
<leader>gn          # Navigate through hunks

# Get AI assistance
<leader>ga          # Add hunk to Claude for review
<leader>gi          # Ask Claude to explain changes

# Stage and commit
<leader>gs          # Stage current hunk
<leader>gm          # Let Claude write commit message
```

### 🧪 Testing & Debugging Flow
```bash
# Setup workspace
<leader>th          # Open horizontal terminal for tests
<leader>tv          # Open vertical terminal for logs
Alt+h               # Navigate back to editor

# Run tests and debug
Alt+j               # Switch to test terminal
npm test            # Run your tests
Alt+k               # Switch to log terminal  
tail -f app.log     # Watch logs
Alt+h               # Back to editor to fix issues
```

### 🔍 Code Exploration Flow
```bash
# Explore unfamiliar codebase
<leader>e className # Search for class usage
gd                  # Go to definition
gr                  # See all references
<leader>f test      # Find related test files
<leader>b           # Switch between open files
```

### 🤖 AI-Assisted Development
```bash
# Get help with complex changes
<leader>ga          # Add current hunk to Claude
<leader>cc          # Open Claude interface
# Describe what you want to implement
<leader>ca          # Accept Claude's suggestions
<leader>gS          # Stage the improved code
<leader>gm          # Commit with Claude-generated message
```

## Prerequisites

- **git** - Version control and repository management
- **tmux** - Terminal multiplexer for session management
- **neovim** - Text editor (>= 0.9 required)
- **curl** - Download tools and scripts
- **build-essential** - Compilation tools
- **ripgrep** - Fast text search
- **xclip** - Clipboard integration
- **just** - Task runner for automated setup

For detailed configuration see [CLAUDE.md](CLAUDE.md).