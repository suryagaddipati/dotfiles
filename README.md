# Dotfiles

Optimized configuration for bash, git, tmux, and neovim with vim-style navigation and productivity shortcuts.

## Quick Setup

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
mise run workflows:full-install    # Complete setup with dependencies
```

## Essential Commands

**Using mise tasks (recommended):**
```bash
mise run install                   # Install dotfiles with backup
mise run setup:prereqs             # Check installation status  
mise run update                    # Update from git
mise tasks                         # Show all available tasks
```

**Legacy commands (still supported):**
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

### Hyprland Window Manager
```bash
# Special Workspace (Magic)
Super+M             # Toggle magic workspace (show/hide)
Super+Shift+M       # Move active window to magic workspace

# Move window back from magic workspace:
# 1. Super+M (show magic workspace)
# 2. Focus the window you want to move
# 3. Super+Shift+[1-9] (move to desired workspace)

# Applications
Super+Return        # Terminal
Super+F             # File manager
Super+B             # Browser
Super+N             # Neovim
Super+T             # Activity monitor

# Window Management
Super+W             # Close active window
Super+V             # Toggle floating
Super+J             # Toggle split
Super+Z             # Toggle fullscreen

# Vim-style Navigation
Super+h/j/k/l       # Focus window left/down/up/right
Super+Shift+h/j/k/l # Move window left/down/up/right

# Workspace Management
Super+[1-9]         # Switch to workspace 1-9
Super+Shift+[1-9]   # Move window to workspace 1-9
Super+Tab           # Next workspace
Super+Shift+Tab     # Previous workspace
```

### Tmux (Prefix: Ctrl-Space)

#### Tmux Hierarchy Structure
```
Prefix → category → action
Example: Ctrl-Space → pane → split
```

#### 🖼️ Pane Operations (`Ctrl-Space p*` / Direct)
```bash
Ctrl-Space s        # Split pane horizontally
Ctrl-Space v        # Split pane vertically  
Ctrl-Space |        # Split pane horizontally (alt)
Ctrl-Space -        # Split pane vertically (alt)
Ctrl-Space x        # Kill/close pane
Ctrl-Space z        # Toggle pane zoom (fullscreen)
Ctrl-Space !        # Break pane to new window
Ctrl-Space f        # Find pane

# Pane Navigation (No Prefix)
Alt+h/j/k/l         # Navigate panes instantly
Ctrl-Space h/j/k/l  # Navigate panes (with prefix)
Ctrl-Space o        # Cycle through panes
Ctrl-Space q        # Show pane numbers

# Pane Resizing
Ctrl-Space H/J/K/L  # Resize panes (hold Shift)
Ctrl-Space Alt+h/j/k/l # Resize panes (fine control)
```

#### 🪟 Window Operations (`Ctrl-Space w*` / Direct)
```bash
Ctrl-Space c        # Create new window
Ctrl-Space n        # Next window
Ctrl-Space p        # Previous window
Ctrl-Space l        # Last window
Ctrl-Space ,        # Rename window
Ctrl-Space &        # Kill window
Ctrl-Space w        # List windows

# Window Navigation (No Prefix)
Alt+1-9             # Switch to window 1-9 instantly
Ctrl-Space 1-9      # Switch to window 1-9 (with prefix)

# Window Arrangement
Ctrl-Space <        # Move window left
Ctrl-Space >        # Move window right
```

#### 🎯 Session Operations (`Ctrl-Space s*` / Direct)
```bash
Ctrl-Space S        # Create new session (prompted for name)
Ctrl-Space R        # Rename current session
Ctrl-Space N        # New session in current directory
Ctrl-Space $        # Rename session
Ctrl-Space d        # Detach from session

# Session Navigation (No Prefix)
Alt+s               # Choose session (quick switcher)
Ctrl-Space s        # Choose session (with prefix)
Ctrl-Space (        # Switch to previous session
Ctrl-Space )        # Switch to next session
```

#### 📋 Copy/Paste Operations (`Ctrl-Space c*`)
```bash
Ctrl-Space Enter    # Enter copy mode
Ctrl-Space [        # Enter copy mode (alt)
Ctrl-Space ]        # Paste from buffer
Ctrl-Space P        # Paste from buffer (alt)
Ctrl-Space b        # List paste buffers
Ctrl-Space B        # Delete buffer

