# Dotfiles management with just
# https://github.com/casey/just

# Set shell to bash
set shell := ['bash', '-c']

# Configuration
dotfiles_dir := justfile_directory()
home_dir := env_var('HOME')
backup_dir := home_dir / '.dotfiles_backup'
nvim_config_dir := home_dir / '.config/nvim'
vim_dir := home_dir / '.vim'
alacritty_config_dir := home_dir / '.config/alacritty'
mise_config_dir := home_dir / '.config/mise'
claude_config_dir := home_dir / '.claude'

# Files to manage
dotfiles := '.bashrc .gitconfig .tmux.conf init.lua'
config_files := '.config/alacritty/alacritty.toml .config/wezterm/wezterm.lua .config/mise/config.toml'
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

# Install all dotfiles (with backup)
install: backup setup-nvim
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

# Backup existing configuration files
backup:
    @printf "{{blue}}Creating backup directory...{{nc}}\n"
    @mkdir -p "{{backup_dir}}"
    @printf "{{blue}}Backing up existing configurations...{{nc}}\n"
    @for file in {{dotfiles}}; do \
        target_file="{{home_dir}}/$file"; \
        if [ "$file" = "init.lua" ]; then \
            target_file="{{nvim_config_dir}}/$file"; \
        fi; \
        if [ -f "$target_file" ] && [ ! -L "$target_file" ]; then \
            printf "{{yellow}}Backing up $file{{nc}}\n"; \
            cp "$target_file" "{{backup_dir}}/$file.backup"; \
        fi \
    done
    @for file in {{config_files}}; do \
        target_file="{{home_dir}}/$file"; \
        if [ -f "$target_file" ] && [ ! -L "$target_file" ]; then \
            printf "{{yellow}}Backing up $file{{nc}}\n"; \
            mkdir -p "{{backup_dir}}/$(dirname "$file")"; \
            cp "$target_file" "{{backup_dir}}/$file.backup"; \
        fi \
    done
    @for file in {{claude_files}}; do \
        target_file="{{home_dir}}/$file"; \
        if [ -f "$target_file" ] && [ ! -L "$target_file" ]; then \
            printf "{{yellow}}Backing up $file{{nc}}\n"; \
            mkdir -p "{{backup_dir}}/$(dirname "$file")"; \
            cp "$target_file" "{{backup_dir}}/$file.backup"; \
        fi \
    done
    @printf "{{green}}Backup complete in {{backup_dir}}{{nc}}\n"

# Restore original configuration files from backup
restore:
    @printf "{{blue}}Restoring from backup...{{nc}}\n"
    @if [ ! -d "{{backup_dir}}" ]; then \
        printf "{{red}}No backup directory found!{{nc}}\n"; \
        exit 1; \
    fi
    @for file in {{dotfiles}}; do \
        if [ -f "{{backup_dir}}/$file.backup" ]; then \
            printf "{{yellow}}Restoring $file{{nc}}\n"; \
            target_file="{{home_dir}}/$file"; \
            if [ "$file" = "init.lua" ]; then \
                target_file="{{nvim_config_dir}}/$file"; \
            fi; \
            cp "{{backup_dir}}/$file.backup" "$target_file"; \
        fi \
    done
    @printf "{{green}}Restore complete!{{nc}}\n"

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

# Remove dotfile symlinks (keeps backups)
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
    @printf "{{yellow}}Backups preserved in {{backup_dir}}{{nc}}\n"

