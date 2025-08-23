local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local mux = wezterm.mux

-- Shell configuration
config.default_prog = { '/bin/bash' }

-- Font configuration
config.font = wezterm.font('Hack Nerd Font')
config.font_size = 20.0

-- Window configuration
config.window_decorations = "RESIZE"
config.native_macos_fullscreen_mode = true
-- Set window to fill most of the screen
config.initial_cols = 200
config.initial_rows = 60

-- Window position and behavior
config.window_close_confirmation = "NeverPrompt"
config.quit_when_all_windows_are_closed = true

-- Start window maximized
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  local gui_window = window:gui_window()
  gui_window:maximize()
end)

-- Terminal configuration
config.term = "xterm-256color"


-- Additional WezTerm features
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

-- Performance optimizations
config.max_fps = 120
config.animation_fps = 60
config.cursor_blink_rate = 500

-- Scrollback
config.scrollback_lines = 10000

-- Key bindings (similar to tmux/vim workflow)
config.keys = {
  -- Split panes (similar to tmux with Ctrl-Space prefix)
  { key = '|', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '_', mods = 'CTRL|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- Navigate panes with Alt+hjkl (matching your tmux config)
  { key = 'h', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Right' },

  -- Resize panes with Ctrl+Alt+hjkl
  { key = 'h', mods = 'CTRL|ALT', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
  { key = 'j', mods = 'CTRL|ALT', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },
  { key = 'k', mods = 'CTRL|ALT', action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
  { key = 'l', mods = 'CTRL|ALT', action = wezterm.action.AdjustPaneSize { 'Right', 5 } },

  -- Tab navigation with Alt+number (matching tmux)
  { key = '1', mods = 'ALT', action = wezterm.action.ActivateTab(0) },
  { key = '2', mods = 'ALT', action = wezterm.action.ActivateTab(1) },
  { key = '3', mods = 'ALT', action = wezterm.action.ActivateTab(2) },
  { key = '4', mods = 'ALT', action = wezterm.action.ActivateTab(3) },
  { key = '5', mods = 'ALT', action = wezterm.action.ActivateTab(4) },
  { key = '6', mods = 'ALT', action = wezterm.action.ActivateTab(5) },
  { key = '7', mods = 'ALT', action = wezterm.action.ActivateTab(6) },
  { key = '8', mods = 'ALT', action = wezterm.action.ActivateTab(7) },
  { key = '9', mods = 'ALT', action = wezterm.action.ActivateTab(8) },

  -- Close pane
  { key = 'w', mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentPane { confirm = true } },

  -- Copy mode (similar to tmux)
  { key = 'Enter', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateCopyMode },

  -- Paste from clipboard
  { key = 'v', mods = 'CTRL|SHIFT', action = wezterm.action.PasteFrom 'Clipboard' },

  -- Toggle fullscreen
  { key = 'f', mods = 'CTRL|SHIFT', action = wezterm.action.ToggleFullScreen },

  -- Window management
  { key = 'm', mods = 'CMD', action = wezterm.action.Hide },  -- Minimize with Cmd+M
  { key = 'Enter', mods = 'CMD', action = wezterm.action.ToggleFullScreen },  -- Cmd+Enter for fullscreen
  { key = 'n', mods = 'CMD', action = wezterm.action.SpawnWindow },  -- New window with Cmd+N

  -- Clear scrollback
  { key = 'k', mods = 'CTRL|SHIFT', action = wezterm.action.ClearScrollback 'ScrollbackAndViewport' },
}

-- Mouse bindings
config.mouse_bindings = {
  -- Right click pastes from clipboard
  {
    event = { Up = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action.PasteFrom 'Clipboard',
  },

  -- Ctrl+Click opens links
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

-- Hyperlink rules
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Bell
config.audible_bell = 'Disabled'
config.visual_bell = {
  fade_in_duration_ms = 75,
  fade_out_duration_ms = 75,
  target = 'CursorColor',
}

return config
