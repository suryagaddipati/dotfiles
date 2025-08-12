# Dotfiles management with just
# https://github.com/casey/just

# Set shell to bash
set shell := ['bash', '-c']

# Configuration
dotfiles_dir := justfile_directory()
home_dir := env_var('HOME')
nvim_config_dir := home_dir / '.config/nvim'
vim_dir := home_dir / '.vim'
alacritty_config_dir := home_dir / '.config/alacritty'
mise_config_dir := home_dir / '.config/mise'
claude_config_dir := home_dir / '.claude'
claude_global_dir := dotfiles_dir / 'claude-global-settings'

# Files to manage
dotfiles := '.bashrc .gitconfig .tmux.conf init.lua .bash_profile'
nvim_dirs := 'lua'
config_files := '.config/alacritty/alacritty.toml .config/mise/config.toml .config/mise/settings.toml'
claude_files := '.claude/hooks.json .claude/settings.local.json .claude/.mcp.json'
claude_dirs := '.claude/agents .claude/commands'
claude_scripts := '.claude/mcp-install.sh'
claude_commands := '.claude/local/claude'

# Colors
red := '\033[0;31m'
green := '\033[0;32m'
yellow := '\033[1;33m'
blue := '\033[0;34m'
nc := '\033[0m'

# Show available recipes
default:
    @printf "{{blue}}Dotfiles Management{{nc}}\n"
    @printf "\n"
    @just --list --unsorted

# Check if all prerequisites are installed
check-prereqs:
    @printf "{{blue}}Checking prerequisites...{{nc}}\n"
    @printf "=========================\n"
    @missing=0; \
    for cmd in git curl; do \
        if command -v "$cmd" > /dev/null 2>&1; then \
            printf "{{green}}✓{{nc}} $cmd found\n"; \
        else \
            printf "{{red}}✗{{nc}} $cmd not found\n"; \
            missing=1; \
        fi; \
    done; \
    for cmd in mise tmux nvim rg fzf; do \
        if command -v "$cmd" > /dev/null 2>&1; then \
            printf "{{green}}✓{{nc}} $cmd found\n"; \
        else \
            printf "{{yellow}}!{{nc}} $cmd not found (will be installed via mise)\n"; \
        fi; \
    done; \
    if command -v gcc > /dev/null 2>&1 || command -v clang > /dev/null 2>&1; then \
        printf "{{green}}✓{{nc}} build tools found\n"; \
    else \
        printf "{{red}}✗{{nc}} build tools (gcc/clang) not found\n"; \
        missing=1; \
    fi; \
    if [ "$missing" -eq 1 ]; then \
        printf "\n{{yellow}}Missing prerequisites detected.{{nc}}\n"; \
        printf "{{yellow}}Run 'just install-deps' to install missing tools.{{nc}}\n"; \
        exit 1; \
    else \
        printf "\n{{green}}All prerequisites satisfied!{{nc}}\n"; \
    fi

install: setup-nvim setup-tmux setup-claude
    @printf "{{blue}}Installing dotfiles...{{nc}}\n"
    @mkdir -p "{{nvim_config_dir}}"
    @mkdir -p "{{alacritty_config_dir}}"
    @mkdir -p "{{mise_config_dir}}"
    @mkdir -p "{{home_dir}}/.local/bin"
    @for file in {{dotfiles}}; do \
        if [ -f "{{dotfiles_dir}}/$file" ]; then \
            if [ "$file" = "init.lua" ]; then \
                printf "{{green}}Linking $file to nvim config{{nc}}\n"; \
                ln -sf "{{dotfiles_dir}}/$file" "{{nvim_config_dir}}/$file"; \
            else \
                printf "{{green}}Linking $file{{nc}}\n"; \
                ln -sf "{{dotfiles_dir}}/$file" "{{home_dir}}/$file"; \
            fi \
        else \
            printf "{{yellow}}Warning: $file not found{{nc}}\n"; \
        fi \
    done
    @for dir in {{nvim_dirs}}; do \
        if [ -d "{{dotfiles_dir}}/$dir" ]; then \
            printf "{{green}}Linking nvim $dir directory{{nc}}\n"; \
            ln -sf "{{dotfiles_dir}}/$dir" "{{nvim_config_dir}}/$dir"; \
        else \
            printf "{{yellow}}Warning: nvim $dir directory not found{{nc}}\n"; \
        fi \
    done
    @for file in {{config_files}}; do \
        if [ -f "{{dotfiles_dir}}/$file" ]; then \
            printf "{{green}}Linking $file{{nc}}\n"; \
            ln -sf "{{dotfiles_dir}}/$file" "{{home_dir}}/$file"; \
        else \
            printf "{{yellow}}Warning: $file not found{{nc}}\n"; \
        fi \
    done
    @printf "{{green}}Dotfiles installation complete!{{nc}}\n"
    @printf "{{yellow}}Run 'source ~/.bashrc' to reload your shell{{nc}}\n"

