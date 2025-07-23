# 🥷 Neovim Ninja Configuration

A performance-optimized Neovim configuration designed for maximum productivity with minimal bloat. This "Ninja Config" focuses on speed, consistency, and essential functionality for modern development.

## 🚀 Quick Start

```bash
# The configuration is automatically symlinked via justfile
just install          # Installs dotfiles including neovim config
just setup-nvim       # Setup neovim specifically and install plugins

# Manual verification
nvim                   # Plugins will auto-install on first launch
:Lazy                  # Open plugin manager
:checkhealth          # Verify installation
```

## 🏗️ Architecture Overview

### Core Philosophy
- **Performance First**: Sub-100ms startup time with lazy loading
- **Minimal Bloat**: Only essential plugins, disabled unnecessary defaults
- **Consistent Navigation**: Vim-style keybindings throughout
- **Modern Tooling**: LSP, Treesitter, Telescope for intelligent editing

### Configuration Structure
```
~/.config/nvim/
├── init.lua              # Entry point - loads core modules
├── lazy-lock.json        # Plugin version lockfile
└── lua/
    ├── core/             # Core configuration
    │   ├── options.lua   # Vim options and settings
    │   ├── keymaps.lua   # Global keybindings
    │   ├── lazy.lua      # Plugin manager setup
    │   └── autocmds.lua  # Autocommands and file-specific settings
    └── plugins/          # Individual plugin configurations
        ├── telescope.lua    # Fuzzy finder
        ├── nvim-tree.lua   # File explorer
        ├── lsp.lua         # Language servers + completion
        ├── treesitter.lua  # Syntax highlighting
        ├── claude-code.lua # AI assistance integration
        ├── toggleterm.lua  # Terminal management
        ├── colorscheme.lua # Gruvbox theme configuration
        ├── gitsigns.lua    # Git integration
        └── [other plugins] # Additional functionality
```

## ⚙️ Core Configuration

### Leader Key & Navigation
```lua
vim.g.mapleader = ' '  -- Space as leader key

-- Window navigation (matches tmux patterns)
<C-h/j/k/l>           -- Navigate between splits
<leader>w             -- Save file
<leader>q             -- Quit
<leader>x             -- Save and quit
```

### Essential Options
```lua
-- Performance optimizations
updatetime = 50           -- Faster completion and git signs
timeoutlen = 300         -- Quick which-key popup
lazyredraw = true        -- Don't redraw during macros
synmaxcol = 200         -- Limit syntax highlighting for long lines

-- Editor behavior
number = true            -- Line numbers
relativenumber = true    -- Relative line numbers
scrolloff = 8           -- Keep 8 lines visible when scrolling
wrap = false            -- No line wrapping
clipboard = 'unnamedplus' -- System clipboard integration

-- File management
undofile = true         -- Persistent undo history
swapfile = false        -- Disable swap files
backup = false          -- Disable backup files
```

## 📦 Plugin Ecosystem

### 🔍 **Telescope** - Fuzzy Finder
**Purpose**: Fast file and content searching across the project

```lua
<leader>f    -- Live grep (search text in files)
<leader>p    -- Find files by name
<leader>b    -- Search open buffers
<leader>hr   -- Recent files history
```

**Configuration**: Horizontal layout with top prompt for better UX

### 🌲 **Nvim-Tree** - File Explorer
**Purpose**: Visual file system navigation with git integration

```lua
<leader>e    -- Toggle file tree

-- Within nvim-tree:
l            -- Open file/expand directory
h            -- Close directory
a            -- Create new file/folder
d            -- Delete file/folder
r            -- Rename file/folder
```

**Features**: 30-character width, git status indicators, dotfiles visible

### 🧠 **LSP + Completion** - Language Intelligence
**Purpose**: Language servers with smart autocompletion

**Supported Languages**:
- **Lua**: lua_ls with vim globals configured
- **Python**: pyright for type checking and completion
- **JavaScript/TypeScript**: tsserver for web development

```lua
-- LSP Navigation
gd           -- Go to definition
gr           -- Go to references  
K            -- Show hover documentation
<leader>r    -- Rename symbol
<leader>ca   -- Code actions

-- Completion (nvim-cmp)
<C-Space>    -- Trigger completion
<CR>         -- Accept completion
<C-e>        -- Abort completion
```

### 🎨 **Treesitter** - Advanced Syntax
**Purpose**: Modern syntax highlighting and code understanding

**Languages**: lua, python, javascript, typescript, bash, json, yaml
**Features**: Better highlighting, smart indentation, text objects

### 🤖 **Claude Code** - AI Integration
**Purpose**: AI-powered coding assistance directly in Neovim

```lua
<leader>c*   -- Claude Code namespace
<leader>cc   -- Toggle Claude interface
<leader>cf   -- Focus Claude panel
<leader>cr   -- Resume Claude session
<leader>cb   -- Add current buffer to context
<leader>cs   -- Send visual selection to Claude
<leader>ca   -- Accept Claude diff
<leader>cd   -- Deny Claude diff
```

