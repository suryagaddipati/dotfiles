# Repository Guidelines

## Project Structure & Module Organization
Keep dotfiles at the repo root so they can be symlinked into `$HOME`. Platform-specific configs belong in `.config/` (notably `nvim/`, `tmux/`, `hypr/`, `waybar/`, `alacritty/`, `git/`). Shared shell helpers live under `bash_functions/` and `bash_tools/`. Automation stays in `.mise/tasks/`, while higher-level plans and notes go in `plans/`, `CLAUDE.md`, `NEOVIM.md`, or this guide. Store SwiftBar applets in `swiftbar-plugins/`, and add Claude overrides in `.claude/`. When introducing new assets, match the existing layout so symlinks remain predictable.

## Build, Test, and Development Commands
- `mise run workflows:full-install`: bootstrap a machine with dependencies, dotfiles, and dev tools.
- `mise run install`: refresh symlinks quickly, creating backups when paths drift.
- `mise run setup:prereqs`: confirm required binaries are present and versions align.
- `just install`, `just status`, `just update`: legacy helpers for the same workflows—prefer the `mise` variants when adjusting tasks.

## Coding Style & Naming Conventions
Use bash with 2-space indentation, quoted variables, and descriptive function names. Lua (Neovim) files keep 2-space indentation, snake_case identifiers, and PascalCase module tables. Configuration snippets stay in their native formats (TOML, YAML, JSON, shell) and preserve existing ordering. Register new tool versions in `mise.toml` rather than editing `$HOME` copies directly.

## Testing Guidelines
This repo relies on smoke tests. After config changes, run `just status` or `mise run install` followed by `mise run setup:prereqs` to confirm symlink health. For Neovim updates, open `nvim` and execute `:Lazy sync` to ensure plugins load cleanly. Document manual verification steps in PR descriptions whenever you add or modify automation.

## Commit & Pull Request Guidelines
Follow imperative commit prefixes such as `fix:`, `enhance:`, `add:`, or `refactor:` seen in `git log`. Keep subject lines under 72 characters and use the body to explain motivation or edge cases. Group related config updates into a single commit when possible. PRs should summarize the impact, link tracking issues, and include before/after screenshots for UI-facing tweaks (Hyprland, Waybar, SwiftBar). Call out any follow-up tasks or manual steps reviewers must perform.

## Security & Configuration Tips
Never commit secrets; prefer environment variables or `.claude/settings.local.json` overrides. Vet third-party scripts before inclusion, pin versions in `mise.toml`, and record noteworthy config changes in `CLAUDE.md` or `README.md` so other machines stay in sync.
