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
config_files := '.config/alacritty/alacritty.yml .config/mise/config.toml'
claude_files := '.claude/hooks.json .claude/settings.local.json'
git_commands := 'git-auto-commit.sh'

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
    @for file in {{git_commands}}; do \
        if [ -f "{{dotfiles_dir}}/$file" ]; then \
            target_name=$(echo "$file" | sed 's/\.sh$//'); \
            printf "{{green}}Installing git command: $target_name{{nc}}\n"; \
            ln -sf "{{dotfiles_dir}}/$file" "{{home_dir}}/.local/bin/$target_name"; \
            chmod +x "{{home_dir}}/.local/bin/$target_name"; \
        else \
            printf "{{yellow}}Warning: $file not found{{nc}}\n"; \
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
        sudo apt update && sudo apt install -y git tmux neovim curl build-essential fzf ripgrep xclip; \
    elif command -v brew > /dev/null; then \
        printf "{{yellow}}Using homebrew package manager...{{nc}}\n"; \
        brew install git tmux neovim curl fzf ripgrep; \
    elif command -v yum > /dev/null; then \
        printf "{{yellow}}Using yum package manager...{{nc}}\n"; \
        sudo yum install -y git tmux neovim curl fzf ripgrep xclip; \
    else \
        printf "{{red}}No supported package manager found. Please install dependencies manually:{{nc}}\n"; \
        printf "  git tmux neovim curl build-essential fzf ripgrep xclip\n"; \
        exit 1; \
    fi
    @printf "{{green}}Dependencies installed!{{nc}}\n"

# Install development tools (NVM, SDKMAN)
install-dev: install-deps
    @printf "{{blue}}Installing development tools...{{nc}}\n"
    @if [ ! -d "{{home_dir}}/.nvm" ]; then \
        printf "{{yellow}}Installing NVM...{{nc}}\n"; \
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash; \
    else \
        printf "{{green}}NVM already installed{{nc}}\n"; \
    fi
    @if [ ! -d "{{home_dir}}/.sdkman" ]; then \
        printf "{{yellow}}Installing SDKMAN...{{nc}}\n"; \
        curl -s "https://get.sdkman.io" | bash; \
    else \
        printf "{{green}}SDKMAN already installed{{nc}}\n"; \
    fi
    @printf "{{green}}Development tools installed!{{nc}}\n"

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
    @for file in {{git_commands}}; do \
        target_name=$(echo "$file" | sed 's/\.sh$//'); \
        target_file="{{home_dir}}/.local/bin/$target_name"; \
        if [ -L "$target_file" ]; then \
            printf "{{yellow}}Removing git command: $target_name{{nc}}\n"; \
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
    @printf "\n"
    @printf "{{yellow}}Git Commands:{{nc}}\n"
    @for file in {{git_commands}}; do \
        target_name=$(echo "$file" | sed 's/\.sh$//'); \
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

# Update dotfiles from git repository
update:
    @printf "{{blue}}Updating dotfiles...{{nc}}\n"
    @git pull origin master
    @printf "{{green}}Update complete!{{nc}}\n"
    @printf "{{yellow}}Reload your shell: source ~/.bashrc{{nc}}\n"