**Features**: Local Claude integration, context-aware assistance, diff preview

### 💻 **ToggleTerm** - Terminal Management
**Purpose**: Integrated terminal with multiple layouts

```lua
<C-\>        -- Toggle terminal (global hotkey)
<leader>tt   -- Toggle terminal
<leader>tf   -- Float terminal
<leader>th   -- Horizontal terminal
<leader>tv   -- Vertical terminal
<leader>t1-9 -- Specific terminal instances

-- Terminal mode navigation
<Esc>        -- Exit terminal mode
jk           -- Exit terminal mode (alternative)
<C-h/j/k/l>  -- Navigate to other splits from terminal
```

### 🎨 **Gruvbox** - Color Scheme
**Purpose**: Consistent theming with focus highlighting

**Features**:
- Hard contrast dark theme
- Custom window focus highlighting
- Dimmed inactive windows
- Blue separator accents for better visual separation

### 🔀 **Git Integration** - Gitsigns
**Purpose**: Git status and operations within Neovim  

```lua
<leader>g*   -- Git operations namespace
<leader>gb   -- Git blame current line
<leader>gp   -- Preview git hunk
<leader>gn   -- Next hunk with preview
<leader>gN   -- Previous hunk with preview
<leader>gs   -- Stage current hunk
<leader>gS   -- Stage entire buffer (handles new files)
<leader>gu   -- Undo stage hunk
<leader>gd   -- Reset git hunk
<leader>gc   -- Auto-commit with AI-generated message
```

**Features**: Visual git indicators, hunk navigation, intelligent staging

### 🔧 **Utility Plugins**

#### **Which-Key** - Command Discovery
- Modern preset with 100ms delay
- Shows available keybindings after leader key

#### **Autopairs** - Bracket Completion
- Auto-closes quotes, brackets, parentheses
- Integrates with completion engine

#### **Surround** - Text Object Manipulation
- Add, change, delete surrounding characters
- Works with quotes, brackets, HTML tags

#### **Comment** - Toggle Comments
- Language-aware commenting
- Works with visual selections

#### **Focus/Maximizer** - Window Management
- Auto-resize active window
- Maximize/restore window toggle

## 📊 Performance Optimizations

### Startup Performance
```lua
-- Disabled default plugins for faster boot
disabled_plugins = {
  'gzip', 'matchit', 'matchparen', 'netrwPlugin',
  'tarPlugin', 'tohtml', 'tutor', 'zipPlugin'
}

-- Lazy loading strategy
event = { 'BufReadPre', 'BufNewFile' }  -- Load on file open
keys = { '<leader>*' }                   -- Load on keypress
cmd = { 'CommandName' }                  -- Load on command
```

### Memory Efficiency
- Minimal plugin set (15 essential plugins)
- Lazy loading prevents unused plugins from consuming memory
- LSP servers shared across buffers
- Tree-sitter parsers only for configured languages

### Version Pinning
- **nvim-lspconfig v0.1.7**: Ensures compatibility with Neovim 0.9
- **lazy-lock.json**: Locks all plugin versions for reproducible installs

## 🎯 Keybinding Philosophy

### Consistency Principles
1. **Leader Key (Space)**: All custom mappings use space leader
2. **Vim Navigation**: h/j/k/l patterns throughout
3. **Mnemonics**: 'f' for find, 'g' for git, 'c' for Claude, etc.
4. **Visual Mode**: Preserve selection for repeated operations

### Global Keybindings
```lua
-- File Operations
<leader>w         -- Save file
<leader>q         -- Quit
<leader>x         -- Save and quit
<leader>/         -- Clear search highlighting

-- Window Navigation & Management  
<C-h/j/k/l>       -- Navigate splits
<leader>+/-       -- Resize vertically
<leader>>/<       -- Resize horizontally

-- Buffer Management
<Tab>             -- Next buffer
<S-Tab>           -- Previous buffer
<leader>bd        -- Delete buffer

-- Visual Line Navigation
j/k               -- Move by visual lines (not actual lines)
n/N               -- Centered search navigation
```

### Plugin-Specific Keybindings

#### Telescope (Fuzzy Finding)
```lua
<leader>f         -- Live grep search
<leader>p         -- Find files
<leader>b         -- Find buffers
<leader>hr        -- Recent files
```

#### File Management
```lua
<leader>e         -- Toggle nvim-tree
```

#### Terminal
```lua
<C-\>             -- Global terminal toggle
<leader>t*        -- Terminal namespace
```

#### Git Operations
```lua
<leader>g*        -- Git namespace (see Gitsigns section)
```

#### Claude Code AI
```lua
<leader>c*        -- Claude namespace (see Claude section)
```

## 🔧 Language-Specific Settings

