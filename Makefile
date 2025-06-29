# Dotfiles Management Makefile
# Automates installation, backup, and management of configuration files

# Configuration
SHELL := /bin/bash
DOTFILES_DIR := $(shell pwd)
HOME_DIR := $(HOME)
VIM_DIR := $(HOME_DIR)/.vim
BACKUP_DIR := $(HOME_DIR)/.dotfiles_backup

# Files to manage
DOTFILES := .bashrc .gitconfig .tmux.conf init.lua
VIM_PLUGINS := DisableNonCountedBasicMotions.vim
TMUX_SCRIPTS := tmux.bash
NVIM_CONFIG_DIR := $(HOME_DIR)/.config/nvim

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

.PHONY: help install backup restore clean check-nvim setup-nvim install-deps uninstall status

# Default target
help: ## Show this help message
	@echo "$(BLUE)Dotfiles Management$(NC)"
	@echo ""
	@echo "$(YELLOW)Available targets:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(YELLOW)Examples:$(NC)"
	@echo "  make install     # Install all configurations"
	@echo "  make backup      # Backup existing configs"
	@echo "  make status      # Check installation status"

install: backup setup-nvim ## Install all dotfiles (with backup)
	@echo "$(BLUE)Installing dotfiles...$(NC)"
	@mkdir -p "$(NVIM_CONFIG_DIR)"
	@for file in $(DOTFILES); do \
		if [ -f "$(DOTFILES_DIR)/$$file" ]; then \
			if [ "$$file" = "init.lua" ]; then \
				echo "$(GREEN)Linking $$file to nvim config$(NC)"; \
				ln -sf "$(DOTFILES_DIR)/$$file" "$(NVIM_CONFIG_DIR)/$$file"; \
			else \
				echo "$(GREEN)Linking $$file$(NC)"; \
				ln -sf "$(DOTFILES_DIR)/$$file" "$(HOME_DIR)/$$file"; \
			fi \
		else \
			echo "$(YELLOW)Warning: $$file not found$(NC)"; \
		fi \
	done
	@echo "$(GREEN)Dotfiles installation complete!$(NC)"
	@echo "$(YELLOW)Run 'source ~/.bashrc' to reload your shell$(NC)"

backup: ## Backup existing configuration files
	@echo "$(BLUE)Creating backup directory...$(NC)"
	@mkdir -p "$(BACKUP_DIR)"
	@echo "$(BLUE)Backing up existing configurations...$(NC)"
	@for file in $(DOTFILES); do \
		if [ -f "$(HOME_DIR)/$$file" ] && [ ! -L "$(HOME_DIR)/$$file" ]; then \
			echo "$(YELLOW)Backing up $$file$(NC)"; \
			cp "$(HOME_DIR)/$$file" "$(BACKUP_DIR)/$$file.backup"; \
		fi \
	done
	@echo "$(GREEN)Backup complete in $(BACKUP_DIR)$(NC)"

restore: ## Restore original configuration files from backup
	@echo "$(BLUE)Restoring from backup...$(NC)"
	@if [ ! -d "$(BACKUP_DIR)" ]; then \
		echo "$(RED)No backup directory found!$(NC)"; \
		exit 1; \
	fi
	@for file in $(DOTFILES); do \
		if [ -f "$(BACKUP_DIR)/$$file.backup" ]; then \
			echo "$(YELLOW)Restoring $$file$(NC)"; \
			cp "$(BACKUP_DIR)/$$file.backup" "$(HOME_DIR)/$$file"; \
		fi \
	done
	@echo "$(GREEN)Restore complete!$(NC)"

setup-nvim: check-nvim ## Setup neovim configuration and plugins
	@echo "$(BLUE)Setting up neovim configuration...$(NC)"
	@mkdir -p "$(NVIM_CONFIG_DIR)"
	@mkdir -p "$(VIM_DIR)/plugin"
	@if [ -f "$(DOTFILES_DIR)/$(VIM_PLUGINS)" ]; then \
		echo "$(GREEN)Installing vim plugin: $(VIM_PLUGINS)$(NC)"; \
		cp "$(DOTFILES_DIR)/$(VIM_PLUGINS)" "$(VIM_DIR)/plugin/"; \
	fi
	@echo "$(YELLOW)Installing neovim plugins (this may take a moment)...$(NC)"
	@nvim --headless "+Lazy! sync" +qa 2>/dev/null || echo "$(YELLOW)Note: Plugins will be installed on first nvim startup$(NC)"

check-nvim: ## Check if neovim is available
	@which nvim > /dev/null || (echo "$(RED)Error: neovim not found. Please install neovim first.$(NC)" && exit 1)

install-deps: ## Install system dependencies
	@echo "$(BLUE)Installing system dependencies...$(NC)"
	@if command -v apt > /dev/null; then \
		echo "$(YELLOW)Using apt package manager...$(NC)"; \
		sudo apt update && sudo apt install -y git tmux neovim curl build-essential fzf ripgrep xclip; \
	elif command -v brew > /dev/null; then \
		echo "$(YELLOW)Using homebrew package manager...$(NC)"; \
		brew install git tmux neovim curl fzf ripgrep; \
	elif command -v yum > /dev/null; then \
		echo "$(YELLOW)Using yum package manager...$(NC)"; \
		sudo yum install -y git tmux neovim curl fzf ripgrep xclip; \
	else \
		echo "$(RED)No supported package manager found. Please install dependencies manually:$(NC)"; \
		echo "  git tmux neovim curl build-essential fzf ripgrep xclip"; \
		exit 1; \
	fi
	@echo "$(GREEN)Dependencies installed!$(NC)"

