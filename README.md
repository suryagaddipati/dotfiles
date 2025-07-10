# 🥷 Ninja Dotfiles

Ruthlessly optimized configuration files for bash, git, tmux, and neovim. Fast, minimal, deadly.

## Table of Contents
- [Quick Setup](#quick-setup)
- [Commands](#commands)
- [Files](#files)
- [Ninja Shortcuts](#ninja-shortcuts)
- [Requirements](#requirements)

## Quick Setup

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
just full-install    # Automated ninja installation
```

## Commands

```bash
just install        # Install dotfiles with backup
just full-install   # Install with dependencies + dev tools
just status         # Check installation status
just backup         # Backup existing configs
just update         # Update from git
```

## Files

- `.bashrc` - Shell configuration with aliases and smart functions
- `.gitconfig` - Git configuration with productivity aliases
- `.tmux.conf` - Tmux setup (prefix: **Ctrl-Space**)
- `init.lua` - **NINJA NEOVIM CONFIG** - Fast, minimal, deadly (leader: `,`)
- `justfile` - Automated installation system

## 🥷 Ninja Shortcuts

### Bash Aliases
- `g` - git (shorthand)
- `t` - smart tmux session (attach/create)
- `ll` - detailed file listing
- `grp pattern ext1 ext2` - multi-extension grep

### Git Shortcuts
- `git s` - status
- `git co` - checkout
- `git b` - branch

### Tmux (Prefix: **Ctrl-Space**)
- `Ctrl-Space |` - horizontal split
- `Ctrl-Space -` - vertical split
- `Ctrl-Space h/j/k/l` - navigate panes
- `Alt+h/j/k/l` - navigate panes (NO PREFIX)
- `Alt+1-9` - switch windows (NO PREFIX)
- `Ctrl-Space f` - zoom pane

### 🔥 Neovim Ninja Keys (Leader: `,`)

#### Survival Keys
- `,w` `,q` `,x` - save, quit, save+quit
- `,/` - clear search highlight

#### Navigation (INSTANT)
- `Ctrl+h/j/k/l` - window navigation
- `Tab` / `Shift+Tab` - buffer cycling
- `gd` `gr` `K` - LSP go-to-definition, references, hover

#### The Ninja's Scope (Telescope)
- `,f` - find files
- `,g` - live grep (search all files)
- `,b` - buffer list
- `,h` - recent files

#### File Tree & LSP Power
- `,t` - toggle file tree
- `,r` - LSP rename
- `,ca` - LSP code actions

#### Text Mastery
- `gcc` - comment toggle
- `cs"'` - surround change quotes
- `n` / `N` - search (auto-centered)

## Requirements

```bash
sudo apt install git tmux neovim curl fzf ripgrep xclip
```

For complete documentation see [CLAUDE.md](CLAUDE.md).

## 🚀 Ninja Features

### Performance First
- **<100ms startup** - Lazy loading everything except colorscheme
- **316 lines** - Down from 540+ bloated lines
- **8 plugins** - Only the deadly essentials
- **Zero conflicts** - No duplicate functionality

### Core Arsenal
- **Gruvbox** - The ninja's dark theme
- **Telescope** - Sniper scope for files and text
- **LSP** - Intelligence for Lua, Python, TypeScript
- **Treesitter** - Perfect syntax highlighting
- **nvim-tree** - File explorer with git integration
- **Auto-pairs** - Smart bracket completion
- **Gitsigns** - See your changes instantly
- **Surround** - Text object mastery

### Muscle Memory Design
- **Consistent keybindings** - Same patterns across tmux/nvim
- **No prefix conflicts** - Alt+hjkl works everywhere
- **Leader comma** - Easy to reach, memorable
- **Standard LSP keys** - gd, gr, K work as expected

For complete documentation see [CLAUDE.md](CLAUDE.md).