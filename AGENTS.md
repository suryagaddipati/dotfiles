# Repository Guidelines

## Project Structure & Module Organization
Dotfiles live at the repo root and are symlinked into `$HOME`. Platform configs reside in `.config/` (notably `nvim/`, `tmux/`, `hypr/`, `waybar/`, `alacritty/`, `git/`). Shell helpers stay in `bash_functions/` and `bash_tools/`. Claude settings live under `.claude/`, while `swiftbar-plugins/` holds menu bar scripts. Automation scripts are defined in `.mise/tasks/`, and higher-level plans or documentation updates belong in `plans/`, `CLAUDE.md`, `NEOVIM.md`, and this guide. Keep new assets in the matching directory so symlinks remain predictable.

## Build, Test, and Development Commands
Run `mise run workflows:full-install` for a machine bootstrap (deps, dotfiles, dev tools). Use `mise run install` for a fast resync of symlinks with backups, and `mise run setup:prereqs` to verify required binaries. Legacy `just` targets remain available: `just install` (symlink with backup), `just status` (audit symlinks and report drift), and `just update` (pull latest repo changes). Prefer the `mise run` equivalents when touching task logic.

## Coding Style & Naming Conventions
Shell scripts should target bash with 2-space indentation, quoted variables, and descriptive function names. Lua modules (Neovim) use 2-space indentation, snake_case identifiers, and PascalCase module tables. Configuration files should keep their native formats (TOML, JSON, shell) and match existing ordering. Place new language runtimes or tools in `mise.toml`, and update symlink paths instead of editing files in `$HOME` directly.

## Testing Guidelines
This repo relies on smoke checks rather than automated suites. After modifying configs, run `just status` (or `mise run install` followed by `mise run setup:prereqs`) to confirm symlinks and dependencies remain healthy. For Neovim changes, launch `nvim` and trigger `:Lazy sync` to ensure plugins load. Record manual verification steps in the PR description when adding new workflows.

## Commit & Pull Request Guidelines
Follow the existing imperative prefixes (`fix:`, `enhance:`, `add:`, `refactor:`) seen in `git log`. Keep subject lines under 72 characters, explain the motivation in body text when the change is non-trivial, and group related config updates together. PRs should summarize the impact, link any tracking issues, include before/after notes or screenshots for UI tweaks (Hyprland, Waybar, SwiftBar), and call out follow-up work.

## Security & Configuration Tips
Never commit API keys or machine-specific secrets—use environment variables or `.claude/settings.local.json` overrides. Validate third-party scripts before inclusion, pin tool versions in `mise.toml`, and document noteworthy changes in `CLAUDE.md` or `README.md` so other machines stay in sync.
