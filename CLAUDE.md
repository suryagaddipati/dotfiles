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
- **Modern neovim focus**: Recent migration to performance-optimized configuration with Claude Code integration

### Integration Patterns
- **Consistent theming**: Gruvbox color scheme unified across tmux, vim, and neovim
- **Unified key bindings**: Vim-style navigation throughout (tmux panes, neovim splits, Alt+hjkl shortcuts)
- **Smart session management**: Intelligent tmux session attachment/creation via `t` alias and `tmux_smart_session` function
- **Multi-extension search**: `grp` function for efficient codebase searching across file types

### Key Technical Details
- **Tmux prefix**: Ctrl-Space instead of default Ctrl-B (critical for avoiding conflicts)
- **Neovim leader**: Space for all custom mappings
- **Plugin managers**: lazy.nvim (neovim), vim-plug (vim) with auto-installation
- **Development tools**: mise (unified tool manager for Node.js, Python, Go, Rust, etc.), replacing NVM/SDKMAN/etc.
- **Cross-platform support**: Justfile detects and uses appropriate package manager (apt/brew/yum)
- **Claude Code integration**: Official Coder plugin integrated with neovim for AI assistance

## File Structure

- `.bashrc` - Bash shell configuration with aliases, functions, and environment setup
- `.gitconfig` - Git configuration with user settings and aliases  
- `.tmux.conf` - Comprehensive tmux configuration with custom key bindings and appearance
- `init.lua` - Modern neovim configuration with lua-based plugins and custom mappings
- `tmux.bash` - Tmux session management wrapper function
- `justfile` - Automated installation and management system
- `.claude/` - Claude Code configuration directory with hooks and settings

## Key Configuration Details

### Bash Configuration
- Uses `g` alias for git commands
- `t` alias maps to `tmux_smart_session` function for intelligent tmux session management
- mise integration for unified tool version management (Node.js, Python, Go, Rust, etc.)
- Custom `tmux_smart_session()` function for automated session attachment/creation
- `grp()` function for multi-extension grep searches using git ls-files (e.g., `grp TODO js ts py`)
- Vi mode enabled for bash command line editing (`set -o vi`)
- Claude CLI integration via PATH (`~/.local/bin/claude` symlink)
- mise tool version management for all development languages
- Extended PATH with `~/.local/bin` for user-installed tools (including `just`)

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
- Claude Code integration for AI assistance
- Performance-optimized with minimal plugin set
- Comprehensive key mappings for productivity

## mise Configuration

### What is mise?
mise is a unified tool version manager that replaces multiple version managers like NVM (Node.js), SDKMAN (Java), rbenv (Ruby), pyenv (Python), etc. It provides a single interface to manage all your development tool versions.

### Configuration File
The mise configuration is stored in `.config/mise/config.toml`:
```toml
[tools]
# Development languages
node = "20"
python = "3.11"
go = "1.21"
rust = "1.75"

# Core development tools (cross-platform)
neovim = "latest"
tmux = "latest"

# CLI utilities
ripgrep = "latest"
fzf = "latest"
```

### Common mise Commands
```bash
# Install all tools from config.toml
mise install

# Install a specific tool
mise install node@20

# List available versions
mise list-remote node

# Show current versions
mise current

# Update all tools to latest versions
mise upgrade

# Switch to different version temporarily
mise shell node@18

# Set global version
mise global node@20
```

### Available Tools
mise supports hundreds of tools including:
- **Languages**: node, python, go, rust, java, ruby, php, etc.
- **Databases**: postgres, mysql, redis, etc.  
- **Build tools**: gradle, maven, cmake, etc.
- **Cloud tools**: terraform, kubectl, aws-cli, etc.

### Integration with Shell
mise automatically activates the correct tool versions when you enter a project directory, similar to how conda environments work but for all development tools.

## Essential Commands for Development

