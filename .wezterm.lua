local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local mux = wezterm.mux
local act = wezterm.action

-- Helper function to get git branch
local function get_git_branch(pane)
  local cwd = pane:get_current_working_dir()
  if not cwd then return '' end
  
  local success, stdout = wezterm.run_child_process({
    'git', '-C', cwd.file_path, 'rev-parse', '--abbrev-ref', 'HEAD'
  })
  
  if success then
    local branch = stdout:gsub('[\n\r]', '')
    return branch ~= '' and ' ' .. branch or ''
  end
  return ''
end

-- Shell configuration
config.default_prog = { '/bin/bash' }

-- Font configuration
config.font = wezterm.font('Hack Nerd Font')
config.font_size = 20.0

-- Window configuration
config.window_decorations = "RESIZE"
config.native_macos_fullscreen_mode = true
config.initial_cols = 200
config.initial_rows = 60

-- Window position and behavior
config.window_close_confirmation = "NeverPrompt"
config.quit_when_all_windows_are_closed = true

-- Start window maximized
wezterm.on('gui-startup', function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  local gui_window = window:gui_window()
  gui_window:maximize()
end)

-- Terminal configuration
config.term = "xterm-256color"

-- Tab bar configuration
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false  -- Show even with one tab for consistency
config.show_tab_index_in_tab_bar = true
config.switch_to_last_active_tab_when_closing_tab = true

-- Performance optimizations
config.max_fps = 120
config.animation_fps = 60
config.cursor_blink_rate = 500

-- Scrollback
config.scrollback_lines = 10000

-- =============================================================================
-- TMUX-STYLE LEADER KEY CONFIGURATION
-- =============================================================================
-- Set Ctrl-Y as leader (matching your tmux prefix)
-- Alternative: Try Ctrl-Space if Ctrl-Y doesn't work
-- config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 2000 }
config.leader = { key = 'y', mods = 'CTRL', timeout_milliseconds = 2000 }

-- Show leader key status in tab bar
config.status_update_interval = 1000

