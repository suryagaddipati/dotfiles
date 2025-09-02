# CLAUDE.md

Personal dotfiles repository with modern tooling and vim-centric workflow optimizations.

## Repository Overview

Modern dotfiles configuration for Linux development with mise task management, neovim, tmux, and bash integration. Features unified vim-style navigation, automated installation via mise tasks, and comprehensive Claude Code integration.

**CRITICAL**
NEVER EVER WRITE CODE COMMENTS. DON'T EVEN THINK ABOUT IT.

**CRITICAL**
Use vim-expert when user asks to open files. ask vim-expert to open files you found.

## Architecture

### Modern Tool Management
- **mise tasks**: Replaces justfile with native mise task management system
- **Symlink architecture**: Live-editing configurations with automatic syncing
- **Cross-platform support**: Linux-focused with macOS compatibility
- **Automated installation**: One-command setup with backup system

### Integration Philosophy
- **Unified navigation**: Alt+hjkl works everywhere (tmux panes, instant switching)
- **Consistent theming**: Gruvbox/Catppuccin across all tools
- **Productivity shortcuts**: Muscle-memory based keybindings
- **Claude Code integration**: AI assistance throughout development workflow

### Key Technical Details
- **Neovim leader**: Space (for accessibility)
- **Tmux prefix**: Ctrl-Space (replaces default Ctrl-B)
- **Tool versioning**: mise for unified version management
- **Terminal**: Alacritty with Catppuccin theming
- **Session management**: Intelligent tmux session handling

## File Structure

**Core configurations:**
- `.bashrc` - Bash with aliases, functions, mise integration
- `.tmux.conf` - Tmux with vim navigation and custom shortcuts
- `.wezterm.lua` - Wezterm terminal configuration
- `.bash_profile` - Shell environment setup

**Modern architecture:**
- `.config/` - XDG Base Directory compliant configurations
  - `mise/config.toml` - Tool versions and settings
  - `alacritty/alacritty.toml` - Terminal configuration
  - `claude/` - Claude Code integration (via global config)
- `bash_functions/` - Modular bash function library
- `git-commands/` - Custom git workflow scripts
- `mise.toml` - Project-level mise configuration with tasks

**Installation system:**
- `mise.toml` - Task definitions (replaces justfile)
- Legacy `justfile` support maintained for compatibility

## Configuration Details

### Bash Configuration
- **Git alias**: `g` for all git commands
- **Session manager**: `t session-name` for intelligent tmux sessions
- **Search function**: `grp pattern ext1 ext2` for multi-extension searches
- **Tool management**: mise integration for all development tools
- **Vi mode**: Enabled for vim-style command line editing

### Tmux Configuration (Prefix: Ctrl-Space)
- **Navigation**: Alt+hjkl for instant pane switching (no prefix)
- **Window switching**: Alt+1-9 for instant window access
- **Split management**: Ctrl-Space s/v for splits
- **Session management**: Smart session creation and switching
- **Copy mode**: Vim-style with system clipboard integration

### Tool Versions (mise)
Current tool versions in `.config/mise/config.toml`:
```toml
[tools]
node = "20"
python = "3.11" 
go = "1.21"
rust = "1.75"
java = "21"
neovim = "latest"
ripgrep = "latest"
fzf = "latest"
stylua = "latest"
shfmt = "latest"
```

### Terminal (Alacritty)
- **Theme**: Catppuccin variants (mocha, frappe, latte, macchiato)
- **Font**: Modern programming font with ligature support
- **Keybindings**: Integrated with tmux and vim navigation

## Essential Commands

### Installation (mise tasks)
```bash
# Primary installation
mise run workflows:full-install    # Complete setup with all dependencies
mise run install                   # Install dotfiles with backup
mise run setup:prereqs             # Install system prerequisites

# Management
mise run update                    # Update from git repository
mise run backup                    # Backup existing configurations
mise run clean                     # Clean backups and temporary files
mise tasks                         # Show all available tasks
```

### Legacy Support (justfile)
```bash
just install        # Install with backup
just status         # Installation health check
just update         # Update from git
```

### Session Management
```bash
# Tmux smart sessions
t                   # Attach to default session or create 'main'
t project-name      # Attach to 'project-name' or create new
tm session window   # Advanced session/window management

# Session workflow
Alt+1-9            # Switch tmux windows instantly
Alt+hjkl           # Navigate panes without prefix
```

### Search and Navigation
```bash
# Multi-extension search
grp TODO js py ts           # Search for 'TODO' in .js, .py, .ts files
grp function go rs          # Search for 'function' in Go and Rust files

# Git shortcuts
g s                         # git status
g co branch-name           # git checkout
g b                        # git branch
```

## Key Bindings Reference

### System-wide Navigation
```bash
# Works everywhere - muscle memory shortcuts
Alt+h/j/k/l        # Navigate tmux panes (no prefix needed)
Alt+1-9            # Switch tmux windows (instant)
Ctrl+h/j/k/l       # Navigate neovim splits
Tab/Shift+Tab      # Cycle neovim buffers
```