install-dev: install-deps ## Install development tools (NVM, SDKMAN)
	@echo "$(BLUE)Installing development tools...$(NC)"
	@if [ ! -d "$(HOME_DIR)/.nvm" ]; then \
		echo "$(YELLOW)Installing NVM...$(NC)"; \
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash; \
	else \
		echo "$(GREEN)NVM already installed$(NC)"; \
	fi
	@if [ ! -d "$(HOME_DIR)/.sdkman" ]; then \
		echo "$(YELLOW)Installing SDKMAN...$(NC)"; \
		curl -s "https://get.sdkman.io" | bash; \
	else \
		echo "$(GREEN)SDKMAN already installed$(NC)"; \
	fi
	@echo "$(GREEN)Development tools installed!$(NC)"

uninstall: ## Remove dotfile symlinks (keeps backups)
	@echo "$(BLUE)Removing dotfile symlinks...$(NC)"
	@for file in $(DOTFILES); do \
		if [ -L "$(HOME_DIR)/$$file" ]; then \
			echo "$(YELLOW)Removing symlink: $$file$(NC)"; \
			rm "$(HOME_DIR)/$$file"; \
		fi \
	done
	@echo "$(GREEN)Dotfiles uninstalled$(NC)"
	@echo "$(YELLOW)Backups preserved in $(BACKUP_DIR)$(NC)"

status: ## Show installation status
	@echo "$(BLUE)Dotfiles Status$(NC)"
	@echo "================="
	@echo "$(YELLOW)Dotfiles Directory:$(NC) $(DOTFILES_DIR)"
	@echo "$(YELLOW)Backup Directory:$(NC) $(BACKUP_DIR)"
	@echo ""
	@echo "$(YELLOW)Configuration Files:$(NC)"
	@for file in $(DOTFILES); do \
		if [ -L "$(HOME_DIR)/$$file" ]; then \
			target=$$(readlink "$(HOME_DIR)/$$file"); \
			if [ "$$target" = "$(DOTFILES_DIR)/$$file" ]; then \
				echo "  $(GREEN)✓$(NC) $$file → $(DOTFILES_DIR)/$$file"; \
			else \
				echo "  $(YELLOW)⚠$(NC) $$file → $$target (wrong target)"; \
			fi \
		elif [ -f "$(HOME_DIR)/$$file" ]; then \
			echo "  $(RED)✗$(NC) $$file (regular file, not symlinked)"; \
		else \
			echo "  $(RED)✗$(NC) $$file (not found)"; \
		fi \
	done
	@echo ""
	@echo "$(YELLOW)Neovim Setup:$(NC)"
	@if [ -f "$(NVIM_CONFIG_DIR)/init.lua" ]; then \
		echo "  $(GREEN)✓$(NC) init.lua linked"; \
	else \
		echo "  $(RED)✗$(NC) init.lua not linked"; \
	fi
	@if [ -d "$(HOME_DIR)/.local/share/nvim/lazy" ]; then \
		echo "  $(GREEN)✓$(NC) lazy.nvim plugin manager installed"; \
	else \
		echo "  $(RED)✗$(NC) lazy.nvim not installed"; \
	fi
	@if [ -f "$(VIM_DIR)/plugin/$(VIM_PLUGINS)" ]; then \
		echo "  $(GREEN)✓$(NC) $(VIM_PLUGINS) installed"; \
	else \
		echo "  $(RED)✗$(NC) $(VIM_PLUGINS) not installed"; \
	fi

clean: ## Clean up backup files and neovim plugins
	@echo "$(BLUE)Cleaning up...$(NC)"
	@if [ -d "$(BACKUP_DIR)" ]; then \
		echo "$(YELLOW)Removing backup directory...$(NC)"; \
		rm -rf "$(BACKUP_DIR)"; \
	fi
	@if [ -d "$(HOME_DIR)/.local/share/nvim" ]; then \
		echo "$(YELLOW)Cleaning neovim plugins...$(NC)"; \
		rm -rf "$(HOME_DIR)/.local/share/nvim"; \
	fi
	@if [ -d "$(VIM_DIR)/plugged" ]; then \
		echo "$(YELLOW)Cleaning vim plugins...$(NC)"; \
		rm -rf "$(VIM_DIR)/plugged"; \
	fi
	@echo "$(GREEN)Cleanup complete!$(NC)"

# Quick installation without prompts
quick-install: ## Quick install without dependencies
	@$(MAKE) --no-print-directory backup install

# Full installation with all dependencies
full-install: ## Full installation with all dependencies and dev tools
	@$(MAKE) --no-print-directory install-deps install install-dev
	@echo ""
	@echo "$(GREEN)🎉 Full installation complete!$(NC)"
	@echo "$(YELLOW)Next steps:$(NC)"
	@echo "  1. Restart your terminal or run: source ~/.bashrc"
	@echo "  2. Start tmux: tmux or t"
	@echo "  3. Open neovim: nvim (plugins will install automatically)"

# Update dotfiles from git
update: ## Update dotfiles from git repository
	@echo "$(BLUE)Updating dotfiles...$(NC)"
	@git pull origin master
	@echo "$(GREEN)Update complete!$(NC)"
	@echo "$(YELLOW)Reload your shell: source ~/.bashrc$(NC)"