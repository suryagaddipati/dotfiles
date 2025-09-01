# Config Migration Todo List

Based on analysis of `~/.config`, here are directories and files that can be managed in the dotfiles repository.

## High Priority (Essential development/terminal configs)

- [x] **`lazygit/`** - Git TUI configuration (config.yml)
- [x] **`git/`** - Git configuration ✓
- [x] **`gh/`** - GitHub CLI configuration
- [x] **`alacritty/`** - Already symlinked to dotfiles ✓
- [x] **`nvim/`** - Already has init.lua symlinked ✓
- [x] **`mise/`** - Already symlinked to dotfiles ✓

## Medium Priority (System/UI configs)

- [x] **`hypr/`** - Hyprland window manager (multiple .conf files) ✓
- [ ] **`waybar/`** - Status bar (config.jsonc, style.css)
- [ ] **`mako/`** - Notification daemon (currently symlinked to omarchy)
- [ ] **`btop/`** - System monitor (btop.conf)
- [ ] **`fastfetch/`** - System info (config.jsonc)
- [ ] **`walker/`** - Application launcher (config.toml)
- [ ] **`swayosd/`** - On-screen display (config.toml)

## Individual Files (Standalone configs)

- [ ] **`starship.toml`** - Shell prompt configuration
- [ ] **`brave-flags.conf`** & **`chromium-flags.conf`** - Browser flags
- [ ] **`mimeapps.list`** - Default applications
- [ ] **Files in `fontconfig/`** - Font configuration
- [ ] **Files in `environment.d/`** - Environment variables

## Low Priority (App-specific, might contain sensitive data)

- [ ] `lazydocker/` - Docker TUI
- [ ] `xournalpp/` - Note-taking app
- [ ] `Typora/` - Markdown editor settings

## Skip These (Not suitable for dotfiles)

- Browser profile directories (BraveSoftware, chromium, google-chrome, etc.)
- Desktop environment configs (gtk-3.0, dconf)
- Input method configs (fcitx, ibus, pulse)
- Application data (1Password, Signal, qalculate, nautilus, yay)

## Recommended Implementation Order

1. **Phase 1**: Developer essentials
   - lazygit configuration
   - git configuration
   - starship.toml

2. **Phase 2**: System consistency
   - Browser flags
   - mimeapps.list
   - fontconfig

3. **Phase 3**: UI/Desktop (if using Hyprland)
   - hypr/ directory
   - waybar/ configuration
   - System monitoring tools (btop, fastfetch)

4. **Phase 4**: Optional enhancements
   - Application launchers (walker)
   - Additional UI tools (swayosd)
   - App-specific configs as needed

## Implementation Notes

- Create `.config/` directory in dotfiles repo
- Use same symlink approach as current alacritty setup
- Update justfile with new symlink management
- Test each config before committing
- Consider sensitive data in configurations
