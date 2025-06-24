# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing configuration files for bash, git, tmux, and vim. The configurations are designed for a Linux development environment with productivity-focused customizations.

## File Structure

- `.bashrc` - Bash shell configuration with aliases, functions, and environment setup
- `.gitconfig` - Git configuration with user settings and aliases  
- `.tmux.conf` - Comprehensive tmux configuration with custom key bindings and appearance
- `.vimrc` - Full-featured vim configuration with plugins and custom mappings
- `tmux.bash` - Tmux session management wrapper function
- `DisableNonCountedBasicMotions.vim` - Vim plugin to enforce counted motions
- `Makefile` - Automated installation and management system

## Key Configuration Details

### Bash Configuration
- Uses `g` alias for git commands
- `t` alias maps to `tmux_smart_session` function for intelligent tmux session management
- NVM and SDKMAN integration for Node.js and Java development
- Custom `tmux_smart_session()` function for automated session attachment/creation

### Git Configuration
- Email: meowlicious99@gmail.com, Name: Surya G  
- GitHub CLI integration for credential management
- Useful aliases: `s` (status), `co` (checkout), `b` (branch)
- Auto-push to origin HEAD with `-u` flag

### Tmux Configuration
- **Prefix key changed from Ctrl-B to Ctrl-Y**
- Vim-style navigation (h/j/k/l for panes)
- Custom color scheme (gruvbox-inspired)
- Mouse support enabled
- Comprehensive key bindings for window/pane/session management
- Alt+number shortcuts for quick window switching
- F12 for nested tmux session support

### Vim Configuration
- Leader key: comma (,)
- Extensive plugin setup using vim-plug
- Gruvbox color scheme
- NERDTree file explorer with git status integration
- FZF fuzzy finder integration
- ALE for linting/fixing with language-specific settings
- Auto-pairs for bracket/quote completion
- Comprehensive key mappings for productivity

## Common Development Tasks

### Installation and Management
```bash
# Quick installation
make install

# Full installation with dependencies
make full-install

# Check status
make status

# Backup existing configs
make backup

# Update from repository
make update
```

### Tmux Session Management
```bash
# Smart session function (available as alias 't')
tmux_smart_session [session-name]

# Tmux wrapper function
tm session-name [window-name]
```

### Vim Plugin Management
```vim
:PlugInstall    # Install plugins
:PlugUpdate     # Update plugins  
:PlugClean      # Remove unused plugins
```

### Key Tmux Bindings (Prefix: Ctrl-Y)
- `Ctrl-Y |` - Split horizontally
- `Ctrl-Y -` - Split vertically  
- `Ctrl-Y h/j/k/l` - Navigate panes
- `Alt+h/j/k/l` - Navigate panes (no prefix)
- `Alt+1-9` - Switch to window 1-9
- `Ctrl-Y r` - Reload config

### Key Vim Bindings (Leader: ,)
- `,t` - Toggle NERDTree
- `,f` - Find files (FZF)
- `,g` - Search in files (ripgrep)
- `,w` - Save file
- `,q` - Quit
- `Ctrl+h/j/k/l` - Navigate splits

## Installation

### Prerequisites
```bash
# Essential tools
sudo apt update && sudo apt install -y git tmux vim curl build-essential

# For vim fuzzy finding
sudo apt install -y fzf ripgrep

# For better terminal experience
sudo apt install -y xclip  # clipboard integration
```

### Setup Instructions
1. **Clone and backup existing configs:**
   ```bash
   git clone https://github.com/username/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   
   # Backup existing configs
   cp ~/.bashrc ~/.bashrc.backup 2>/dev/null || true
   cp ~/.gitconfig ~/.gitconfig.backup 2>/dev/null || true
   cp ~/.tmux.conf ~/.tmux.conf.backup 2>/dev/null || true
   cp ~/.vimrc ~/.vimrc.backup 2>/dev/null || true
   ```

2. **Install configurations:**
   ```bash
   # Create symlinks or copy files
   ln -sf ~/dotfiles/.bashrc ~/.bashrc
   ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
   ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
   ln -sf ~/dotfiles/.vimrc ~/.vimrc
   
   # Create vim plugin directory and copy plugin
   mkdir -p ~/.vim/plugin
   cp ~/dotfiles/DisableNonCountedBasicMotions.vim ~/.vim/plugin/
   ```

3. **Install vim-plug:**
   ```bash
   curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   ```

4. **Install vim plugins:**
   ```bash
   vim +PlugInstall +qall
   ```

5. **Install NVM (Node Version Manager):**
   ```bash
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
   ```

6. **Install SDKMAN (Java/SDK Manager):**
   ```bash
   curl -s "https://get.sdkman.io" | bash
   ```

7. **Reload shell configuration:**
   ```bash
   source ~/.bashrc
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
```

### Tmux Key Bindings (Prefix: Ctrl-Y)