# Setup tmux plugin manager (TPM)
setup-tmux:
    @printf "{{blue}}Setting up tmux plugin manager (TPM)...{{nc}}\n"
    @if [ ! -d "{{home_dir}}/.tmux/plugins/tpm" ]; then \
        printf "{{yellow}}Installing TPM...{{nc}}\n"; \
        git clone https://github.com/tmux-plugins/tpm "{{home_dir}}/.tmux/plugins/tpm"; \
        printf "{{green}}TPM installed successfully{{nc}}\n"; \
        printf "{{yellow}}Installing tmux plugins...{{nc}}\n"; \
        "{{home_dir}}/.tmux/plugins/tpm/bin/install_plugins"; \
        printf "{{green}}Tmux plugins installed{{nc}}\n"; \
    else \
        printf "{{green}}TPM already installed{{nc}}\n"; \
        printf "{{yellow}}Updating tmux plugins...{{nc}}\n"; \
        "{{home_dir}}/.tmux/plugins/tpm/bin/update_plugins" all; \
    fi

# Setup neovim configuration and plugins
setup-nvim: check-nvim
    @printf "{{blue}}Setting up neovim configuration...{{nc}}\n"
    @mkdir -p "{{nvim_config_dir}}"
    @mkdir -p "{{vim_dir}}/plugin"
    @# Legacy vim plugin installation removed
    @printf "{{yellow}}Installing neovim plugins (this may take a moment)...{{nc}}\n"
    @nvim --headless "+Lazy! sync" +qa 2>/dev/null || printf "{{yellow}}Note: Plugins will be installed on first nvim startup{{nc}}\n"

# Check if neovim is available
check-nvim:
    @which nvim > /dev/null || (printf "{{red}}Error: neovim not found. Please install neovim first.{{nc}}\n" && exit 1)