### Installation and Management (using justfile)
```bash
# Primary installation commands
just install           # Install dotfiles with automatic backup
just full-install      # Complete setup: dependencies + dotfiles + dev tools
just quick-install     # Same as 'just install' (backup + install)

# Dependency management
just install-deps      # Install minimal system deps + mise + all tools (cross-platform)
just install-mise      # Install mise tool manager specifically
just install-mise-tools # Install neovim, tmux, CLI tools via mise (cross-platform)
just install-dev       # Install development languages using mise
just install-mcp       # Install MCP servers for Claude Code integration

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
- **Managed files**: `.bashrc`, `.gitconfig`, `.tmux.conf`, `init.lua` (symlinked to `~/.config/nvim/`)
- **Special handling**: `init.lua` is symlinked to neovim config directory, not home directory

### Tmux Session Management
```bash
# Smart session function (available as alias 't')
tmux_smart_session [session-name]
# - No arguments: Attach to existing session or create 'main'
# - With session name: Attach if exists, create if not

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
- `Ctrl-Space s` - Split horizontally
- `Ctrl-Space v` - Split vertically
- `Ctrl-Space h/j/k/l` - Navigate panes
- `Alt+h/j/k/l` - Navigate panes (no prefix)
- `Alt+1-9` - Switch to window 1-9
- `Ctrl-Space r` - Reload config

### Key Neovim Bindings (Leader: ,)
- `<Space>t` - Toggle nvim-tree
- `<Space>f` - Find files (Telescope)
- `<Space>g` - Live grep (Telescope)
- `<Space>w` - Save file
- `<Space>q` - Quit
- `Ctrl+h/j/k/l` - Navigate splits
- `<Space>ac` - Toggle Claude Code
- `<Space>af` - Focus Claude Code
- `<Space>ab` - Add current buffer to Claude
- `<Space>as` - Send visual selection to Claude
- `Ctrl+\` - Toggle terminal (global hotkey)
- `<Space>tt` - Toggle terminal
- `<Space>tf` - Float terminal
- `<Space>th` - Horizontal terminal
- `<Space>tv` - Vertical terminal

## Installation

### Prerequisites
```bash
# Only minimal system dependencies needed (cross-platform)
# Linux (apt)
sudo apt update && sudo apt install -y git curl build-essential xclip

# macOS (brew)
brew install git curl