-- =============================================================================
-- KEY BINDINGS
-- =============================================================================
config.keys = {
  -- ==========================================================================
  -- LEADER KEY BINDINGS (Tmux-style with Ctrl-Y prefix)
  -- ==========================================================================
  
  -- Pane/Split Management (matching tmux)
  { key = 's', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'v', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '|', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = false } },
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  { key = 'q', mods = 'LEADER', action = act.PaneSelect },  -- Show pane numbers
  { key = 'o', mods = 'LEADER', action = act.RotatePanes 'Clockwise' },
  { key = 'Space', mods = 'LEADER', action = act.PaneSelect { mode = 'SwapWithActive' } },
  
  -- Pane Navigation (with leader)
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  
  -- Pane Resizing (with leader)
  { key = 'H', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Left', 5 } },
  { key = 'J', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Down', 5 } },
  { key = 'K', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Up', 5 } },
  { key = 'L', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Right', 5 } },
  
  -- Tab/Window Management (matching tmux windows)
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = 'l', mods = 'LEADER', action = act.ActivateLastTab },
  { key = 'w', mods = 'LEADER', action = act.ShowTabNavigator },  -- List tabs
  { key = ',', mods = 'LEADER', action = act.PromptInputLine {
    description = 'Enter new name for tab',
    action = wezterm.action_callback(function(window, pane, line)
      if line then
        window:active_tab():set_title(line)
      end
    end),
  }},
  { key = 'X', mods = 'LEADER|SHIFT', action = act.CloseCurrentTab { confirm = false } },
  { key = '<', mods = 'LEADER|SHIFT', action = act.MoveTabRelative(-1) },
  { key = '>', mods = 'LEADER|SHIFT', action = act.MoveTabRelative(1) },
  
  -- Tab direct access (with leader)
  { key = '1', mods = 'LEADER', action = act.ActivateTab(0) },
  { key = '2', mods = 'LEADER', action = act.ActivateTab(1) },
  { key = '3', mods = 'LEADER', action = act.ActivateTab(2) },
  { key = '4', mods = 'LEADER', action = act.ActivateTab(3) },
  { key = '5', mods = 'LEADER', action = act.ActivateTab(4) },
  { key = '6', mods = 'LEADER', action = act.ActivateTab(5) },
  { key = '7', mods = 'LEADER', action = act.ActivateTab(6) },
  { key = '8', mods = 'LEADER', action = act.ActivateTab(7) },
  { key = '9', mods = 'LEADER', action = act.ActivateTab(8) },
  
  -- Copy Mode (matching tmux)
  { key = 'Enter', mods = 'LEADER', action = act.ActivateCopyMode },
  { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },
  { key = 'P', mods = 'LEADER|SHIFT', action = act.PasteFrom 'Clipboard' },
  { key = '/', mods = 'LEADER', action = act.Search { CaseInSensitiveString = '' } },
  
  -- Config reload (matching tmux)
  { key = 'r', mods = 'LEADER', action = act.ReloadConfiguration },
  
  -- Test binding - shows a notification when leader works
  { key = '?', mods = 'LEADER|SHIFT', action = wezterm.action_callback(function(window, pane)
    window:toast_notification('WezTerm', 'Leader key is working! (Ctrl-Y)', nil, 2000)
  end) },
  
  -- Clear screen
  { key = 'C', mods = 'LEADER|SHIFT', action = act.ClearScrollback 'ScrollbackAndViewport' },
  
  -- ==========================================================================
  -- WORKSPACE MANAGEMENT (Replaces tmux sessions)
  -- ==========================================================================
  { key = 'w', mods = 'CTRL|ALT', action = act.ShowLauncherArgs { flags = 'WORKSPACES' } },
  { key = 'n', mods = 'CTRL|ALT', action = act.PromptInputLine {
    description = 'Enter name for new workspace',
    action = wezterm.action_callback(function(window, pane, line)
      if line then
        window:perform_action(
          act.SwitchToWorkspace { name = line },
          pane
        )
      end
    end),
  }},
  
  -- Quick workspace switching
  { key = '1', mods = 'CTRL|ALT', action = act.SwitchToWorkspace { name = 'main' } },
  { key = '2', mods = 'CTRL|ALT', action = act.SwitchToWorkspace { name = 'backend' } },
  { key = '3', mods = 'CTRL|ALT', action = act.SwitchToWorkspace { name = 'frontend' } },
  
  -- Session management (with leader, like tmux)
  { key = 'S', mods = 'LEADER|SHIFT', action = act.PromptInputLine {
    description = 'Enter name for new workspace',
    action = wezterm.action_callback(function(window, pane, line)
      if line then
        window:perform_action(
          act.SwitchToWorkspace { name = line },
          pane
        )
      end
    end),
  }},
  { key = 's', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'WORKSPACES' } },
  
  -- ==========================================================================
  -- STANDARD SHORTCUTS
  -- ==========================================================================
  
  -- macOS standard
  { key = 't', mods = 'CMD', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CMD', action = act.CloseCurrentTab { confirm = false } },
  { key = 'm', mods = 'CMD', action = act.Hide },
  { key = 'Enter', mods = 'CMD', action = act.ToggleFullScreen },
  { key = 'n', mods = 'CMD', action = act.SpawnWindow },
  { key = 'v', mods = 'CMD', action = act.PasteFrom 'Clipboard' },
  { key = 'c', mods = 'CMD', action = act.CopyTo 'Clipboard' },
  
  -- Additional useful shortcuts
  { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = 'Enter', mods = 'CTRL|SHIFT', action = act.ActivateCopyMode },
  { key = 'f', mods = 'CTRL|SHIFT', action = act.ToggleFullScreen },
}

-- =============================================================================
-- TAB TITLE FORMATTING (Shows git branch and directory)
-- =============================================================================
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local title = tab.tab_title
  
  -- If no explicit title set, use active pane title
  if not title or #title == 0 then
    title = tab.active_pane.title
  end
  
  -- Get git branch for active pane
  local branch = get_git_branch(tab.active_pane)
  
  -- Format: [index] title (branch)
  local formatted = string.format('[%d] %s%s', tab.tab_index + 1, title, branch)
  
  -- Truncate if too long
  if #formatted > max_width then
    formatted = wezterm.truncate_right(formatted, max_width - 3) .. '...'
  end
  
  return formatted
end)

-- =============================================================================
-- STATUS BAR TO SHOW LEADER KEY STATE
-- =============================================================================
wezterm.on('update-status', function(window, pane)
  local leader = ''
  if window:leader_is_active() then
    leader = '⚡ LEADER '  -- Shows when Ctrl-Y is active
  end
  
  -- Set the right status with leader indicator (no color)
  window:set_right_status(leader)
end)

-- =============================================================================
-- WINDOW TITLE (Shows workspace)
-- =============================================================================
wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
  local workspace = mux.get_active_workspace()
  local zoomed = ''
  if tab.active_pane:is_zoomed() then
    zoomed = ' [Z]'
  end
  return workspace .. ' - WezTerm' .. zoomed
end)

-- =============================================================================
-- MOUSE BINDINGS
-- =============================================================================
config.mouse_bindings = {
  -- Right click pastes from clipboard
  {
    event = { Up = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = act.PasteFrom 'Clipboard',
  },
  
  -- Ctrl+Click opens links
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.OpenLinkAtMouseCursor,
  },
  
  -- Middle click closes tab
  {
    event = { Up = { streak = 1, button = 'Middle' } },
    mods = 'NONE',
    action = act.CloseCurrentTab { confirm = false },
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