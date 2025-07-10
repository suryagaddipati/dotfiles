# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing configuration files for bash, git, tmux, and neovim. The configurations are designed for a Linux development environment with productivity-focused customizations.

## Architecture and Key Insights

### Installation Strategy
- **Symlink-based architecture**: All configurations are symlinked from the repository to their target locations, enabling live editing
- **Automated via justfile**: The `just` command provides comprehensive installation, backup, and management with cross-platform support
- **Backup-first approach**: Always backs up existing configurations before installation to `~/.dotfiles_backup`
- **Dual editor support**: Both vim (.vimrc) and neovim (init.lua) configurations maintained with shared keybindings

### Integration Patterns
- **Consistent theming**: Gruvbox color scheme unified across tmux, vim, and neovim
- **Unified key bindings**: Vim-style navigation throughout (tmux panes, neovim splits, Alt+hjkl shortcuts)
- **Smart session management**: Intelligent tmux session attachment/creation via `t` alias and `tmux_smart_session` function
- **Multi-extension search**: `grp` function for efficient codebase searching across file types

### Key Technical Details
- **Tmux prefix**: Ctrl-Space instead of default Ctrl-B (critical for avoiding conflicts)
- **Neovim leader**: Comma (,) for all custom mappings
- **Plugin managers**: lazy.nvim (neovim), vim-plug (vim) with auto-installation
- **Development tools**: NVM (Node.js), SDKMAN (Java), integrated package managers
- **Cross-platform support**: Justfile detects and uses appropriate package manager (apt/brew/yum)

## File Structure

- `.bashrc` - Bash shell configuration with aliases, functions, and environment setup
- `.gitconfig` - Git configuration with user settings and aliases  
- `.tmux.conf` - Comprehensive tmux configuration with custom key bindings and appearance
- `init.lua` - Modern neovim configuration with lua-based plugins and custom mappings
- `tmux.bash` - Tmux session management wrapper function
- `justfile` - Automated installation and management system

## Key Configuration Details

### Bash Configuration
- Uses `g` alias for git commands
- `t` alias maps to `tmux_smart_session` function for intelligent tmux session management
- NVM and SDKMAN integration for Node.js and Java development
- Custom `tmux_smart_session()` function for automated session attachment/creation
- `grp()` function for multi-extension grep searches (e.g., `grp TODO js ts py`)

### Git Configuration
- Email: meowlicious99@gmail.com, Name: Surya G  
- GitHub CLI integration for credential management
- Useful aliases: `s` (status), `co` (checkout), `b` (branch)
- Auto-push to origin HEAD with `-u` flag

### Tmux Configuration
- **Prefix key changed from Ctrl-B to Ctrl-Space**
- Vim-style navigation (h/j/k/l for panes)
- Custom color scheme (gruvbox-inspired)
- Mouse support enabled
- Comprehensive key bindings for window/pane/session management
- Alt+number shortcuts for quick window switching
- F12 for nested tmux session support

### Neovim Configuration
- Leader key: comma (,)
- Modern plugin setup using lazy.nvim
- Gruvbox color scheme with true color support
- nvim-tree file explorer with git status integration
- Telescope fuzzy finder integration
- Built-in LSP with completion via nvim-cmp
- Treesitter for advanced syntax highlighting
- Auto-pairs for bracket/quote completion
- Comprehensive key mappings for productivity

## Essential Commands for Development

### Installation and Management (using justfile)
```bash
# Primary installation commands
just install           # Install dotfiles with automatic backup
just full-install      # Complete setup: dependencies + dotfiles + dev tools
just quick-install     # Same as 'just install' (backup + install)

# Dependency management
just install-deps      # Install system dependencies (git, tmux, neovim, etc.)
just install-dev       # Install development tools (NVM, SDKMAN)

# Status and maintenance
just status            # Show detailed installation status and health check
just backup            # Create backup of existing config files
just restore           # Restore from backup
just update            # Pull latest changes from git repository
just uninstall         # Remove dotfile symlinks (preserves backups)
just clean             # Remove backups and plugin directories

# Specialized setup
just setup-nvim        # Setup neovim configuration and install plugins
just check-nvim        # Verify neovim installation
```

### Core Architecture Commands
The justfile provides a comprehensive automation layer that:
- **Automatically backs up** existing configs before installation
- **Creates proper symlinks** from repository to home directory locations
- **Handles cross-platform** package management (apt/brew/yum)
- **Manages neovim plugins** via lazy.nvim bootstrap
- **Provides color-coded status** reporting