# Show installation status
status:
    @printf "{{blue}}Dotfiles Status{{nc}}\n"
    @printf "=================\n"
    @printf "{{yellow}}Dotfiles Directory:{{nc}} {{dotfiles_dir}}\n"
    @printf "{{yellow}}Backup Directory:{{nc}} {{backup_dir}}\n"
    @printf "\n"
    @printf "{{yellow}}Configuration Files:{{nc}}\n"
    @for file in {{dotfiles}}; do \
        target_file="{{home_dir}}/$file"; \
        if [ "$file" = "init.lua" ]; then \
            target_file="{{nvim_config_dir}}/$file"; \
        fi; \
        if [ -L "$target_file" ]; then \
            link_target=$(readlink "$target_file"); \
            if [ "$link_target" = "{{dotfiles_dir}}/$file" ]; then \
                printf "  {{green}}✓{{nc}} $file → {{dotfiles_dir}}/$file\n"; \
            else \
                printf "  {{yellow}}⚠{{nc}} $file → $link_target (wrong target)\n"; \
            fi; \
        elif [ -f "$target_file" ]; then \
            printf "  {{red}}✗{{nc}} $file (regular file, not symlinked)\n"; \
        else \
            printf "  {{red}}✗{{nc}} $file (not found)\n"; \
        fi; \
    done
    @for file in {{config_files}}; do \
        target_file="{{home_dir}}/$file"; \
        if [ -L "$target_file" ]; then \
            link_target=$(readlink "$target_file"); \
            if [ "$link_target" = "{{dotfiles_dir}}/$file" ]; then \
                printf "  {{green}}✓{{nc}} $file → {{dotfiles_dir}}/$file\n"; \
            else \
                printf "  {{yellow}}⚠{{nc}} $file → $link_target (wrong target)\n"; \
            fi; \
        elif [ -f "$target_file" ]; then \
            printf "  {{red}}✗{{nc}} $file (regular file, not symlinked)\n"; \
        else \
            printf "  {{red}}✗{{nc}} $file (not found)\n"; \
        fi; \
    done
    @for file in {{claude_files}}; do \
        target_file="{{home_dir}}/$file"; \
        if [ -L "$target_file" ]; then \
            link_target=$(readlink "$target_file"); \
            if [ "$link_target" = "{{dotfiles_dir}}/$file" ]; then \
                printf "  {{green}}✓{{nc}} $file → {{dotfiles_dir}}/$file\n"; \
            else \
                printf "  {{yellow}}⚠{{nc}} $file → $link_target (wrong target)\n"; \
            fi; \
        elif [ -f "$target_file" ]; then \
            printf "  {{red}}✗{{nc}} $file (regular file, not symlinked)\n"; \
        else \
            printf "  {{red}}✗{{nc}} $file (not found)\n"; \
        fi; \
    done
    @for dir in {{claude_dirs}}; do \
        target_dir="{{home_dir}}/$dir"; \
        if [ -L "$target_dir" ]; then \
            link_target=$(readlink "$target_dir"); \
            if [ "$link_target" = "{{dotfiles_dir}}/$dir" ]; then \
                printf "  {{green}}✓{{nc}} $dir → {{dotfiles_dir}}/$dir\n"; \
            else \
                printf "  {{yellow}}⚠{{nc}} $dir → $link_target (wrong target)\n"; \
            fi; \
        elif [ -d "$target_dir" ]; then \
            printf "  {{red}}✗{{nc}} $dir (regular directory, not symlinked)\n"; \
        else \
            printf "  {{red}}✗{{nc}} $dir (not found)\n"; \
        fi; \
    done
    @printf "\n"
    @printf "{{yellow}}Git Commands:{{nc}}\n"
    @for file in {{git_commands}}; do \
        target_name=$(basename "$file" .sh); \
        target_file="{{home_dir}}/.local/bin/$target_name"; \
        if [ -L "$target_file" ]; then \
            link_target=$(readlink "$target_file"); \
            if [ "$link_target" = "{{dotfiles_dir}}/$file" ]; then \
                printf "  {{green}}✓{{nc}} $target_name → {{dotfiles_dir}}/$file\n"; \
            else \
                printf "  {{yellow}}⚠{{nc}} $target_name → $link_target (wrong target)\n"; \
            fi; \
        elif [ -f "$target_file" ]; then \
            printf "  {{red}}✗{{nc}} $target_name (regular file, not symlinked)\n"; \
        else \
            printf "  {{red}}✗{{nc}} $target_name (not found)\n"; \
        fi; \
    done
    @printf "\n"
    @printf "{{yellow}}Claude Commands:{{nc}}\n"
    @for file in {{claude_commands}}; do \
        target_name="claude"; \
        target_file="{{home_dir}}/.local/bin/$target_name"; \
        if [ -L "$target_file" ]; then \
            link_target=$(readlink "$target_file"); \
            if [ "$link_target" = "{{home_dir}}/$file" ]; then \
                printf "  {{green}}✓{{nc}} $target_name → {{home_dir}}/$file\n"; \
            else \
                printf "  {{yellow}}⚠{{nc}} $target_name → $link_target (wrong target)\n"; \
            fi; \
        elif [ -f "$target_file" ]; then \
            printf "  {{red}}✗{{nc}} $target_name (regular file, not symlinked)\n"; \
        else \
            printf "  {{red}}✗{{nc}} $target_name (not found)\n"; \
        fi; \
    done
    @printf "\n"
    @printf "{{yellow}}Neovim Setup:{{nc}}\n"
    @if [ -f "{{nvim_config_dir}}/init.lua" ]; then \
        printf "  {{green}}✓{{nc}} init.lua linked\n"; \
    else \
        printf "  {{red}}✗{{nc}} init.lua not linked\n"; \
    fi
    @if [ -d "{{home_dir}}/.local/share/nvim/lazy" ]; then \
        printf "  {{green}}✓{{nc}} lazy.nvim plugin manager installed\n"; \
    else \
        printf "  {{red}}✗{{nc}} lazy.nvim not installed\n"; \
    fi
    @# Legacy vim plugin check removed

# Clean up backup files and neovim plugins
clean:
    @printf "{{blue}}Cleaning up...{{nc}}\n"
    @if [ -d "{{backup_dir}}" ]; then \
        printf "{{yellow}}Removing backup directory...{{nc}}\n"; \
        rm -rf "{{backup_dir}}"; \
    fi
    @if [ -d "{{home_dir}}/.local/share/nvim" ]; then \
        printf "{{yellow}}Cleaning neovim plugins...{{nc}}\n"; \
        rm -rf "{{home_dir}}/.local/share/nvim"; \
    fi
    @if [ -d "{{vim_dir}}/plugged" ]; then \
        printf "{{yellow}}Cleaning vim plugins...{{nc}}\n"; \
        rm -rf "{{vim_dir}}/plugged"; \
    fi
    @printf "{{green}}Cleanup complete!{{nc}}\n"

# Quick install without dependencies
quick-install: backup install

# Full installation with all dependencies and dev tools
full-install: install-deps install install-dev
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