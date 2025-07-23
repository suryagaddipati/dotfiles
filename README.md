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

### Git Integration (Gitsigns)
```vim
<leader>gb          " Git blame line
<leader>gp          " Preview git hunk
<leader>gn          " Preview next hunk
<leader>gN          " Preview previous hunk
<leader>gs          " Stage git hunk
<leader>gS          " Stage entire buffer
<leader>gu          " Undo stage hunk
<leader>gd          " Reset git hunk
<leader>gR          " Reset entire buffer
<leader>gc          " Auto-commit with AI message
<leader>gC          " Claude commit with preview
```

### Diffview Integration
```vim
<leader>dd          " Toggle diffview
<leader>dh          " File history
<leader>df          " Toggle diffview files
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