### Tmux Session Management
```bash
# Smart session function (available as alias 't')
tmux_smart_session [session-name]

# Tmux wrapper function
tm session-name [window-name]
```

### Neovim Plugin Management
```vim
:Lazy           # Open plugin manager
:Lazy sync      # Install/update/clean plugins
:Lazy install   # Install plugins
:Lazy update    # Update plugins
:Lazy clean     # Remove unused plugins
```

### Key Tmux Bindings (Prefix: Ctrl-Space)
- `Ctrl-Space |` - Split horizontally
- `Ctrl-Space -` - Split vertically  
- `Ctrl-Space h/j/k/l` - Navigate panes
- `Alt+h/j/k/l` - Navigate panes (no prefix)
- `Alt+1-9` - Switch to window 1-9
- `Ctrl-Space r` - Reload config

### Key Neovim Bindings (Leader: ,)
- `,t` - Toggle nvim-tree
- `,f` - Find files (Telescope)
- `,g` - Live grep (Telescope)
- `,w` - Save file
- `,q` - Quit
- `Ctrl+h/j/k/l` - Navigate splits

## Installation

### Prerequisites
```bash
# Essential tools
sudo apt update && sudo apt install -y git tmux neovim curl build-essential

# For neovim fuzzy finding and features
sudo apt install -y fzf ripgrep xclip

# For better terminal experience
sudo apt install -y xclip  # clipboard integration
```

### Setup Instructions
**Recommended:** Use the automated justfile approach for safe, comprehensive installation:

```bash
# Clone repository
git clone https://github.com/username/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Full automated installation (recommended)
just full-install     # Installs deps + dotfiles + dev tools + backups existing configs

# Or step-by-step installation
just install-deps     # Install system dependencies
just install          # Install dotfiles with automatic backup
just install-dev      # Install development tools (NVM, SDKMAN)
```

**Manual installation** (if justfile unavailable):
```bash
# 1. Backup existing configs (justfile does this automatically)
mkdir -p ~/.dotfiles_backup
cp ~/.bashrc ~/.dotfiles_backup/bashrc.backup 2>/dev/null || true
cp ~/.gitconfig ~/.dotfiles_backup/gitconfig.backup 2>/dev/null || true
cp ~/.tmux.conf ~/.dotfiles_backup/tmux.conf.backup 2>/dev/null || true

# 2. Create symlinks
ln -sf ~/dotfiles/.bashrc ~/.bashrc
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
mkdir -p ~/.config/nvim
ln -sf ~/dotfiles/init.lua ~/.config/nvim/init.lua

# 3. Reload shell
source ~/.bashrc
```

**Post-installation verification:**
```bash
just status            # Check installation health
nvim                   # Plugins will install automatically on first start
```

## Complete Shortcuts and Aliases Reference

### Bash Aliases and Functions
```bash
# Basic aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias g='git'                    # Git shorthand
alias t='tmux_smart_session'     # Smart tmux session

# Git aliases (from gitconfig)
git s     # git status
git co    # git checkout
git b     # git branch
git push  # git push -u origin HEAD (auto-upstream)

# Tmux functions
tmux_smart_session [name]        # Attach to existing or create new session
tm session-name [window-name]    # Advanced tmux session wrapper

# Search functions
grp pattern ext1 [ext2...]       # Multi-extension grep (e.g., grp TODO js ts py)
```

### Tmux Key Bindings (Prefix: Ctrl-Space)

#### Session Management
- `Ctrl-Space s` - List sessions
- `Ctrl-Space S` - Create new session (prompted for name)
- `Ctrl-Space R` - Rename session
- `Ctrl-Space N` - New session in current directory

#### Window Management
- `Ctrl-Space c` - Create new window
- `Ctrl-Space n` - Next window
- `Ctrl-Space p` - Previous window
- `Ctrl-Space l` - Last window
- `Ctrl-Space w` - List windows
- `Ctrl-Space ,` - Rename window
- `Ctrl-Space X` - Kill window
- `Ctrl-Space <` - Move window left
- `Ctrl-Space >` - Move window right
- `Alt+1-9` - Switch to window 1-9 (no prefix needed)