# Copy Mode Bindings (Vim-style)
v                   # Begin selection
y                   # Copy selection to clipboard
r                   # Rectangle selection toggle
```

#### ⚙️ System Operations (`Ctrl-Space r*`)
```bash
Ctrl-Space r        # Reload tmux config
Ctrl-Space :        # Command prompt
Ctrl-Space ?        # Show key bindings
Ctrl-Space t        # Show time
F12                 # Toggle nested tmux mode (SSH)
```

## Neovim Shortcuts (Leader: Space)

### Core Hierarchy Structure
```
<leader> → category → subcategory → action
Example: <leader>gh → git hunk → action
```

### 📁 File Operations (`<leader>f*`)
```vim
<leader>ff          " Find files in project (Telescope)
<leader>fg          " Live grep (search text in files)
<leader>fb          " Find buffers
<leader>fh          " Recent files history
<leader>fe          " Toggle file explorer (nvim-tree)
<leader>fw          " Save file (write)
<leader>fq          " Quit file
<leader>fx          " Save and quit
<leader>f/          " Clear search highlighting
```

### 🔍 Search Operations (`<leader>s*`)
```vim
<leader>sf          " Search files (alias for <leader>ff)
<leader>sg          " Search in files (live grep)
<leader>sb          " Search buffers
<leader>sh          " Search history
<leader>sc          " Clear search highlight
```

### 🪟 Window Management (`<leader>w*`)
```vim
<leader>wh/j/k/l    " Navigate to window (left/down/up/right)
<leader>ws          " Split window horizontally
<leader>wv          " Split window vertically
<leader>wc          " Close window
<leader>wo          " Close other windows
<leader>w=          " Equalize window sizes
<leader>wz          " Toggle maximize current window
<leader>w+/-        " Resize window vertically
<leader>w>/<        " Resize window horizontally
```

### 📄 Buffer Management (`<leader>b*`)
```vim
<leader>bb          " List buffers (Telescope)
<leader>bn          " Next buffer
<leader>bp          " Previous buffer
<leader>bd          " Delete buffer
<leader>bD          " Force delete buffer
<leader>ba          " Add new buffer
<leader>bl          " List all buffers
Tab                 " Next buffer (shortcut)
Shift+Tab           " Previous buffer (shortcut)
```

### 🎨 Git Operations (`<leader>g*`)
#### Git Status & Navigation (`<leader>g*`)
```vim
<leader>gg          " Git status overview (diffview)
<leader>gf          " Git files panel
<leader>gH          " Git file history
<leader>gb          " Git blame current line
```

#### Git Hunk Operations (`<leader>gh*`)
```vim
<leader>ghp         " Preview git hunk
<leader>ghn         " Next hunk with preview
<leader>ghN         " Previous hunk with preview
<leader>ghs         " Stage current hunk
<leader>ghS         " Stage entire buffer
<leader>ghu         " Unstage/undo hunk
<leader>ghr         " Reset/discard hunk
<leader>ghR         " Reset entire buffer
<leader>ghd         " Discard git hunk (alias for reset)
```

#### Git Commit Operations (`<leader>gc*`)
```vim
<leader>gcc         " Quick commit (auto-generated message)
<leader>gcm         " Interactive commit (manual message)
<leader>gca         " Commit with Claude-generated message
```

#### Git + Claude Integration (`<leader>ga*`)
```vim
<leader>gah         " Add current hunk to Claude context
<leader>gab         " Add entire buffer to Claude context
<leader>gai         " Send hunk to Claude for explanation
<leader>gaI         " Send entire diff to Claude for review
```

### 🤖 Claude Code Integration (`<leader>c*`)
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

### 💻 Terminal Operations (`<leader>t*`)
```vim
<leader>tt          " Toggle terminal
<leader>tf          " Float terminal
<leader>th          " Horizontal terminal
<leader>tv          " Vertical terminal
<leader>tc          " Close terminal
<leader>tn          " New terminal
<leader>t1-t9       " Access terminal 1-9
Ctrl+\              " Toggle terminal (global shortcut)
```

### 🔧 LSP Operations (`<leader>l*`)
```vim
<leader>ld          " Go to definition (also: gd)
<leader>lr          " Go to references (also: gr)
<leader>lh          " Hover documentation (also: K)
<leader>ls          " LSP symbols (document)
<leader>lS          " LSP symbols (workspace)
<leader>lf          " Format document
<leader>la          " Code actions
<leader>lr          " Rename symbol
<leader>le          " Show line diagnostics
<leader>ln          " Next diagnostic
<leader>lp          " Previous diagnostic
```

### ✏️ Edit Operations (`<leader>e*`)
```vim
<leader>ec          " Comment/uncomment line (also: gcc)
<leader>eC          " Comment selection (visual mode, also: gc)
<leader>ei          " Indent selection (visual mode)
<leader>eI          " Unindent selection (visual mode)
<leader>er          " Search and replace word under cursor
<leader>eR          " Search and replace in file
<leader>ef          " Format selection/document
```

### Navigation & Movement (No Leader)
```vim
Ctrl+h/j/k/l        " Move between splits
j/k                 " Move by visual lines
n/N                 " Next/previous search result (centered)
gd                  " Go to definition (LSP)
gr                  " Go to references (LSP) 
K                   " Hover documentation (LSP)
< >                 " Indent/unindent (visual mode, keeps selection)
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

