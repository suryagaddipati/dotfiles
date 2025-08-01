# AGENTS.md - Dotfiles Repository Guide

## Build/Test/Lint Commands
- **Install**: `just install` (symlinks dotfiles with backup)
- **Full setup**: `just full-install` (deps + dotfiles + dev tools)
- **Status check**: `just status` (verify symlinks and installation)
- **Dependencies**: `just install-deps` (system packages + mise + tools)
- **Development tools**: `just install-dev` (languages via mise)
- **Neovim setup**: `just setup-nvim` (plugins via lazy.nvim)
- **MCP servers**: `just install-mcp` (Claude Code integration)
- **Update**: `just update` (git pull latest changes)

## Code Style Guidelines
- **Shell scripts**: Use bash, 2-space indentation, quote variables
- **Lua (neovim)**: 2-space indentation, snake_case for variables, PascalCase for modules
- **Configuration files**: Maintain existing format (TOML, JSON, shell)
- **Symlink architecture**: Edit files in repo, changes reflect immediately
- **Git workflow**: Use aliases (`g s`, `g push`), commit with descriptive messages
- **Tool management**: Use mise for all language versions (node, python, go, rust)
- **File organization**: Keep configs in appropriate directories (.config/, .claude/)
- **Documentation**: Update CLAUDE.md and README.md for significant changes
- **Security**: Never commit API keys or secrets, use environment variables