### Tmux (Prefix: Ctrl-Space)
```bash
# Pane management
Ctrl-Space s       # Split horizontally
Ctrl-Space v       # Split vertically
Ctrl-Space h/j/k/l # Navigate panes (with prefix)
Ctrl-Space f       # Toggle pane zoom
Ctrl-Space x       # Kill pane

# Window management  
Ctrl-Space c       # Create window
Ctrl-Space n/p     # Next/previous window
Ctrl-Space ,       # Rename window
Ctrl-Space w       # List windows

# Session management
Ctrl-Space S       # Create new session
Ctrl-Space R       # Rename session
Alt+s              # Session switcher

# System
Ctrl-Space r       # Reload tmux config
F12                # Toggle nested tmux mode
```

### Neovim (Leader: Space)
```bash
# File operations
<Space>w           # Save file
<Space>q           # Quit
<Space>/           # Clear search highlight

# File navigation
<Space>p           # Toggle file tree
<Space>f           # Find files (Telescope)
<Space>e           # Live grep (search in files)
<Space>b           # Find buffers

# Navigation
Ctrl+h/j/k/l       # Navigate splits
Tab/Shift+Tab      # Next/previous buffer

# Terminal (ToggleTerm)
Ctrl+\             # Toggle terminal (global)
<Space>tt          # Toggle terminal
<Space>tf          # Float terminal
<Space>th/tv       # Horizontal/vertical terminal

# Git integration
<Space>gg          # Git status
<Space>gb          # Git blame
<Space>gh          # Git hunk operations
```

## Installation

### Prerequisites (Linux)
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install -y git curl build-essential

# Install mise (tool manager)
curl https://mise.run | sh
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
source ~/.bashrc
```

### Setup Process
```bash
# 1. Clone repository
git clone https://github.com/yourusername/dotfiles.git ~/code/dotfiles
cd ~/code/dotfiles

# 2. Full automated installation (recommended)
mise run workflows:full-install

# 3. Manual step-by-step (if needed)
mise run setup:prereqs        # Install prerequisites
mise run install              # Install dotfiles
```

### Verification
```bash
mise tasks                    # Show available tasks
tmux new-session -d          # Test tmux
nvim                         # Test neovim (plugins auto-install)
```

## Workflow Patterns

### Development Session Setup
```bash
# Morning routine
cd ~/code/project
t project-name               # Create/attach to project session

# Layout automatically configured:
# Window 1: Neovim (main editor)
# Window 2: Terminal (git, build, tests)
# Window 3: Monitoring (logs, system)
```

### Code-Test-Debug Cycle
```bash
# In neovim
<Space>w           # Save file
Alt+l              # Switch to terminal pane
npm test           # Run tests  
Alt+j              # Check logs pane
Alt+h              # Back to editor
<Space>e ERROR     # Search for errors
```

### Git Workflow
```bash
# Terminal workflow
g s                # Check status
g add .            # Stage changes
g commit -m "fix"  # Commit
g push             # Push with upstream

# Neovim workflow
<Space>gg          # Git status view
<Space>gh          # Stage/unstage hunks
<Space>gb          # Git blame view
```

### Multi-Project Management
```bash
# Session switching
Alt+1              # Project A window
Alt+2              # Project B window  
Alt+3              # System monitoring

# Session management
t frontend         # Switch to frontend project
t backend          # Switch to backend project
t infra           # Switch to infrastructure project
```

## AI Assistant Guidelines

### Essential Workflow Commands
- **Use mise tasks first**: `mise run install`, `mise tasks` for task discovery
- **Respect symlink architecture**: Edit repository files, changes reflect immediately
- **Smart session management**: Use `t session-name` for project contexts
- **Multi-extension search**: Use `grp pattern ext1 ext2` for code searches
- **Navigation patterns**: Alt+hjkl works system-wide for instant context switching

### Critical System Details
- **Tmux prefix changed**: Ctrl-Space (not default Ctrl-B)
- **Neovim leader**: Space (not comma or other keys)  
- **Alt shortcuts**: Work without prefix for instant navigation
- **Bash vi mode**: Enabled for vim-style command line
- **Tool management**: Everything through mise, not individual version managers

### Migration from Justfile
The repository maintains backward compatibility with justfile while transitioning to mise tasks:
- **New installations**: Use `mise run workflows:full-install`  
- **Existing installations**: `just` commands still work
- **Task discovery**: `mise tasks` shows all available operations
- **Future development**: All new automation uses mise tasks

### Development Environment Features
- **Consistent theming**: Gruvbox/Catppuccin across all tools
- **Unified clipboard**: Copy/paste works across tmux and neovim
- **Persistent sessions**: Tmux preserves context across disconnections
- **Fast startup**: Optimized configurations for minimal boot time
- **LSP integration**: Language servers with completion and navigation

### Troubleshooting Common Issues
```bash
# Check mise installation
mise --version

# Verify tool installation  
mise current

# Check symlinks
ls -la ~/.bashrc ~/.tmux.conf

# Test tmux integration
tmux list-sessions

# Neovim plugin issues
nvim +Lazy sync +q
```

The configuration prioritizes muscle memory development through consistent navigation patterns and instant context switching for maximum development efficiency.