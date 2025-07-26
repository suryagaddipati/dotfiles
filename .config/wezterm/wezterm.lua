-- WezTerm Configuration
-- Minimal setup optimized for tmux usage

local wezterm = require 'wezterm'
local config = {}

-- Use newer config builder API if available
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Font configuration using available system fonts
config.font = wezterm.font_with_fallback({
  {
    family = "JetBrainsMono Nerd Font Mono",
    weight = "Regular",
  },
  "Noto Color Emoji", -- For emoji support
  "JetBrains Mono",   -- Built-in fallback
  "monospace",        -- System fallback
})
config.font_size = 15.0

-- Color scheme
config.color_scheme = 'Gruvbox dark, medium (base16)'

-- Window configuration
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}

-- Disable tab bar completely since using tmux
config.enable_tab_bar = false
config.use_fancy_tab_bar = false
config.show_tabs_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.tab_bar_at_bottom = false

-- Cursor configuration
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 0 -- Disable blinking completely
config.cursor_thickness = 2  -- Make cursor more visible

-- Scrollback
config.scrollback_lines = 10000

-- Shell
config.default_prog = { '/bin/bash' }

-- Performance
config.max_fps = 60

-- Key bindings (minimal since tmux handles most)
config.keys = {
  -- Font size adjustment
  { key = '=', mods = 'CTRL',       action = wezterm.action.IncreaseFontSize },
  { key = '-', mods = 'CTRL',       action = wezterm.action.DecreaseFontSize },
  { key = '0', mods = 'CTRL',       action = wezterm.action.ResetFontSize },

  -- Copy/paste
  { key = 'c', mods = 'CTRL|SHIFT', action = wezterm.action.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL|SHIFT', action = wezterm.action.PasteFrom 'Clipboard' },
}

-- Disable default key bindings that conflict with tmux
config.disable_default_key_bindings = false

return config