#### Pane Management
- `Ctrl-Space |` or `Ctrl-Space \` - Split horizontally
- `Ctrl-Space -` or `Ctrl-Space _` - Split vertically
- `Ctrl-Space h/j/k/l` - Navigate panes (vim-style)
- `Alt+h/j/k/l` - Navigate panes (no prefix needed)
- `Ctrl-Space H/J/K/L` - Resize panes
- `Ctrl-Space f` - Toggle pane zoom
- `Ctrl-Space x` - Kill pane
- `Ctrl-Space q` - Show pane numbers
- `Ctrl-Space space` - Next layout
- `Ctrl-Space o` - Rotate panes
- `Ctrl-Space a` - Toggle pane synchronization
- `Ctrl-Space @` - Join pane from window
- `Ctrl-Space !` - Break pane to window

#### Copy Mode and Clipboard
- `Ctrl-Space Enter` - Enter copy mode
- `v` - Begin selection (in copy mode)
- `y` - Copy selection to clipboard
- `r` - Rectangle selection toggle
- `Ctrl-Space P` - Paste from buffer
- `Ctrl-Space b` - List paste buffers
- `Ctrl-Space B` - Delete buffer

#### Miscellaneous
- `Ctrl-Space r` - Reload tmux config
- `Ctrl-Space C-l` - Clear screen
- `Ctrl-Space C-k` - Clear screen and history
- `Ctrl-Space /` - Search in copy mode
- `F12` - Toggle nested tmux mode (for SSH sessions)

### Neovim Key Bindings (Leader: ,)

#### File Operations
- `,w` - Save file
- `,q` - Quit
- `,x` - Save and quit
- `,Q` - Force quit without saving
- `,ev` - Edit init.lua
- `,sv` - Source/reload init.lua

#### File Explorer (nvim-tree)
- `,t` - Toggle nvim-tree
- `,nf` - Find current file in nvim-tree
- `l` - Open file/expand directory (in nvim-tree)
- `h` - Close directory (in nvim-tree)

#### File Finding (Telescope)
- `,f` - Find files in project
- `,F` - Find git files
- `,g` - Live grep (search text in files)
- `,l` - Search current buffer
- `,h` - Recent files history
- `,hf` - Command history
- `,hs` - Search history
- `,b` - Find buffers

#### Navigation
- `Ctrl+h/j/k/l` - Move between splits
- `,e` - File explorer (netrw fallback)
- `j/k` - Move by visual lines (not actual lines)
- `n/N` - Next/previous search result (centered)

#### Window and Split Management
- `,+/-` - Resize window vertically
- `,>/<` - Resize window horizontally

#### Buffer Management
- `,b` - List buffers
- `,bn` - Next buffer
- `,bp` - Previous buffer
- `,bd` - Delete buffer (smart - keeps window open)
- `Tab` - Next buffer
- `Shift+Tab` - Previous buffer

#### Tab Management
- `,tn` - New tab
- `,tc` - Close tab
- `,to` - Close other tabs
- `,tm` - Move tab (prompted for position)

#### Toggles and Display
- `,n` - Toggle line numbers
- `,r` - Toggle relative line numbers
- `,p` - Toggle paste mode
- `,/` - Clear search highlighting

#### Editing and Text Manipulation
- `Space` - Toggle fold
- `</> (visual mode)` - Indent/unindent and keep selection
- `,S` - Find and replace word under cursor
- `,nf` - Create new file in current directory

#### Quick Fix and Location List
- `,co` - Open quickfix list
- `,cc` - Close quickfix list
- `,cn` - Next quickfix item
- `,cp` - Previous quickfix item

#### Auto-pairs (Insert Mode)
- `"` - Inserts `""|` (cursor between quotes)
- `'` - Inserts `''|`
- `(` - Inserts `()|`
- `[` - Inserts `[]|`
- `{` - Inserts `{}|`
- `{<CR>` - Inserts block with proper indentation

#### LSP Features (when available)
- `gd` - Go to definition
- `gr` - Go to references
- `K` - Hover documentation
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions

### Language-Specific Settings
- **Python**: 4-space indentation, flake8/pylint linting, black/isort formatting
- **JavaScript/TypeScript**: 2-space indentation, eslint linting, prettier formatting
- **HTML/CSS/SCSS**: 2-space indentation
- **Go**: 4-space indentation, no tab expansion
- **YAML**: 2-space indentation


## Repository Management

### Common Git Commands for Dotfiles
```bash
# Quick status check
g s                    # git status (using alias)

# Add and commit changes
git add .bashrc init.lua .tmux.conf .gitconfig
git commit -m "update configs"

# Push with upstream tracking
g push                 # git push -u origin HEAD (using alias)

# Check what's different
git diff               # see unstaged changes
git diff --staged      # see staged changes
```