# Everything else (neovim, tmux, fzf, ripgrep) installed via mise
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
just install-dev      # Install development tools via mise
just install-mcp      # Install MCP servers for Claude Code
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
grp pattern ext1 [ext2...]       # Multi-extension grep using git ls-files (e.g., grp TODO js ts py)
```

### Tmux Key Bindings (Prefix: Ctrl-Space)

#### Session Management
- `Ctrl-Space S` - Create new session (prompted for name)
- `Ctrl-Space R` - Rename session
- `Ctrl-Space N` - New session in current directory
- `Alt+s` - Choose session (quick session switcher)

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
- `Ctrl-Space s` - Split horizontally (primary)
- `Ctrl-Space v` - Split vertically (primary)
- `Ctrl-Space |` or `Ctrl-Space \` - Split horizontally (alternative)
- `Ctrl-Space -` or `Ctrl-Space _` - Split vertically (alternative)
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

### Neovim Key Bindings (Leader: Space)

#### File Operations
- `<leader>w` - Save file
- `<leader>q` - Quit
- `<leader>x` - Save and quit
- `<leader>/` or `<leader>h` - Clear search highlighting

#### File Explorer (nvim-tree)
- `<leader>p` - Toggle nvim-tree

#### File Finding (Telescope)
- `<leader>f` - Find files in project
- `<leader>e` - Live grep (search text in files)
- `<leader>b` - Find buffers
- `<leader>hr` - Recent files history

#### Navigation
- `Ctrl+h/j/k/l` - Move between splits
- `j/k` - Move by visual lines (not actual lines)
- `n/N` - Next/previous search result (centered)

#### Window and Split Management
- `<leader>+/-` - Resize window vertically
- `<leader>>/<` - Resize window horizontally
- `<leader>z` - Toggle maximize split

#### Buffer Management
- `<leader>bd` - Delete buffer
- `Tab` - Next buffer
- `Shift+Tab` - Previous buffer

#### Editing and Text Manipulation
- `</> (visual mode)` - Indent/unindent and keep selection

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
- `<leader>r` - Rename symbol

#### Unified Git Workflow (All under `<leader>g*`)

**Git Inspection & Navigation**
- `<leader>gg` - Git status (diffview)
- `<leader>gh` - Git file history 
- `<leader>gf` - Git files panel
- `<leader>gb` - Git blame current line
- `<leader>gp` - Preview git hunk
- `<leader>gn` - Next hunk with preview
- `<leader>gN` - Previous hunk with preview

**Git Actions**
- `<leader>gs` - Stage current hunk
- `<leader>gS` - Stage entire buffer
- `<leader>gu` - Unstage/undo hunk
- `<leader>gr` - Reset/discard hunk  
- `<leader>gR` - Reset entire buffer

**Git Commits**
- `<leader>gc` - Quick commit (auto-generated message)
- `<leader>gC` - Interactive commit (manual message)
- `<leader>gm` - Commit with Claude-generated message

**Git + Claude Integration**
- `<leader>ga` - Add current hunk to Claude context
- `<leader>gA` - Add entire buffer to Claude context
- `<leader>gi` - Send hunk to Claude for explanation
- `<leader>gI` - Send entire diff to Claude for review

**Example Unified Git Workflow:**
```bash
# 1. Inspect changes
<leader>gg          # Open git status overview
<leader>gp          # Preview current hunk
<leader>gn          # Navigate to next hunk

# 2. Get AI assistance
<leader>ga          # Add hunk to Claude for review
<leader>gi          # Ask Claude to explain/improve hunk

# 3. Stage changes
<leader>gs          # Stage current hunk
<leader>gS          # Stage entire buffer

