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

# Files to manage
dotfiles := '.bashrc .gitconfig .tmux.conf init.lua .bash_profile'
nvim_dirs := 'lua'
config_files := '.config/alacritty/alacritty.toml .config/mise/config.toml'
claude_files := '.claude/hooks.json .claude/settings.local.json .claude/.mcp.json'
claude_dirs := '.claude/agents .claude/commands'
claude_scripts := '.claude/mcp-install.sh'
git_commands := 'git-commands/git-auto-commit.sh'
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

install: setup-nvim
    @printf "{{blue}}Installing dotfiles...{{nc}}\n"
    @mkdir -p "{{nvim_config_dir}}"
    @mkdir -p "{{alacritty_config_dir}}"
    @mkdir -p "{{mise_config_dir}}"
    @mkdir -p "{{claude_config_dir}}"
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
    @for file in {{claude_files}}; do \
        if [ -f "{{dotfiles_dir}}/$file" ]; then \
            printf "{{green}}Linking $file{{nc}}\n"; \
            ln -sf "{{dotfiles_dir}}/$file" "{{home_dir}}/$file"; \
        else \
            printf "{{yellow}}Warning: $file not found{{nc}}\n"; \
        fi \
    done
    @for dir in {{claude_dirs}}; do \
        if [ -d "{{dotfiles_dir}}/$dir" ]; then \
            printf "{{green}}Linking $dir{{nc}}\n"; \
            ln -sf "{{dotfiles_dir}}/$dir" "{{home_dir}}/$dir"; \
        else \
            printf "{{yellow}}Warning: $dir not found{{nc}}\n"; \
        fi \
    done
    @for file in {{git_commands}}; do \
        if [ -f "{{dotfiles_dir}}/$file" ]; then \
            target_name=$(basename "$file" .sh); \
            printf "{{green}}Installing git command: $target_name{{nc}}\n"; \
            ln -sf "{{dotfiles_dir}}/$file" "{{home_dir}}/.local/bin/$target_name"; \
            chmod +x "{{home_dir}}/.local/bin/$target_name"; \
        else \
            printf "{{yellow}}Warning: $file not found{{nc}}\n"; \
        fi \
    done
    @for file in {{claude_scripts}}; do \
        if [ -f "{{dotfiles_dir}}/$file" ]; then \
            printf "{{green}}Linking $file{{nc}}\n"; \
            ln -sf "{{dotfiles_dir}}/$file" "{{home_dir}}/$file"; \
            chmod +x "{{home_dir}}/$file"; \
        else \
            printf "{{yellow}}Warning: $file not found{{nc}}\n"; \
        fi \
    done
    @mkdir -p "{{claude_config_dir}}/commands"
    @if [ -d "{{dotfiles_dir}}/.claude/commands" ]; then \
        for command_file in "{{dotfiles_dir}}/.claude/commands"/*.md; do \
            if [ -f "$command_file" ]; then \
                command=$(basename "$command_file"); \
                printf "{{green}}Copying Claude command: $command{{nc}}\n"; \
                if [ ! -f "{{claude_config_dir}}/commands/$command" ] || ! cmp -s "$command_file" "{{claude_config_dir}}/commands/$command"; then \
                    cp "$command_file" "{{claude_config_dir}}/commands/$command"; \
                fi; \
            fi; \
        done; \
    fi
    @for file in {{claude_commands}}; do \
        if [ -f "{{home_dir}}/$file" ]; then \
            target_name="claude"; \
            printf "{{green}}Installing claude command: $target_name{{nc}}\n"; \
            ln -sf "{{home_dir}}/$file" "{{home_dir}}/.local/bin/$target_name"; \
            chmod +x "{{home_dir}}/.local/bin/$target_name"; \
        else \
            printf "{{yellow}}Warning: $file not found (expected at {{home_dir}}/$file){{nc}}\n"; \
        fi \
    done
    @printf "{{green}}Dotfiles installation complete!{{nc}}\n"
    @printf "{{yellow}}Run 'source ~/.bashrc' to reload your shell{{nc}}\n"

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
install-mcp:
    @printf "{{blue}}Installing MCP servers for Claude Code...{{nc}}\n"
    @if [ -f "{{home_dir}}/.claude/mcp-install.sh" ]; then \
        chmod +x "{{home_dir}}/.claude/mcp-install.sh"; \
        "{{home_dir}}/.claude/mcp-install.sh"; \
    else \
        printf "{{red}}MCP install script not found. Run 'just install' first.{{nc}}\n"; \
        exit 1; \
    fi

# Install language servers for neovim LSP
install-lsp:
    @printf "{{blue}}Installing language servers for neovim...{{nc}}\n"
    @if command -v mise > /dev/null 2>&1; then \
        printf "{{yellow}}Installing bash-language-server...{{nc}}\n"; \
        mise exec -- npm install -g bash-language-server; \
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
    @for file in {{claude_files}}; do \
        target_file="{{home_dir}}/$file"; \
        if [ -L "$target_file" ]; then \
            printf "{{yellow}}Removing symlink: $file{{nc}}\n"; \
            rm "$target_file"; \
        fi \
    done
    @for dir in {{claude_dirs}}; do \
        target_dir="{{home_dir}}/$dir"; \
        if [ -L "$target_dir" ]; then \
            printf "{{yellow}}Removing symlink: $dir{{nc}}\n"; \
            rm "$target_dir"; \
        fi \
    done
    @for file in {{git_commands}}; do \
        target_name=$(basename "$file" .sh); \
        target_file="{{home_dir}}/.local/bin/$target_name"; \
        if [ -L "$target_file" ]; then \
            printf "{{yellow}}Removing git command: $target_name{{nc}}\n"; \
            rm "$target_file"; \
        fi \
    done
    @for file in {{claude_commands}}; do \
        target_name="claude"; \
        target_file="{{home_dir}}/.local/bin/$target_name"; \
        if [ -L "$target_file" ]; then \
            printf "{{yellow}}Removing claude command: $target_name{{nc}}\n"; \
            rm "$target_file"; \
        fi \
    done
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

# Update dotfiles from git repository
update:
    @printf "{{blue}}Updating dotfiles...{{nc}}\n"
    @git pull origin master
    @printf "{{green}}Update complete!{{nc}}\n"
    @printf "{{yellow}}Reload your shell: source ~/.bashrc{{nc}}\n"
