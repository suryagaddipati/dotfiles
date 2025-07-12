# Dotfiles Cheatsheet

Optimized configuration for bash, git, tmux, and neovim.

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

## 🖥️ Terminal/Bash Shortcuts

```bash
# Aliases
g                   # git
t [session]         # smart tmux session (attach/create)
ll                  # detailed file listing

# Functions  
grp pattern ext1 ext2    # multi-extension grep (e.g., grp TODO js py)
tmux_smart_session       # intelligent session management

# Git aliases
git s               # status
git co              # checkout  
git b               # branch
git push            # push -u origin HEAD
```

## 🪟 Tmux Shortcuts

**Prefix: Ctrl-Space**

### Panes
```bash
Ctrl-Space s        # Split horizontal
Ctrl-Space v        # Split vertical
Ctrl-Space h/j/k/l  # Navigate panes
Alt+h/j/k/l         # Navigate panes (NO PREFIX)
Ctrl-Space f        # Zoom pane
Ctrl-Space x        # Kill pane
```

### Windows
```bash
Ctrl-Space c        # Create window
Ctrl-Space n/p      # Next/previous window
Alt+1-9             # Switch to window 1-9 (NO PREFIX)
Ctrl-Space ,        # Rename window
```

### Sessions
```bash
Ctrl-Space S        # Create new session
Alt+s               # Choose session (NO PREFIX)
Ctrl-Space R        # Rename session
```

### Copy/Paste
```bash
Ctrl-Space Enter    # Enter copy mode
v                   # Begin selection (in copy mode)
y                   # Copy to clipboard
Ctrl-Space P        # Paste
```

### Config
```bash
Ctrl-Space r        # Reload config
```

## ⚡ Neovim Shortcuts

**Leader: ,**

### File Operations
```bash
,w                  # Save
,q                  # Quit
,x                  # Save and quit
,/                  # Clear search highlight
```

### Navigation
```bash
Ctrl+h/j/k/l        # Navigate splits
Tab / Shift+Tab     # Next/previous buffer
,bd                 # Delete buffer
j/k                 # Move by visual lines
n/N                 # Next/previous search (centered)
```

### File Management
```bash
,f                  # Find files (Telescope)
,g                  # Live grep (search in files)
,b                  # Buffer list
,h                  # Recent files
,t                  # Toggle file tree
```

### LSP (Language Server)
```bash
gd                  # Go to definition
gr                  # Go to references  
K                   # Hover documentation
,r                  # Rename symbol
,ca                 # Code actions
```

### Editing
```bash
gcc                 # Toggle comment (line)
gc                  # Toggle comment (visual selection)
cs"'                # Change surrounding quotes
ds"                 # Delete surrounding quotes
ysiw]               # Surround word with brackets
< / >               # Indent/unindent (keeps selection)
```

### Terminal
```bash
Ctrl+\              # Toggle terminal
,tt                 # Toggle terminal
,tf                 # Float terminal
,th                 # Horizontal terminal
,tv                 # Vertical terminal
```

### Claude Code (AI)
```bash
,ac                 # Toggle Claude Code
,af                 # Focus Claude Code
,ab                 # Add current buffer to Claude
,as                 # Send selection to Claude (visual mode)
,aa                 # Accept Claude diff
,ad                 # Deny Claude diff
```

### Plugin Management
```bash
:Lazy               # Open plugin manager
:Lazy sync          # Install/update/clean plugins
```

## Requirements

```bash
sudo apt install git tmux neovim curl fzf ripgrep xclip
```

For complete documentation see [CLAUDE.md](CLAUDE.md).