# 4. Commit with appropriate method
<leader>gc          # Quick auto-commit
<leader>gC          # Interactive manual commit  
<leader>gm          # Claude-generated commit message
```

#### Terminal Management (ToggleTerm)
- `<C-\>` - Toggle terminal (global)
- `<leader>tt` - Toggle terminal
- `<leader>tf` - Float terminal
- `<leader>th` - Horizontal terminal
- `<leader>tv` - Vertical terminal
- `<leader>t1` to `<leader>t9` - Access terminal 1-9

Terminal mode keybindings:
- `<Esc>` or `jk` - Exit terminal mode
- `<C-h/j/k/l>` - Navigate splits from terminal

#### Comment Toggle
- `gcc` - Comment/uncomment current line
- `gc` - Comment selection (visual mode)

#### Markdown Preview
- `<leader>m` - Preview markdown file (if current file is markdown)

#### Git Commands in Terminal
- `<leader>gc` - Open floating terminal with git commit

#### Claude Code Integration
- `<leader>cc` - Toggle Claude Code interface
- `<leader>cf` - Focus Claude Code panel
- `<leader>cr` - Resume Claude Code session
- `<leader>cC` - Continue Claude Code conversation
- `<leader>cb` - Add current buffer to Claude context
- `<leader>ch` - Send current hunk to Claude
- `<leader>cs` - Send visual selection to Claude (visual mode)
- `<leader>ct` - Add file to Claude (in nvim-tree)
- `<leader>ca` - Accept Claude Code diff
- `<leader>cd` - Deny Claude Code diff

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
- **Leverage the grp function**: `grp pattern ext1 ext2` for efficient code searching across file types (uses git ls-files for performance)
- **NEVER include Claude Code attribution in commit messages**: Do not add "Generated with Claude Code" or similar attribution to any commits

### Critical System Details
- **Tmux prefix**: Ctrl-Space - not Ctrl-B or backtick (this is a key difference from defaults)
- **Neovim leader**: Space for all custom mappings
- **Alt+h/j/k/l**: Navigate tmux panes without prefix (works system-wide)
- **Alt+1-9**: Switch tmux windows without prefix (instant window switching)
- **Bash vi mode**: Enabled with `set -o vi` for vim-style command line editing

### Claude Code Configuration Files

#### Core Configuration Files
- **`hooks.json`**: IDE integration with automated buffer reloading after file operations
- **`settings.local.json`**: Security permissions framework for allowed tools and commands
- **`.mcp.json`**: Model Context Protocol server configurations for external tool access

#### Extended Configuration
- **`mcp-install.sh`**: Automated installation script for all MCP servers and dependencies
- **`agents/vim-expert.md`**: Specialized vim expert agent for advanced editor guidance
- **`commands/catch-me-up.md`**: Repository analysis slash command for project overviews

#### Security & Permissions
The `settings.local.json` file provides granular control over:
- **Allowed bash commands**: Specific command patterns with argument restrictions
- **Web access**: Domain-restricted fetching for documentation and resources
- **Tool permissions**: Fine-grained access control for development tools
- **IDE integration**: MCP server permissions for editor functionality

### Common Workflow Patterns
1. **Installation**: `just install` (handles backup automatically, safe to run)
2. **Status check**: `just status` (shows detailed installation health and symlink status)
3. **Config editing**: Edit files in repository, changes reflect immediately via symlinks
4. **Session management**: Use `t session-name` for intelligent tmux sessions (attaches if exists, creates if not)
5. **Code searching**: Use `grp pattern js ts py` for multi-extension searches with git ls-files and grep
6. **Plugin management**: Neovim plugins auto-install on first startup via lazy.nvim bootstrap
7. **Claude Code integration**: Use `<leader>cc` to toggle Claude Code for AI assistance directly in neovim

## Claude Code Integration Architecture

This dotfiles repository provides a complete Claude Code integration environment with advanced configuration for AI-assisted development. The setup includes hooks, permissions, MCP servers, custom agents, and slash commands for a seamless development experience.

### Architecture Overview

The Claude Code integration consists of four main components:

#### 1. **Core Configuration** (Security & Automation)
- **Hooks System**: Automated IDE integration and buffer reloading
- **Permissions Framework**: Granular security controls for tool access
- **Auto-reload System**: Real-time synchronization with development environment

#### 2. **MCP (Model Context Protocol) Servers** (External Tool Access)
- **Filesystem Operations**: Secure file and directory access within `/home/surya/code`
- **Git Integration**: Repository operations and version control
- **Database Connectivity**: SQLite and PostgreSQL database operations
- **Browser Automation**: Playwright for web interaction and testing
- **API Integrations**: GitHub, Slack, and web search capabilities

#### 3. **Custom Agents** (Specialized AI Assistants)
- **vim-expert**: Advanced vim/neovim guidance with expert-level optimization advice
- **Extensible Framework**: Easy addition of domain-specific AI assistants

#### 4. **Slash Commands** (Quick AI Tasks)
- **catch-me-up**: Comprehensive repository analysis and project overview
- **Custom Commands**: Project-specific AI workflows and automation

### Configuration Philosophy

The Claude Code setup follows three core principles:

1. **Security First**: Granular permissions and scoped access prevent unauthorized operations
2. **Development Efficiency**: Automated workflows reduce context switching and manual tasks  
3. **Extensibility**: Modular architecture allows easy addition of new capabilities

## Claude MCP (Model Context Protocol) Integration

MCP (Model Context Protocol) is an open protocol that enables LLMs to access external tools and data sources securely. It provides Claude Code with enhanced capabilities for filesystem operations, git management, database access, and more.

### Available MCP Servers

#### Core Development Servers
- **filesystem**: Access local files and directories within `/home/surya/code`
- **git**: Git repository operations for the dotfiles repository
- **bash**: Execute bash commands safely within the development environment
- **sqlite**: SQLite database operations and queries
- **postgres**: PostgreSQL database management

#### Integration Servers (API keys required)
- **brave-search**: Web search capabilities via Brave API
- **github**: GitHub repository operations via GitHub API
- **slack**: Slack workspace integration

#### Browser Automation
- **playwright**: Browser automation and web interaction with accessibility snapshots

### Installation and Setup

#### Automatic Installation
```bash
# Install MCP servers via justfile
just install-mcp       # Installs all MCP servers via npm