### Python
```lua
-- Auto-configured for Python files
shiftwidth = 4        -- 4-space indentation
tabstop = 4          -- 4-space tabs
expandtab = true     -- Spaces instead of tabs
```

### Web Development (JS/TS/HTML/CSS)
```lua
-- Default configuration
shiftwidth = 2        -- 2-space indentation
tabstop = 2          -- 2-space tabs
expandtab = true     -- Spaces instead of tabs
```

### Lua
```lua
-- Default configuration with LSP
shiftwidth = 2        -- 2-space indentation
diagnostics.globals = {'vim'}  -- Recognize vim global
```

## 🚀 Advanced Features

### Smart Autocommands
```lua
-- Restore cursor position on file open
BufReadPost          -- Jump to last known cursor position

-- Auto-trim whitespace on save
BufWritePre          -- Remove trailing whitespace

-- Language-specific settings
FileType python      -- 4-space indentation for Python files
```

### Terminal Integration
- **Global hotkey**: `<C-\>` works from any mode
- **Multiple instances**: Support for 9 numbered terminals
- **Smart navigation**: Seamlessly move between terminal and editor
- **Layout options**: Float, horizontal, vertical terminals

### Git Workflow Integration
- **Visual indicators**: Gutter signs for added/modified/deleted lines
- **Staged indicators**: Shows both staged and unstaged changes
- **Smart staging**: Handles both tracked and untracked files
- **AI commit messages**: Auto-generates meaningful commit messages
- **Hunk navigation**: Preview and navigate changes without leaving editor

### Claude Code AI Workflow
- **Context-aware**: Add specific buffers or selections to AI context
- **Diff preview**: Review AI suggestions before applying
- **Session management**: Resume previous AI conversations
- **Multiple interfaces**: Terminal, floating, or sidebar integration

## 🔍 Troubleshooting

### Plugin Issues
```vim
:Lazy                 -- Open plugin manager
:Lazy sync           -- Update/install/clean plugins
:Lazy health         -- Check plugin health
:checkhealth         -- Overall health check
```

### LSP Problems
```vim
:LspInfo             -- Show LSP status for current buffer
:LspRestart          -- Restart LSP servers
:checkhealth lsp     -- LSP-specific health check
```

### Performance Issues
```vim
:Lazy profile        -- Show plugin loading times
:checkhealth vim.lsp -- Check LSP performance
```

### Configuration Reload
```vim
:source %            -- Reload current config file
:Lazy reload <plugin> -- Reload specific plugin
```

## 🎯 Workflow Examples

### Code-Search-Edit Cycle
```bash
<leader>f TODO       # Search for "TODO" across project
<Enter>              # Open file with TODO
gd                   # Go to definition of symbol
<leader>ca           # Apply code action/fix
<leader>w            # Save file
<leader>f            # Search for next TODO
```

### Git Workflow
```bash
<leader>gS           # Stage entire buffer
<leader>gc           # Auto-commit with AI message
<leader>gp           # Preview next change
<leader>gs           # Stage specific hunk
```

### AI-Assisted Development
```bash
<leader>cb           # Add current buffer to Claude context
<leader>cc           # Open Claude interface
# Describe what you want to implement
<leader>ca           # Accept AI suggestions
<leader>w            # Save changes
```

### Multi-File Project Navigation
```bash
<leader>p            # Find files by name
<leader>e            # Toggle file tree for structure
<leader>b            # Switch between open buffers
<Tab>/<S-Tab>        # Quick buffer cycling
```

## 🔮 Future Enhancements

### Potential Additions
- **Debug Adapter Protocol (DAP)** for debugging support
- **Harpoon** for project-specific file bookmarks  
- **Oil.nvim** for file operations as buffer editing
- **Mini.nvim** modules for additional functionality
- **Copilot** integration alongside Claude Code

### Performance Monitoring
- Consider adding startup time benchmarking
- Memory usage monitoring for large projects
- LSP performance optimization for massive codebases

---

## 📚 Quick Reference Card

### Essential Daily Commands
| Command | Action | Category |
|---------|--------|----------|
| `<leader>p` | Find files | Navigation |
| `<leader>f` | Live grep | Search |
| `<leader>e` | Toggle file tree | Files |
| `<C-\>` | Toggle terminal | Terminal |
| `<leader>cc` | Claude Code | AI |
| `<leader>gS` | Stage buffer | Git |
| `<leader>w` | Save file | Files |
| `gd` | Go to definition | LSP |
| `<Tab>` | Next buffer | Navigation |

### Recovery Commands
| Command | Action | When to Use |
|---------|--------|-------------|
| `:Lazy sync` | Fix plugins | Plugin issues |
| `:LspRestart` | Restart LSP | Language server problems |
| `:checkhealth` | System check | General issues |
| `:source %` | Reload config | After config changes |

---

*This configuration prioritizes developer productivity through consistent keybindings, intelligent defaults, and modern tooling integration. The "Ninja" philosophy emphasizes speed, efficiency, and minimal cognitive overhead.*