# Setup Claude global settings
setup-claude:
    @printf "{{blue}}Setting up Claude global settings...{{nc}}\n"
    @# Save existing session-specific directories if they exist
    @if [ -e "{{claude_config_dir}}" ] && [ ! -L "{{claude_config_dir}}" ]; then \
        printf "{{yellow}}Backing up existing ~/.claude directory...{{nc}}\n"; \
        mkdir -p "{{claude_config_dir}}.backup"; \
        backup_dir="{{claude_config_dir}}.backup/$$(date +%Y%m%d_%H%M%S)"; \
        mv "{{claude_config_dir}}" "$$backup_dir"; \
        printf "{{yellow}}Preserving session-specific directories...{{nc}}\n"; \
        for dir in projects local shell-snapshots todos; do \
            if [ -d "$$backup_dir/$$dir" ]; then \
                mkdir -p "{{claude_global_dir}}/$$dir"; \
                cp -r "$$backup_dir/$$dir"/* "{{claude_global_dir}}/$$dir" 2>/dev/null || true; \
            fi; \
        done; \
    fi
    @# Remove existing symlink if it exists
    @if [ -L "{{claude_config_dir}}" ]; then \
        printf "{{yellow}}Removing existing symlink...{{nc}}\n"; \
        rm "{{claude_config_dir}}"; \
    fi
    @# Create symlink to claude-global-settings
    @printf "{{green}}Creating symlink from claude-global-settings to ~/.claude{{nc}}\n"
    @ln -sf "{{claude_global_dir}}" "{{claude_config_dir}}"
    @# Create session-specific directories if they don't exist
    @for dir in projects local shell-snapshots todos; do \
        mkdir -p "{{claude_config_dir}}/$$dir"; \
    done
    @# Verify the symlink was created successfully
    @if [ -L "{{claude_config_dir}}" ]; then \
        printf "{{green}}✓ Successfully installed Claude global settings{{nc}}\n"; \
    else \
        printf "{{red}}✗ Failed to create symlink{{nc}}\n"; \
        exit 1; \
    fi
    @# List key configuration files
    @printf "\n{{yellow}}Key Claude configuration files:{{nc}}\n"
    @[ -f "{{claude_config_dir}}/settings.json" ] && printf "  ✓ settings.json\n" || true
    @[ -f "{{claude_config_dir}}/settings.local.json" ] && printf "  ✓ settings.local.json\n" || true
    @[ -f "{{claude_config_dir}}/hooks.json" ] && printf "  ✓ hooks.json\n" || true
    @[ -d "{{claude_config_dir}}/agents" ] && printf "  ✓ agents/\n" || true
    @[ -d "{{claude_config_dir}}/commands" ] && printf "  ✓ commands/\n" || true
    @printf "\n{{yellow}}Session directories (not tracked in git):{{nc}}\n"
    @[ -d "{{claude_config_dir}}/projects" ] && printf "  ✓ projects/\n" || true
    @[ -d "{{claude_config_dir}}/local" ] && printf "  ✓ local/\n" || true
    @[ -d "{{claude_config_dir}}/shell-snapshots" ] && printf "  ✓ shell-snapshots/\n" || true
    @[ -d "{{claude_config_dir}}/todos" ] && printf "  ✓ todos/\n" || true

# Install system dependencies
install-deps:
    @printf "{{blue}}Installing system dependencies...{{nc}}\n"
    @if command -v apt > /dev/null; then \
        printf "{{yellow}}Using apt package manager...{{nc}}\n"; \
        sudo apt update && sudo apt install -y git curl build-essential xclip; \
    elif command -v brew > /dev/null; then \
        printf "{{yellow}}Using homebrew package manager...{{nc}}\n"; \
        brew install git curl; \
    elif command -v yum > /dev/null; then \
        printf "{{yellow}}Using yum package manager...{{nc}}\n"; \
        sudo yum install -y git curl xclip; \
    else \
        printf "{{red}}No supported package manager found. Please install dependencies manually:{{nc}}\n"; \
        printf "  git curl build-essential xclip\n"; \
        exit 1; \
    fi
    @just install-mise
    @just install-mise-tools
    @printf "{{green}}Dependencies installed!{{nc}}\n"

# Install mise (replaces NVM, SDKMAN, etc.)
install-mise:
    @printf "{{blue}}Installing mise...{{nc}}\n"
    @if command -v mise > /dev/null 2>&1; then \
        printf "{{green}}mise already installed{{nc}}\n"; \
    else \
        printf "{{yellow}}Installing mise...{{nc}}\n"; \
        curl https://mise.run | sh; \
        printf "{{yellow}}Adding mise to PATH...{{nc}}\n"; \
        echo 'export PATH="$$HOME/.local/bin:$$PATH"' >> ~/.bashrc; \
        export PATH="$$HOME/.local/bin:$$PATH"; \
    fi

# Install tools via mise (cross-platform)
install-mise-tools:
    @printf "{{blue}}Installing tools via mise...{{nc}}\n"
    @if command -v mise > /dev/null 2>&1; then \
        printf "{{yellow}}Installing neovim, tmux, and CLI utilities...{{nc}}\n"; \
        mise install; \
        printf "{{green}}Tools installed via mise!{{nc}}\n"; \
    else \
        printf "{{red}}mise not found. Run 'just install-mise' first.{{nc}}\n"; \
        exit 1; \
    fi

# Install development tools using mise
install-dev: install-deps
    @printf "{{blue}}Installing development tools with mise...{{nc}}\n"
    @if command -v mise > /dev/null 2>&1; then \
        printf "{{yellow}}Installing tools from mise config...{{nc}}\n"; \
        mise install; \
        printf "{{green}}Development tools installed via mise!{{nc}}\n"; \
    else \
        printf "{{red}}mise not found. Run 'just install-mise' first.{{nc}}\n"; \
        exit 1; \
    fi

# Install MCP servers for Claude Code
install-mcp: setup-claude
    @printf "{{blue}}Installing MCP servers for Claude Code...{{nc}}\n"
    @if [ -f "{{claude_config_dir}}/mcp-install.sh" ]; then \
        chmod +x "{{claude_config_dir}}/mcp-install.sh"; \
        "{{claude_config_dir}}/mcp-install.sh"; \
    else \
        printf "{{red}}MCP install script not found. Run 'just setup-claude' first.{{nc}}\n"; \
        exit 1; \
    fi

# Install language servers for neovim LSP
install-lsp:
    @printf "{{blue}}Installing language servers for neovim...{{nc}}\n"
    @if command -v mise > /dev/null 2>&1; then \
        printf "{{yellow}}Installing bash-language-server...{{nc}}\n"; \
        mise exec -- npm install -g bash-language-server; \
        printf "{{yellow}}Installing yaml-language-server...{{nc}}\n"; \
        mise exec -- npm install -g yaml-language-server; \
        printf "{{yellow}}Installing other language servers...{{nc}}\n"; \
        mise exec -- npm install -g typescript-language-server; \
        mise exec -- npm install -g vscode-langservers-extracted; \
        printf "{{green}}Language servers installed!{{nc}}\n"; \
    else \
        printf "{{red}}mise not found. Run 'just install-mise' first.{{nc}}\n"; \
        exit 1; \
    fi

uninstall:
    @printf "{{blue}}Removing dotfile symlinks...{{nc}}\n"
    @for file in {{dotfiles}}; do \
        target_file="{{home_dir}}/$file"; \
        if [ "$file" = "init.lua" ]; then \
            target_file="{{nvim_config_dir}}/$file"; \
        fi; \
        if [ -L "$target_file" ]; then \
            printf "{{yellow}}Removing symlink: $file{{nc}}\n"; \
            rm "$target_file"; \
        fi \
    done
    @for dir in {{nvim_dirs}}; do \
        target_dir="{{nvim_config_dir}}/$dir"; \
        if [ -L "$target_dir" ]; then \
            printf "{{yellow}}Removing symlink: nvim $dir{{nc}}\n"; \
            rm "$target_dir"; \
        fi \
    done
    @for file in {{config_files}}; do \
        target_file="{{home_dir}}/$file"; \
        if [ -L "$target_file" ]; then \
            printf "{{yellow}}Removing symlink: $file{{nc}}\n"; \
            rm "$target_file"; \
        fi \
    done
    @# Remove Claude symlink
    @if [ -L "{{claude_config_dir}}" ]; then \
        printf "{{yellow}}Removing Claude global settings symlink{{nc}}\n"; \
        rm "{{claude_config_dir}}"; \
    fi
    @printf "{{green}}Dotfiles uninstalled{{nc}}\n"


quick-install: install

full-install: install-deps install install-dev install-lsp
    @printf "\n"
    @printf "{{green}}🎉 Full installation complete!{{nc}}\n"
    @printf "{{yellow}}Next steps:{{nc}}\n"
    @printf "  1. Restart your terminal or run: source ~/.bashrc\n"
    @printf "  2. Start tmux: tmux or t\n"
    @printf "  3. Open neovim: nvim (plugins will install automatically)\n"
    @printf "  4. Install MCP servers: just install-mcp\n"

# Check Claude settings status
status-claude:
    @printf "{{blue}}Claude Global Settings Status{{nc}}\n"
    @printf "============================\n"
    @if [ -L "{{claude_config_dir}}" ]; then \
        printf "{{green}}✓{{nc}} ~/.claude is symlinked to: "; \
        readlink "{{claude_config_dir}}"; \
    else \
        printf "{{red}}✗{{nc}} ~/.claude is not symlinked\n"; \
    fi
    @printf "\n{{yellow}}Configuration files:{{nc}}\n"
    @[ -f "{{claude_config_dir}}/settings.json" ] && printf "  {{green}}✓{{nc}} settings.json\n" || printf "  {{red}}✗{{nc}} settings.json\n"
    @[ -f "{{claude_config_dir}}/settings.local.json" ] && printf "  {{green}}✓{{nc}} settings.local.json\n" || printf "  {{red}}✗{{nc}} settings.local.json\n"
    @[ -f "{{claude_config_dir}}/hooks.json" ] && printf "  {{green}}✓{{nc}} hooks.json\n" || printf "  {{red}}✗{{nc}} hooks.json\n"
    @[ -f "{{claude_config_dir}}/mcp-install.sh" ] && printf "  {{green}}✓{{nc}} mcp-install.sh\n" || printf "  {{red}}✗{{nc}} mcp-install.sh\n"
    @printf "\n{{yellow}}Tracked directories (in git):{{nc}}\n"
    @if [ -d "{{claude_config_dir}}/agents" ]; then \
        count=`find {{claude_config_dir}}/agents -name "*.md" -type f | wc -l | tr -d ' '`; \
        printf "  {{green}}✓{{nc}} agents/ ($count agents)\n"; \
    else \
        printf "  {{red}}✗{{nc}} agents/\n"; \
    fi
    @if [ -d "{{claude_config_dir}}/commands" ]; then \
        count=`find {{claude_config_dir}}/commands -name "*.md" -type f | wc -l | tr -d ' '`; \
        printf "  {{green}}✓{{nc}} commands/ ($count commands)\n"; \
    else \
        printf "  {{red}}✗{{nc}} commands/\n"; \
    fi
    @printf "\n{{yellow}}Session directories (not tracked):{{nc}}\n"
    @[ -d "{{claude_config_dir}}/projects" ] && printf "  {{green}}✓{{nc}} projects/ (conversation history)\n" || printf "  {{yellow}}○{{nc}} projects/ (will be created on use)\n"
    @[ -d "{{claude_config_dir}}/todos" ] && printf "  {{green}}✓{{nc}} todos/ (task tracking)\n" || printf "  {{yellow}}○{{nc}} todos/ (will be created on use)\n"
    @[ -d "{{claude_config_dir}}/local" ] && printf "  {{green}}✓{{nc}} local/ (Claude CLI)\n" || printf "  {{yellow}}○{{nc}} local/ (will be created on use)\n"
    @[ -d "{{claude_config_dir}}/shell-snapshots" ] && printf "  {{green}}✓{{nc}} shell-snapshots/ (shell history)\n" || printf "  {{yellow}}○{{nc}} shell-snapshots/ (will be created on use)\n"

# Update dotfiles from git repository
update:
    @printf "{{blue}}Updating dotfiles...{{nc}}\n"
    @git pull origin master
    @printf "{{green}}Update complete!{{nc}}\n"
    @printf "{{yellow}}Reload your shell: source ~/.bashrc{{nc}}\n"

# Generate Brewfile from current Homebrew installation
brewfile-dump:
    @printf "{{blue}}Generating Brewfile from current installation...{{nc}}\n"
    @brew bundle dump --force --file="{{dotfiles_dir}}/Brewfile"
    @printf "{{green}}Brewfile generated successfully!{{nc}}\n"

# Install packages from Brewfile
brewfile-install:
    @printf "{{blue}}Installing packages from Brewfile...{{nc}}\n"
    @if [ -f "{{dotfiles_dir}}/Brewfile" ]; then \
        brew bundle install --file="{{dotfiles_dir}}/Brewfile"; \
        printf "{{green}}Brewfile packages installed successfully!{{nc}}\n"; \
    else \
        printf "{{red}}Brewfile not found at {{dotfiles_dir}}/Brewfile{{nc}}\n"; \
        exit 1; \
    fi

# Check Brewfile status (what would be installed/removed)
brewfile-check:
    @printf "{{blue}}Checking Brewfile status...{{nc}}\n"
    @if [ -f "{{dotfiles_dir}}/Brewfile" ]; then \
        brew bundle check --file="{{dotfiles_dir}}/Brewfile" --verbose; \
    else \
        printf "{{red}}Brewfile not found at {{dotfiles_dir}}/Brewfile{{nc}}\n"; \
        exit 1; \
    fi

# Clean up packages not in Brewfile
brewfile-cleanup:
    @printf "{{yellow}}Warning: This will remove packages not listed in the Brewfile!{{nc}}\n"
    @printf "{{yellow}}Press Ctrl-C to cancel, or wait 5 seconds to continue...{{nc}}\n"
    @sleep 5
    @if [ -f "{{dotfiles_dir}}/Brewfile" ]; then \
        brew bundle cleanup --file="{{dotfiles_dir}}/Brewfile"; \
    else \
        printf "{{red}}Brewfile not found at {{dotfiles_dir}}/Brewfile{{nc}}\n"; \
        exit 1; \
    fi

# List packages installed but not in Brewfile
brewfile-diff:
    @printf "{{blue}}Packages installed but not in Brewfile:{{nc}}\n"
    @if [ -f "{{dotfiles_dir}}/Brewfile" ]; then \
        brew bundle cleanup --file="{{dotfiles_dir}}/Brewfile" --force; \
    else \
        printf "{{red}}Brewfile not found at {{dotfiles_dir}}/Brewfile{{nc}}\n"; \
        exit 1; \
    fi