### Backup and Sync
The repository uses actual dotfiles (.bashrc, .gitconfig, etc.) and init.lua that can be directly symlinked. When making changes:

1. Edit files in the repository
2. Changes are automatically reflected in your shell/neovim (since they're symlinked)
3. For neovim config changes, restart neovim or run `:source ~/.config/nvim/init.lua`
4. Commit changes to track your configuration evolution
5. Push to keep configurations synchronized across machines

## AI Assistant Guidelines

### Essential Commands for Development
- **Always use `just` for installation tasks**: `just install`, `just status`, `just backup`
- **Check installation status first**: Run `just status` before making changes to verify setup
- **Respect the symlink architecture**: Edit files in the repository, not in home directory (changes reflect immediately)
- **Use the smart session function**: `t session-name` for tmux management
- **Leverage the grp function**: `grp pattern ext1 ext2` for efficient code searching across file types

### Critical System Details
- **Tmux prefix**: Ctrl-Space - not Ctrl-B or backtick (this is a key difference from defaults)
- **Neovim leader**: Comma (,) for all custom mappings
- **Alt+h/j/k/l**: Navigate tmux panes without prefix (works system-wide)
- **Alt+1-9**: Switch tmux windows without prefix (instant window switching)

### Common Workflow Patterns
1. **Installation**: `just install` (handles backup automatically, safe to run)
2. **Status check**: `just status` (shows detailed installation health and symlink status)
3. **Config editing**: Edit files in repository, changes reflect immediately via symlinks
4. **Session management**: Use `t session-name` for intelligent tmux sessions (attaches if exists, creates if not)
5. **Code searching**: Use `grp pattern js ts py` for multi-extension searches with ripgrep
6. **Plugin management**: Neovim plugins auto-install on first startup via lazy.nvim bootstrap

## Plugin Documentation

### Vim Plugins (.vimrc)

#### Essential Functionality
**tpope/vim-sensible** - Sensible defaults
- Auto-enabled, provides better default settings

**tpope/vim-surround** - Surround text with quotes/brackets
```vim
cs"'        " Change surrounding " to '
cs'<q>      " Change ' to <q></q>
cst"        " Change surrounding tag to "
ds"         " Delete surrounding "
ysiw]       " Surround inner word with []
yss)        " Surround entire line with ()
S]          " Surround selection with [] (visual mode)
```

**tpope/vim-commentary** - Toggle comments
```vim
gcc         " Comment/uncomment current line
gc<motion>  " Comment motion (e.g., gcap for paragraph)
gc          " Comment selection (visual mode)
```

**tpope/vim-fugitive** - Git integration
```vim
:Git status " or :G - Git status
:Git add .  " Stage files
:Git commit " Commit
:Git push   " Push
:Git blame  " Git blame
:Gdiff      " Git diff in split
```

#### File Management
**preservim/nerdtree** - File explorer
```vim
,t          " Toggle NERDTree
,nf         " Find current file in tree
# In NERDTree:
l           " Open file/expand folder
h           " Close folder
r           " Refresh folder
R           " Refresh root
m           " Menu (create/delete/rename)
I           " Toggle hidden files
```

**junegunn/fzf.vim** - Fuzzy finder
```vim
,f          " Find files
,F          " Find git files
,g          " Live grep (search in files)
,l          " Search current buffer
,h          " Recent files
,b          " Find buffers
:Files      " File picker
:Rg         " Ripgrep search
:History    " Command history
```

#### Language Support
**sheerun/vim-polyglot** - Language pack
- Auto syntax highlighting for 100+ languages

**dense-analysis/ale** - Linting and fixing
```vim
]a          " Next error
[a          " Previous error
:ALEFix     " Fix current file
:ALEInfo    " Show linter info
```

#### Appearance
**vim-airline/vim-airline** - Status line
- Shows mode, file info, git branch, errors

**morhetz/gruvbox** - Color scheme
```vim
:colorscheme gruvbox
```

#### Productivity
**jiangmiao/auto-pairs** - Auto-close brackets
```vim
"           " Types ""| (cursor between)
(           " Types ()| 
{<Enter>    " Types {<newline>|<newline>}
```

**SirVer/ultisnips** - Snippets
```vim
<Tab>       " Expand snippet
<C-j>       " Next placeholder
<C-k>       " Previous placeholder
```

**mhinz/vim-startify** - Start screen
- Shows recent files, sessions, bookmarks

### Neovim Plugins (init.lua)

#### File Management
**nvim-telescope/telescope.nvim** - Fuzzy finder
```lua
,f          -- Find files
,F          -- Find git files  
,g          -- Live grep
,l          -- Search current buffer
,h          -- Recent files
,b          -- Find buffers
<C-h>       -- Help (in telescope)
```

**nvim-tree/nvim-tree.lua** - File explorer
```lua
,t          -- Toggle file tree
,nf         -- Find current file in tree
# In nvim-tree:
l           -- Open file/expand
h           -- Close folder
a           -- Create file/folder
r           -- Rename
d           -- Delete
c           -- Copy
x           -- Cut
p           -- Paste
R           -- Refresh
```

#### Language Support
**nvim-treesitter/nvim-treesitter** - Advanced syntax
- Better highlighting, indentation, text objects
- Auto-installs parsers for: lua, python, javascript, typescript, html, css, json, yaml, bash

**neovim/nvim-lspconfig** - Language servers
```lua
gd          -- Go to definition
gr          -- Go to references
K           -- Hover documentation
<leader>rn  -- Rename symbol
<leader>ca  -- Code actions
```

**hrsh7th/nvim-cmp** - Completion engine
```lua
<C-Space>   -- Trigger completion
<CR>        -- Confirm selection
<C-b>       -- Scroll docs up
<C-f>       -- Scroll docs down
<C-e>       -- Abort completion
```

#### Git Integration
**lewis6991/gitsigns.nvim** - Git signs in gutter
- Shows added/modified/deleted lines
- Auto-enabled

#### Appearance
**nvim-lualine/lualine.nvim** - Status line
- Modern statusline with gruvbox theme

**goolord/alpha-nvim** - Dashboard
- Shows ASCII art and quick actions on startup

#### Productivity
**windwp/nvim-autopairs** - Auto-close brackets
```lua
"           -- Types ""| (cursor between)
(           -- Types ()|
{<Enter>    -- Types {<newline>|<newline>}
```

### Plugin Management Commands

#### Vim (vim-plug)
```vim
:PlugInstall    " Install plugins
:PlugUpdate     " Update plugins
:PlugClean      " Remove unused plugins
:PlugStatus     " Check plugin status
```

#### Neovim (lazy.nvim)
```vim
:Lazy           " Open plugin manager
:Lazy install   " Install plugins
:Lazy update    " Update plugins
:Lazy clean     " Remove unused plugins
:Lazy sync      " Install + update + clean
```

## 🥷 Tmux + Neovim Synergy - The Ninja's Secret Weapon

### Core Philosophy: One Mind, Many Contexts
This configuration creates a unified workspace where tmux provides **structure** and neovim provides **intelligence**, bound together by consistent vim-style navigation that becomes pure muscle memory.

### 🔥 Unified Navigation System

#### The Navigation Trinity
```bash
# System-wide vim-style movement (no cognitive switching)
Tmux panes:     Ctrl-Space h/j/k/l  (with prefix)
Alt shortcuts:  Alt+h/j/k/l         (no prefix, works everywhere)
Neovim splits:  Ctrl+h/j/k/l        (no prefix, same pattern)

# Result: Your fingers know exactly where to go, always
```

#### Instant Context Switching
```bash
# The ninja's movement pattern:
Alt+h/j/k/l     → Navigate between tmux panes instantly  
Alt+1/2/3       → Switch tmux windows (projects) instantly
Tab/Shift+Tab   → Cycle neovim buffers (files) instantly
```

### 🎯 Power Workflow Patterns

#### Pattern 1: The Development Trinity
```
┌─────────────────┬─────────────────┐
│     NEOVIM      │    TERMINAL     │
│   (code edit)   │  (git, build)   │
│  ,f ,g ,t       │  g s, g push    │
│  gd gr K        │  just status    │
├─────────────────┴─────────────────┤
│          TEST/DEBUG PANE          │
│     (test runners, logs, REPL)    │
│        npm test, pytest           │
└───────────────────────────────────┘

# Navigation flow:
Edit code → Alt+l → Git commands → Alt+j → Check tests → Alt+h → Back to code
```

#### Pattern 2: Multi-Project Ninja
```bash
# Smart session management with the 't' command:
t frontend      # Attach/create frontend project session
t backend       # Attach/create backend project session  
t infra         # Attach/create infrastructure session

# Instant project switching:
Alt+1          # Frontend window
Alt+2          # Backend window  
Alt+3          # Infrastructure window
```

### 🚀 Synergy Examples

#### Example 1: Code-Test-Debug Cycle
```bash
# Working in neovim on main.py
,w             # Save file (neovim)
Alt+l          # Move to terminal pane (tmux)
pytest tests/  # Run tests
Alt+j          # Move to log pane (tmux)
tail -f app.log # Watch logs
Alt+h          # Back to neovim (tmux)
,f             # Find failing test file (neovim telescope)
gd             # Go to definition (neovim LSP)
# Fix bug, repeat cycle instantly
```

#### Example 2: Git Workflow Integration
```bash
# Editing multiple files in neovim
,f             # Find files (telescope)
,g TODO        # Search for TODOs across project
Tab            # Next buffer (neovim)
,w             # Save current file
Alt+l          # Switch to terminal pane
g s            # Git status (bash alias)
g add .        # Stage changes  
g commit -m "fix: resolve TODO items"
Alt+h          # Back to neovim - no interruption to flow
```

#### Example 3: Research & Implementation
```bash
# Window layout for complex features:
Alt+1          # Editor window (neovim with code)
Alt+2          # Research window (browser, man pages)
Alt+3          # Testing window (REPL, test runner)

# Flow:
Alt+2 → Research API docs
Alt+1 → Implement feature
Alt+3 → Test in REPL  
Alt+1 → Refine code
Alt+3 → Run full test suite
```

### 🔧 Technical Integration Points

#### Shared Clipboard System
```bash
# Seamless copy/paste across tools:
Tmux copy mode: 'y' → system clipboard (xclip)
Neovim:        clipboard='unnamedplus' → same clipboard
Result:        Copy in tmux, paste in nvim (and vice versa)
```

#### Color Scheme Harmony
```bash
# Visual consistency eliminates cognitive load:
Tmux:    Gruvbox color scheme in status bar and panes
Neovim:  Same gruvbox theme for editor and UI
Result:  No jarring visual transitions between contexts
```

#### Process Persistence & Performance
```bash
# Efficiency through persistence:
Tmux sessions:    Keep processes alive across disconnects
Neovim buffers:   Maintain undo history and LSP connections
Result:           Zero startup time, persistent state
```

### 🎨 Advanced Workflow Techniques

#### The File Management Flow
```bash
# Multiple ways to navigate files, choose by context:
,f             # Quick file find (telescope) - when you know the name
,t             # File tree (nvim-tree) - when browsing structure
Alt+2          # Dedicated file manager window (ranger) - for operations
```

#### Session Resurrection Pattern
```bash
# Morning startup routine:
t project1     # Attach to yesterday's session
# Everything exactly as you left it:
# - Neovim with files open, undo history intact
# - Terminal with command history  
# - Test pane with last output
# Zero setup time, instant productivity
```

#### The Debugging Powerhouse
```bash
# Debugging layout:
Main pane:     Neovim with code, LSP providing context
Right pane:    Debugger (pdb, gdb, node inspect)  
Bottom pane:   Application output/logs
# Navigate with Alt+hjkl while maintaining all contexts
```

### ⚡ Performance Benefits

#### Memory Efficiency
- **Single tmux daemon**: Manages multiple long-running processes
- **Persistent neovim**: No repeated startup costs
- **Shared LSP servers**: Language intelligence stays loaded

#### CPU Efficiency  
- **Lazy plugin loading**: Neovim only loads what you need
- **Process reuse**: Terminal tools stay warm in tmux panes
- **Smart caching**: Telescope caches, LSP maintains project index

#### I/O Efficiency
- **Persistent connections**: Git, SSH, database connections survive
- **File system caching**: Recently accessed files stay in buffer cache
- **Background processing**: Tests, builds run in background panes

### 🥷 The Ninja Advantage

**Why this combination creates terminal mastery:**

1. **Zero Friction**: Moving between contexts feels like moving within a single application
2. **Muscle Memory**: Same navigation patterns work everywhere
3. **Persistent State**: Never lose your place, context, or mental model
4. **Visual Harmony**: Consistent theming reduces cognitive load
5. **Keyboard Flow**: Hands never leave home row, no mouse needed
6. **Scalable Complexity**: Handle multiple projects without losing focus

**The result**: A development environment that feels like an extension of your mind, where technical tools disappear and you focus purely on creating.