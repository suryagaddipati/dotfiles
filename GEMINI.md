# Gemini AI Agent Context

This file provides context for the Gemini AI agent to understand the nature of this directory and its contents.

## Directory Overview

This is a "dotfiles" repository. Its primary purpose is to store and manage personalized configurations for various command-line tools and applications. By maintaining these configurations in a version-controlled repository, the user can ensure a consistent and optimized development environment across multiple machines.

The core technologies configured in this repository are:

*   **bash:** The primary shell environment, with custom aliases, functions, and prompt settings.
*   **git:** The version control system, with customized settings for aliases, user information, and editor integration.
*   **tmux:** A terminal multiplexer, heavily configured with custom keybindings for session, window, and pane management to enhance productivity.
*   **Neovim:** A highly extensible, modal text editor, with a comprehensive set of plugins and custom keybindings for a full-fledged development environment.
*   **Alacritty:** A fast, cross-platform, OpenGL terminal emulator.
*   **mise:** A tool for managing runtime environments (e.g., Node.js, Python) for different projects.

The repository also includes a `justfile`, which acts as a command runner to automate setup, installation, and management of the dotfiles.

## Key Files

*   `.bashrc` & `.bash_profile`: These files contain the shell configuration for `bash`, including aliases, functions, and environment variables.
*   `.gitconfig`: This file contains the global Git configuration, such as user information and aliases.
*   `.tmux.conf`: This file contains the configuration for `tmux`, including keybindings and status bar settings.
*   `init.lua`: This is the main configuration file for Neovim, written in Lua. It sets up plugins, keybindings, and editor behavior.
*   `justfile`: This file defines a set of commands for managing the dotfiles, such as `just install`, `just update`, and `just backup`.
*   `.config/alacritty/alacritty.toml`: The configuration file for the Alacritty terminal emulator.
*   `.config/mise/config.toml`: The configuration file for the `mise` runtime environment manager.
*   `README.md`: The main documentation for the repository, containing detailed information about setup, commands, and keybindings.

## Usage

The primary way to interact with this repository is through the `just` command-line tool. The `justfile` provides a set of recipes for common tasks:

*   `just full-install`: Performs a complete setup, including installing dependencies and creating symbolic links for the configuration files.
*   `just install`: Installs the dotfiles, creating backups of any existing configurations.
*   `just update`: Pulls the latest changes from the Git repository to keep the dotfiles up-to-date.
*   `just backup`: Creates a backup of the existing dotfiles.

The repository is heavily customized with a mnemonic keybinding system, primarily for `tmux` and `neovim`, to streamline common development workflows. The `README.md` file serves as a comprehensive cheatsheet for these keybindings.