# Or as part of full setup
just full-install      # Includes MCP installation
```

#### Manual Installation
```bash
# Run the MCP installation script directly
~/.claude/mcp-install.sh
```

### Configuration Files

#### `.claude/.mcp.json`
Main MCP server configuration defining available servers and their parameters:
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-filesystem", "/home/surya/code"]
    },
    "git": {
      "command": "npx", 
      "args": ["@modelcontextprotocol/server-git", "--repository", "/home/surya/code/dotfiles"]
    }
  }
}
```

#### API Key Configuration
For servers requiring authentication, update the environment variables in `.mcp.json`:
```bash
# Edit the configuration
nvim ~/.claude/.mcp.json

# Add your API keys:
"BRAVE_API_KEY": "your_actual_brave_api_key"
"GITHUB_PERSONAL_ACCESS_TOKEN": "your_github_token"
```

### Usage Examples

#### Filesystem Operations
```bash
# In Claude Code, reference files with:
@filesystem:/home/surya/code/project/file.js

# Or use MCP filesystem commands for operations
```

#### Git Operations
```bash
# Access git repository data via MCP
@git:repository:///commits
@git:repository:///branches
```

#### Database Access
```bash
# SQLite operations
@sqlite:database.db///tables
@sqlite:database.db///query/SELECT * FROM users
```

#### Browser Automation
```bash
# Playwright operations for web interaction
@playwright:navigate:https://example.com
@playwright:screenshot
@playwright:click:button[data-test="submit"]
@playwright:fill:input[name="email"]:user@example.com
```

### Security Considerations
- **Filesystem access**: Limited to `/home/surya/code` directory
- **Git operations**: Restricted to the dotfiles repository 
- **API keys**: Store securely and rotate regularly
- **Bash commands**: Executed within the MCP security context

### Troubleshooting MCP

#### Check MCP Server Status
```bash
# List available MCP servers
claude mcp list

# Test MCP connectivity
claude mcp test filesystem
```

#### Common Issues
1. **Missing npm packages**: Run `just install-mcp` to reinstall
2. **API key errors**: Verify keys in `.mcp.json` are valid
3. **Permission issues**: Check file permissions on MCP scripts
4. **Playwright browser issues**: Install system dependencies with `sudo npx playwright install-deps`

#### Debug MCP Configuration
```bash
# Verify MCP configuration
cat ~/.claude/.mcp.json

# Check MCP server logs
claude mcp logs filesystem
```

## Complete Claude Configuration Reference

### Configuration File Details

#### `hooks.json` - IDE Integration Automation
Provides seamless integration between Claude Code and your development environment:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": { "tool_name": "Edit" },
        "hooks": [{ 
          "type": "command",
          "command": "curl IDE reload endpoint...",
          "timeout": 5000
        }]
      }
    ]
  }
}
```

**Purpose**: Automatically reloads IDE buffers after file edits, ensuring real-time synchronization.

#### `settings.local.json` - Security Framework
Granular permissions controlling Claude Code's access to system tools:

```json
{
  "includeCoAuthoredBy": false,
  "permissions": {
    "allow": [
      "Bash(git add:*)",
      "Bash(npm install:*)", 
      "Bash(just status:*)",
      "WebFetch(domain:github.com)",
      "mcp__ide__getDiagnostics"
    ],
    "deny": []
  }
}
```

**Security Benefits**:
- Command pattern matching prevents unauthorized operations
- Domain restrictions for web access
- MCP server permissions for specific functionality
- Explicit allow/deny lists for fine-grained control

#### `.mcp.json` - External Tool Access
Configures Model Context Protocol servers for enhanced AI capabilities:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-filesystem", "/home/surya/code"],
      "env": {}
    },
    "playwright": {
      "command": "npx", 
      "args": ["@playwright/mcp"],
      "env": {}
    }
  }
}
```