#### Session Management
- `Ctrl-Y s` - List sessions
- `Ctrl-Y S` - Create new session (prompted for name)
- `Ctrl-Y R` - Rename session
- `Ctrl-Y N` - New session in current directory

#### Window Management
- `Ctrl-Y c` - Create new window
- `Ctrl-Y n` - Next window
- `Ctrl-Y p` - Previous window
- `Ctrl-Y l` - Last window
- `Ctrl-Y w` - List windows
- `Ctrl-Y ,` - Rename window
- `Ctrl-Y X` - Kill window
- `Ctrl-Y <` - Move window left
- `Ctrl-Y >` - Move window right
- `Alt+1-9` - Switch to window 1-9 (no prefix needed)

#### Pane Management
- `Ctrl-Y |` or `Ctrl-Y \` - Split horizontally
- `Ctrl-Y -` or `Ctrl-Y _` - Split vertically
- `Ctrl-Y h/j/k/l` - Navigate panes (vim-style)
- `Alt+h/j/k/l` - Navigate panes (no prefix needed)
- `Ctrl-Y H/J/K/L` - Resize panes
- `Ctrl-Y f` - Toggle pane zoom
- `Ctrl-Y x` - Kill pane
- `Ctrl-Y q` - Show pane numbers
- `Ctrl-Y space` - Next layout
- `Ctrl-Y o` - Rotate panes
- `Ctrl-Y a` - Toggle pane synchronization
- `Ctrl-Y @` - Join pane from window
- `Ctrl-Y !` - Break pane to window

#### Copy Mode and Clipboard
- `Ctrl-Y Enter` - Enter copy mode
- `v` - Begin selection (in copy mode)
- `y` - Copy selection to clipboard
- `r` - Rectangle selection toggle
- `Ctrl-Y P` - Paste from buffer
- `Ctrl-Y b` - List paste buffers
- `Ctrl-Y B` - Delete buffer

#### Miscellaneous
- `Ctrl-Y r` - Reload tmux config
- `Ctrl-Y C-l` - Clear screen
- `Ctrl-Y C-k` - Clear screen and history
- `Ctrl-Y /` - Search in copy mode
- `F12` - Toggle nested tmux mode (for SSH sessions)

### Vim Key Bindings (Leader: ,)

#### File Operations
- `,w` - Save file
- `,q` - Quit
- `,x` - Save and quit
- `,Q` - Force quit without saving
- `,ev` - Edit vimrc
- `,sv` - Source/reload vimrc

#### File Explorer (NERDTree)
- `,t` - Toggle NERDTree
- `,nf` - Find current file in NERDTree
- `l` - Open file/expand directory (in NERDTree)
- `h` - Close directory (in NERDTree)

#### File Finding (FZF)
- `,f` - Find files in project
- `,F` - Find git files
- `,g` - Search text in files (ripgrep)
- `,l` - Search lines in all files
- `,bl` - Search lines in current buffer
- `,bt` - Browse tags
- `,h` - Recent files history
- `,hf` - Command history
- `,hs` - Search history

#### Navigation
- `Ctrl+h/j/k/l` - Move between splits
- `,e` - File explorer (netrw)
- `,v` - Vertical file explorer
- `,s` - Horizontal file explorer
- `j/k` - Move by visual lines (not actual lines)
- `n/N` - Next/previous search result (centered)

#### Window and Split Management
- `,+/-` - Resize window vertically
- `,>/<` - Resize window horizontally
- `,vs` - Vertical split + file finder
- `,sp` - Horizontal split + file finder

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

### Language-Specific Settings
- **Python**: 4-space indentation, flake8/pylint linting, black/isort formatting
- **JavaScript/TypeScript**: 2-space indentation, eslint linting, prettier formatting
- **HTML/CSS/SCSS**: 2-space indentation
- **Go**: 4-space indentation, no tab expansion
- **YAML**: 2-space indentation

### Vim Motion Training
The `DisableNonCountedBasicMotions.vim` plugin enforces counted motions:
- `:DisableNonCountedBasicMotions` - Enable motion training
- `:EnableNonCountedBasicMotions` - Disable motion training
- `:ToggleDisablingOfNonCountedBasicMotions` - Toggle training mode

Affected motions: `h`, `j`, `k`, `l` (must be prefixed with count like `5j`)

## Repository Management

### Common Git Commands for Dotfiles
```bash
# Quick status check
g s                    # git status (using alias)

# Add and commit changes
git add .bashrc .vimrc .tmux.conf .gitconfig
git commit -m "update configs"

# Push with upstream tracking
g push                 # git push -u origin HEAD (using alias)

# Check what's different
git diff               # see unstaged changes
git diff --staged      # see staged changes
```

### Backup and Sync
The repository uses actual dotfiles (.bashrc, .gitconfig, etc.) that can be directly symlinked. When making changes:

1. Edit files in the repository
2. Changes are automatically reflected in your shell (since they're symlinked)
3. Commit changes to track your configuration evolution
4. Push to keep configurations synchronized across machines