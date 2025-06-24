# Personal Dotfiles

A comprehensive collection of configuration files for a productive Linux development environment featuring bash, git, tmux, and vim with extensive customizations and shortcuts.

## 🚀 Quick Setup

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Backup existing configs
cp ~/.bashrc ~/.bashrc.backup 2>/dev/null || true
cp ~/.gitconfig ~/.gitconfig.backup 2>/dev/null || true
cp ~/.tmux.conf ~/.tmux.conf.backup 2>/dev/null || true
cp ~/.vimrc ~/.vimrc.backup 2>/dev/null || true

# Install configurations
ln -sf ~/dotfiles/.bashrc ~/.bashrc
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.vimrc ~/.vimrc

# Setup vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mkdir -p ~/.vim/plugin
cp ~/dotfiles/DisableNonCountedBasicMotions.vim ~/.vim/plugin/
vim +PlugInstall +qall

# Reload shell
source ~/.bashrc
```

## 📁 What's Included

- **`.bashrc`** - Shell configuration with smart aliases and functions
- **`.gitconfig`** - Git configuration with helpful aliases
- **`.tmux.conf`** - Feature-rich tmux setup with custom prefix (Ctrl-Y)
- **`.vimrc`** - Comprehensive vim configuration with plugins
- **`tmux.bash`** - Advanced tmux session management
- **`DisableNonCountedBasicMotions.vim`** - Vim training plugin for better habits

## ⚡ Key Features

### Bash Shortcuts
```bash
g              # git (shorthand)
t              # smart tmux session management
ll             # ls -alF (detailed list)
la             # ls -A (show hidden)
```

### Git Aliases
```bash
git s          # git status
git co         # git checkout  
git b          # git branch
git push       # git push -u origin HEAD (auto-upstream)
```

### Tmux (Prefix: Ctrl-Y)
- **Sessions**: `Ctrl-Y s` (list), `Ctrl-Y S` (new), `Ctrl-Y N` (new in current dir)
- **Windows**: `Ctrl-Y c` (create), `Alt+1-9` (switch), `Ctrl-Y ,` (rename)
- **Panes**: `Ctrl-Y |` (horizontal split), `Ctrl-Y -` (vertical split)
- **Navigation**: `Ctrl-Y h/j/k/l` or `Alt+h/j/k/l` (vim-style)
- **Zoom**: `Ctrl-Y f` (toggle pane zoom)
- **Copy**: `Ctrl-Y Enter` (copy mode), `v` (select), `y` (copy)

### Vim (Leader: ,)
- **Files**: `,f` (find files), `,g` (search in files), `,t` (file tree)
- **Navigation**: `Ctrl+h/j/k/l` (split navigation), `,e` (explorer)  
- **Buffers**: `,b` (list), `Tab/Shift+Tab` (next/prev), `,bd` (delete)
- **Quick**: `,w` (save), `,q` (quit), `,/` (clear search)
- **Editing**: `Space` (fold), `,S` (find/replace word)

## 🛠 Advanced Features

### Smart Tmux Session Management
```bash
# Auto-attach or create sessions
t                    # attach to existing or create 'main'
t project           # attach to 'project' or create it
tmux_smart_session  # same functionality

# Advanced wrapper with window support  
tm session-name window-name
```

### Vim Productivity
- **FZF Integration**: Fast file finding and text search
- **Git Integration**: Fugitive for git operations, NERDTree git status
- **Auto-formatting**: Language-specific formatting on save
- **Linting**: Real-time error checking with ALE
- **Snippets**: UltiSnips with extensive snippet library

### Development Environment
- **NVM**: Node.js version management
- **SDKMAN**: Java/JVM tool management  
- **Language Support**: Python, JavaScript, TypeScript, Go, HTML/CSS
- **Terminal Integration**: Clipboard support, 256 colors, mouse support

## 🎨 Appearance

- **Color Scheme**: Gruvbox theme throughout (vim, tmux status)
- **Status Bars**: Airline for vim, custom tmux status with git integration
- **File Explorer**: NERDTree with icons and git status indicators
- **Terminal**: 256-color support with custom prompts

## 🔧 Customization

### Language-Specific Settings
- **Python**: 4-space tabs, black/isort formatting, flake8/pylint linting
- **JavaScript/TypeScript**: 2-space tabs, prettier/eslint formatting
- **Go**: Tab indentation, no expansion
- **YAML**: 2-space tabs

### Motion Training
The included vim plugin enforces counted motions (`5j` instead of `j`) to build better navigation habits:
```vim
:ToggleDisablingOfNonCountedBasicMotions  " Toggle training mode
```

## 📋 Requirements

### Essential
```bash
sudo apt install git tmux vim curl build-essential fzf ripgrep xclip
```

### Optional (Installed by scripts)
- **NVM**: Node.js version management
- **SDKMAN**: Java development tools
- **Powerline Fonts**: Better status bar appearance

## 🔄 Keeping Updated

Since configurations are symlinked, changes are immediately active:

```bash
cd ~/dotfiles
git pull origin master    # Get latest updates
source ~/.bashrc          # Reload shell if needed
```

## 🎯 Philosophy

These dotfiles prioritize:
- **Productivity**: Extensive shortcuts and smart defaults
- **Consistency**: Vim-style navigation everywhere possible  
- **Discoverability**: Well-documented with help always available
- **Flexibility**: Easy to customize while maintaining core functionality

---

For detailed documentation of all shortcuts and installation instructions, see [CLAUDE.md](CLAUDE.md).