### 🚀 Example Workflow (Using Mnemonic Hierarchy)
```bash
# 1. Inspect your changes (git → status/navigation)
<leader>gg          # git status overview
<leader>ghp         # git hunk preview
<leader>ghn         # git hunk next

# 2. Get AI assistance (git → ai integration)
<leader>gah         # git ai hunk (add to Claude)
<leader>gai         # git ai inspect (explain hunk)

# 3. Stage your changes (git → hunk → stage)
<leader>ghs         # git hunk stage
# OR
<leader>ghS         # git hunk Stage (entire buffer)

# 4. Commit (git → commit → method)
<leader>gcc         # git commit quick
# OR
<leader>gcm         # git commit manual
# OR
<leader>gca         # git commit ai (Claude-generated)
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

## 🎯 Common Workflow Examples (Mnemonic Hierarchy)

### 🔄 Daily Development Flow
```bash
# Start your day
t project           # Smart tmux session (attach or create)
<leader>fe          # file explorer (toggle tree)
<leader>ff          # file find (specific file)

# While coding
<leader>sg TODO     # search grep (TODOs across project)
<leader>ld          # lsp definition (go to)
<leader>fw          # file write (save frequently)
```

### 🚀 Git Review & Commit Flow
```bash
# Review your changes (git → status/navigation)
<leader>gg          # git status (overview)
<leader>ghp         # git hunk preview
<leader>ghn         # git hunk next

# Get AI assistance (git → ai integration)
<leader>gah         # git ai hunk (add to Claude)
<leader>gai         # git ai inspect (explain changes)

# Stage and commit (git → hunk → stage, git → commit)
<leader>ghs         # git hunk stage
<leader>gca         # git commit ai (Claude message)
```

### 🧪 Testing & Debugging Flow
```bash
# Setup workspace (terminal operations)
<leader>th          # terminal horizontal (for tests)
<leader>tv          # terminal vertical (for logs)
Alt+h               # Navigate back to editor

# Run tests and debug (tmux navigation)
Alt+j               # Switch to test terminal
npm test            # Run your tests
Alt+k               # Switch to log terminal  
tail -f app.log     # Watch logs
Alt+h               # Back to editor to fix issues
```

### 🔍 Code Exploration Flow
```bash
# Explore unfamiliar codebase (search → lsp)
<leader>sg className # search grep (class usage)
<leader>ld          # lsp definition (go to)
<leader>lr          # lsp references (see all)
<leader>ff test     # file find (related test files)
<leader>bb          # buffer browse (switch between open)
```

### 🤖 AI-Assisted Development Flow
```bash
# Get help with complex changes (claude integration)
<leader>gah         # git ai hunk (add to Claude)
<leader>cc          # claude code (open interface)
# Describe what you want to implement
<leader>ca          # claude accept (suggestions)
<leader>ghS         # git hunk Stage (improved code)
<leader>gca         # git commit ai (Claude message)
```

### 🎹 Mnemonic Memory Aids
```bash
# File operations: <leader>f*
ff = file find, fg = file grep, fw = file write, fe = file explorer

# Search operations: <leader>s*  
sf = search files, sg = search grep, sb = search buffers

# Git operations: <leader>g*
gg = git status, gh* = git hunk, gc* = git commit, ga* = git ai

# Window operations: <leader>w*
ws = window split, wv = window vertical, wz = window zoom

# Buffer operations: <leader>b*
bb = buffer browse, bn = buffer next, bd = buffer delete

# Terminal operations: <leader>t*
tt = terminal toggle, th = terminal horizontal, tv = terminal vertical

# LSP operations: <leader>l*
ld = lsp definition, lr = lsp references, lh = lsp hover

# Claude operations: <leader>c*
cc = claude code, cf = claude focus, ca = claude accept
```

## Installation Tasks

All tasks are organized using mise's file-based task system for better maintainability:

### Setup Tasks
```bash
mise run setup:prereqs             # Check prerequisites 
mise run setup:tmux                # Setup tmux plugin manager
mise run setup:claude              # Setup Claude configuration
```

### Dependency Installation
```bash
mise run deps:install              # Install system dependencies
mise run deps:install-mise         # Install mise tool manager
mise run deps:install-tools        # Install mise tools (tmux, nvim, etc.)
mise run deps:install-dev          # Install development tools
mise run deps:install-lsp          # Install language servers
```

### Main Installation
```bash
mise run install                   # Install dotfiles with symlinking
mise run quick-install             # Alias for install
mise run uninstall                 # Remove dotfile symlinks
mise run update                    # Update from git repository
```

### Workflows
```bash
mise run workflows:default         # Show available tasks
mise run workflows:full-install    # Complete installation workflow
```

## Prerequisites

### System Requirements
- **git** - Version control and repository management
- **curl** - Download tools and scripts
- **build-essential** - Compilation tools (gcc/clang)
- **xclip** - Clipboard integration (Linux)

### Tools (Auto-installed via mise)
- **mise** - Unified tool version manager
- **tmux** - Terminal multiplexer for session management
- **neovim** - Text editor (>= 0.9 required)
- **ripgrep** - Fast text search
- **fzf** - Fuzzy finder

**Note:** Most tools are automatically installed via mise. Only basic system packages need manual installation.

For detailed configuration see [CLAUDE.md](CLAUDE.md).