**Capabilities Enabled**:
- File system operations within scoped directories
- Git repository management and version control
- Database connectivity for development tasks
- Browser automation for testing and interaction
- API integrations for external services

### Agent System

#### `agents/vim-expert.md` - Specialized AI Assistant
A domain-specific agent embodying advanced vim expertise:

**Agent Characteristics**:
- **Philosophy**: Keyboard efficiency and minimal mouse usage
- **Expertise**: Advanced motions, text objects, plugin evaluation
- **Teaching Style**: Progressive skill building with practice exercises
- **Focus Areas**: Performance optimization, workflow patterns, LSP integration

**Usage**: Automatically triggered for vim/neovim related questions requiring expert guidance.

### Slash Commands

#### `commands/catch-me-up.md` - Repository Analysis
Comprehensive project overview command for quick understanding:

**Analysis Scope**:
- Repository structure and project type identification
- Recent development activity and commit analysis  
- Technology stack and architecture overview
- Current direction and development priorities

**Output Format**: Structured summary with project overview, recent activity, and future direction.

### Installation and Management

#### `mcp-install.sh` - Automated Setup
Comprehensive installation script for all MCP servers:

**Installation Process**:
1. **Dependency Check**: Verifies npm and node availability via mise
2. **Core Servers**: Installs filesystem, git, bash, database servers
3. **Integration Servers**: Adds GitHub, Slack, search capabilities  
4. **Browser Automation**: Installs Playwright with browser binaries
5. **System Dependencies**: Handles OS-specific requirements

**Error Handling**: Graceful fallback for missing dependencies with clear instructions.

### Workflow Integration

#### Development Workflow Enhancement
The Claude configuration integrates with existing development patterns:

1. **File Operations**: Automatic buffer reloading maintains editor synchronization
2. **Git Workflow**: MCP git server provides repository insights and operations
3. **Testing**: Playwright integration enables automated browser testing
4. **Documentation**: Web fetch capabilities allow real-time documentation access
5. **Database Work**: Direct database connectivity for development tasks

#### Security Model
Multi-layered security approach:

1. **Command Restrictions**: Only approved bash commands with specific patterns
2. **Scope Limitations**: File access restricted to development directories  
3. **API Authentication**: Secure token management for external services
4. **Domain Restrictions**: Web access limited to trusted documentation sources
5. **Audit Trail**: All operations logged for security monitoring```

## Current Neovim Configuration Architecture

The current neovim configuration (`init.lua`) is optimized for speed, minimal bloat, and maximum productivity. Key architectural decisions:

### Performance Optimizations
- **Lazy loading**: All plugins load only when needed via lazy.nvim
- **Minimal plugin set**: Only essential plugins for core functionality
- **Disabled unnecessary plugins**: Removed default vim plugins that slow startup
- **Fast boot time**: Optimized for sub-100ms startup
- **LSP version pinning**: Uses nvim-lspconfig v0.1.7 for nvim 0.9 compatibility

### Plugin Architecture
- **lazy.nvim**: Modern plugin manager with lazy loading
- **Telescope**: Fuzzy finder for files, buffers, grep
- **nvim-tree**: File explorer with git integration
- **LSP + completion**: Language servers with autocomplete
- **Treesitter**: Advanced syntax highlighting
- **Claude Code**: AI assistance integration
- **Auto-pairs**: Bracket/quote completion
- **Git signs**: Git diff visualization
- **Comment**: Toggle comments
- **Surround**: Text object manipulation
- **ToggleTerm**: Terminal toggle with multiple layouts

### Key Bindings Philosophy
- **Leader key**: Space for accessibility and ergonomics
- **Muscle memory**: Consistent vim-style navigation
- **Instant access**: Critical functions on single keystrokes
- **Visual mode**: Preserve selection for repeated operations
- **Buffer navigation**: Tab/Shift+Tab for quick switching

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
,g          -- Live grep
,b          -- Find buffers
,h          -- Recent files
```

