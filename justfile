
set shell := ['bash', '-c']

dotfiles_dir := justfile_directory()
home_dir := env_var('HOME')
xdg_config_dir := env_var('XDG_CONFIG_HOME')


# NOTE: Claude Code doesn't respect XDG_CONFIG_HOME and always uses ~/.claude
claude_config_dir := home_dir / '.claude'

# Files to manage
dotfiles := '.bashrc .tmux.conf .bash_profile .wezterm.lua'

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


install:  setup-tmux setup-claude
    @printf "{{blue}}Installing dotfiles...{{nc}}\n"
    @mkdir -p "{{home_dir}}/.config"
    @mkdir -p "{{home_dir}}/.local/bin"
    @# Link home directory dotfiles
    @for file in {{dotfiles}}; do \
        if [ -f "{{dotfiles_dir}}/$file" ]; then \
            printf "{{green}}Linking $file{{nc}}\n"; \
            ln -sf "{{dotfiles_dir}}/$file" "{{home_dir}}/$file"; \
        else \
            printf "{{yellow}}Warning: $file not found{{nc}}\n"; \
        fi \
    done
    @# Link all directories in .config/ except claude
    @if [ -d "{{dotfiles_dir}}/.config" ]; then \
        for dir in "{{dotfiles_dir}}/.config"/*; do \
            if [ -d "$dir" ]; then \
                dirname=$$(basename "$dir"); \
                if [ "$dirname" != "claude" ]; then \
                    printf "{{green}}Linking .config/$dirname{{nc}}\n"; \
                    ln -sf "$dir" "{{home_dir}}/.config/$dirname"; \
                fi; \
            fi; \
        done; \
    fi
    @printf "{{green}}Dotfiles installation complete!{{nc}}\n"
    @printf "{{yellow}}Run 'source ~/.bashrc' to reload your shell{{nc}}\n"

# Setup tmux plugin manager (TPM)
setup-tmux:
    @printf "{{blue}}Setting up tmux plugin manager (TPM)...{{nc}}\n"
    @if [ ! -d "{{home_dir}}/.tmux/plugins/tpm" ]; then \
        git clone https://github.com/tmux-plugins/tpm "{{home_dir}}/.tmux/plugins/tpm"; \
        "{{home_dir}}/.tmux/plugins/tpm/bin/install_plugins"; \
    else \
        "{{home_dir}}/.tmux/plugins/tpm/bin/update_plugins" all; \
    fi

# Setup Claude configuration
setup-claude:
    @printf "{{blue}}Setting up Claude configuration...{{nc}}\n"
    @mkdir -p "{{claude_config_dir}}"
    @printf "{{yellow}}Linking Claude configuration...{{nc}}\n"
    @if [ -d "{{dotfiles_dir}}/.config/claude" ]; then \
        for item in "{{dotfiles_dir}}/.config/claude"/*; do \
            if [ -e "$$item" ]; then \
                itemname=`basename "$$item"`; \
                printf "{{green}}Linking $$itemname{{nc}}\n"; \
                ln -sf "$$item" "{{claude_config_dir}}/$$itemname"; \
            fi; \
        done; \
    else \
        printf "{{yellow}}Warning: .config/claude directory not found{{nc}}\n"; \
    fi
    @# Make claude-activity-tracker.sh executable if it exists
    @if [ -f "{{claude_config_dir}}/claude-activity-tracker.sh" ]; then \
        chmod +x "{{claude_config_dir}}/claude-activity-tracker.sh"; \
        printf "{{green}}Made claude-activity-tracker.sh executable{{nc}}\n"; \
    fi
    @printf "{{green}}✓ Successfully configured Claude settings{{nc}}\n"


# Install system dependencies
install-deps:
    @printf "{{blue}}Installing system dependencies...{{nc}}\n"
    @if command -v pacman > /dev/null; then \
        printf "{{yellow}}Using pacman package manager...{{nc}}\n"; \
        sudo pacman -S --needed --noconfirm git curl base-devel xclip; \
    elif command -v apt > /dev/null; then \
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
    @# Remove home directory dotfiles
    @for file in {{dotfiles}}; do \
        target_file="{{home_dir}}/$file"; \
        if [ -L "$target_file" ]; then \
            printf "{{yellow}}Removing symlink: $file{{nc}}\n"; \
            rm "$target_file"; \
        fi \
    done
    @# Remove all .config/ directory symlinks except claude
    @if [ -d "{{home_dir}}/.config" ]; then \
        for link in "{{home_dir}}/.config"/*; do \
            if [ -L "$$link" ]; then \
                dirname=`basename "$$link"`; \
                if [ "$$dirname" != "claude" ]; then \
                    printf "{{yellow}}Removing symlink: .config/$$dirname{{nc}}\n"; \
                    rm "$$link"; \
                fi; \
            fi; \
        done; \
    fi
    @# Remove .gitconfig symlink
    @if [ -L "{{home_dir}}/.gitconfig" ]; then \
        printf "{{yellow}}Removing symlink: .gitconfig{{nc}}\n"; \
        rm "{{home_dir}}/.gitconfig"; \
    fi
    @# Remove all Claude configuration symlinks
    @printf "{{yellow}}Removing Claude configuration symlinks...{{nc}}\n"
    @if [ -d "{{claude_config_dir}}" ]; then \
        for item in "{{claude_config_dir}}"/*; do \
            if [ -L "$$item" ]; then \
                itemname=`basename "$$item"`; \
                printf "{{yellow}}Removing symlink: $$itemname{{nc}}\n"; \
                rm "$$item"; \
            fi; \
        done; \
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
