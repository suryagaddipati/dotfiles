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
<Space>w            " Save file
<Space>q            " Quit
<Space>x            " Save and quit
<Space>Q            " Force quit without saving
```

### File Management
```vim
<Space>f            " Find files in project
<Space>F            " Find git files
<Space>g            " Live grep (search text in files)
<Space>b            " Find buffers
<Space>h            " Recent files history
<Space>t            " Toggle file tree
<Space>nf           " Find current file in tree
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
<Space>bd           " Delete buffer (smart)
<Space>bn           " Next buffer
<Space>bp           " Previous buffer
```

### Tab Management
```vim
<Space>tn           " New tab
<Space>tc           " Close tab
<Space>to           " Close other tabs
<Space>tm           " Move tab
```

### Window Management
```vim
<Space>+/-          " Resize window vertically
<Space>>/<          " Resize window horizontally
```

### Editing & Text
```vim
<Space>S            " Find and replace word under cursor
<Space>/            " Clear search highlighting
<Space>n            " Toggle line numbers
<Space>r            " Toggle relative line numbers
Space               " Toggle fold
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

### Claude Code Integration
```vim
<Space>ac           " Toggle Claude Code interface
<Space>af           " Focus Claude Code panel
<Space>ar           " Resume Claude Code session
<Space>aC           " Continue Claude Code conversation
<Space>ab           " Add current buffer to Claude context
<Space>as           " Send visual selection to Claude (visual mode)
<Space>aa           " Accept Claude Code diff
<Space>ad           " Deny Claude Code diff
```

### Terminal Integration
```vim
Ctrl+\              " Toggle terminal (global)
<Space>tt           " Toggle terminal
<Space>tf           " Float terminal
<Space>th           " Horizontal terminal
<Space>tv           " Vertical terminal
```

### Quick Fix & Lists
```vim
<Space>co           " Open quickfix list
<Space>cc           " Close quickfix list
<Space>cn           " Next quickfix item
<Space>cp           " Previous quickfix item
```

### LSP Features
```vim
gd                  " Go to definition
gr                  " Go to references
K                   " Hover documentation
<Space>rn           " Rename symbol
<Space>ca           " Code actions
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