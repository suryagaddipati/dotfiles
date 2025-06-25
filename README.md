# Personal Dotfiles

Configuration files for bash, git, tmux, and vim with productivity shortcuts.

## Table of Contents
- [Quick Setup](#quick-setup)
- [Commands](#commands)
- [Files](#files)
- [Shortcuts](#shortcuts)
- [Requirements](#requirements)

## Quick Setup

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
make full-install
```

## Commands

```bash
make install        # Install dotfiles with backup
make full-install   # Install with dependencies
make status         # Check installation status
make backup         # Backup existing configs
make update         # Update from git
```

## Files

- `.bashrc` - Shell configuration
- `.gitconfig` - Git configuration  
- `.tmux.conf` - Tmux setup (prefix: Ctrl-Y)
- `init.lua` - Neovim configuration (leader: ,)
- `Makefile` - Installation automation

## Shortcuts

### Bash
- `g` - git
- `t` - smart tmux session
- `ll` - ls -alF

### Git
- `git s` - status
- `git co` - checkout
- `git b` - branch

### Tmux (Prefix: Ctrl-Y)
- `Ctrl-Y |` - horizontal split
- `Ctrl-Y -` - vertical split
- `Ctrl-Y h/j/k/l` - navigate panes
- `Alt+1-9` - switch windows
- `Ctrl-Y f` - zoom pane

### Neovim (Leader: ,)
- `,f` - find files (telescope)
- `,g` - live grep (telescope)
- `,t` - file tree (nvim-tree)
- `,w` - save
- `Ctrl+h/j/k/l` - navigate splits

## Requirements

```bash
sudo apt install git tmux neovim curl fzf ripgrep xclip
```

For complete documentation see [CLAUDE.md](CLAUDE.md).

## Modern Features

- **Neovim with Lua**: Modern neovim configuration using Lua
- **Telescope**: Powerful fuzzy finder for files, text, and more
- **nvim-tree**: Modern file explorer with git integration
- **Treesitter**: Advanced syntax highlighting and code understanding
- **LSP**: Built-in Language Server Protocol support
- **Auto-completion**: Intelligent code completion with nvim-cmp
- **lazy.nvim**: Fast and modern plugin manager