**nvim-tree/nvim-tree.lua** - File explorer
```lua
,t          -- Toggle file tree
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

#### AI Integration
**coder/claudecode.nvim** - Claude Code integration
```lua
,ac         -- Toggle Claude Code
,af         -- Focus Claude Code
,ar         -- Resume Claude session
,aC         -- Continue Claude conversation
,ab         -- Add current buffer to Claude
,as         -- Send visual selection to Claude
,aa         -- Accept Claude diff
,ad         -- Deny Claude diff
```

#### Terminal Management
**akinsho/toggleterm.nvim** - Terminal toggle
```lua
<C-\>       -- Toggle terminal (global)
,tt         -- Toggle terminal
,tf         -- Float terminal
,th         -- Horizontal terminal
,tv         -- Vertical terminal
```

Terminal mode keybindings:
```lua
<Esc>       -- Exit terminal mode
jk          -- Exit terminal mode (alternative)
<C-h/j/k/l> -- Navigate splits from terminal
```

#### Language Support
**nvim-treesitter/nvim-treesitter** - Advanced syntax
- Better highlighting, indentation, text objects
- Auto-installs parsers for: lua, python, javascript, typescript, html, css, json, yaml, bash

**neovim/nvim-lspconfig** - Language servers (v0.1.7 - nvim 0.9 compatible)
```lua
gd          -- Go to definition
gr          -- Go to references
K           -- Hover documentation
,r          -- Rename symbol
,ca         -- Code actions
```

**hrsh7th/nvim-cmp** - Completion engine
```lua
<C-Space>   -- Trigger completion
<CR>        -- Confirm selection
<C-e>       -- Abort completion
```

Common LSP servers configured:
- **lua_ls** - Lua language server
- **pyright** - Python language server
- **ts_ls** - TypeScript/JavaScript language server

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

## Tmux + Neovim Synergy - The Developer's Secret Weapon

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
# The developer's movement pattern:
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

#### Pattern 2: Multi-Project Development
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
<leader>w      # Save file (neovim)
Alt+l          # Move to terminal pane (tmux)
pytest tests/  # Run tests
Alt+j          # Move to log pane (tmux)
tail -f app.log # Watch logs
Alt+h          # Back to neovim (tmux)
<leader>p      # Find failing test file (neovim telescope)
gd             # Go to definition (neovim LSP)
# Fix bug, repeat cycle instantly
```

#### Example 2: Git Workflow Integration
```bash
# Editing multiple files in neovim
<leader>f      # Find files (telescope)
<leader>e TODO # Search for TODOs across project (live grep)
Tab            # Next buffer (neovim)
<leader>w      # Save current file
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
<leader>f      # Find files (telescope) - when you know the name
<leader>e      # Live grep (telescope) - when searching content
<leader>p      # File tree (nvim-tree) - when browsing structure
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

### The Developer Advantage

**Why this combination creates terminal mastery:**

1. **Zero Friction**: Moving between contexts feels like moving within a single application
2. **Muscle Memory**: Same navigation patterns work everywhere
3. **Persistent State**: Never lose your place, context, or mental model
4. **Visual Harmony**: Consistent theming reduces cognitive load
5. **Keyboard Flow**: Hands never leave home row, no mouse needed
6. **Scalable Complexity**: Handle multiple projects without losing focus

**The result**: A development environment that feels like an extension of your mind, where technical tools disappear and you focus purely on creating.