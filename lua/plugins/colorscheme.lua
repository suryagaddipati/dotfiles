return {
  'ellisonleao/gruvbox.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    -- Path to store theme preference (shared with tmux and other tools)
    local theme_file = vim.fn.expand('~/.config/theme_preference')
    
    -- Load theme preference from file
    local function load_theme_preference()
      local file = io.open(theme_file, 'r')
      if file then
        local content = file:read('*all')
        file:close()
        return content:match('night') == 'night'
      end
      return false -- Default to day mode
    end
    
    -- Save theme preference to file
    local function save_theme_preference(is_night)
      local file = io.open(theme_file, 'w')
      if file then
        file:write(is_night and 'night' or 'day')
        file:close()
      end
    end
    
    -- Night mode state (load from file)
    local night_mode = load_theme_preference()
    
    local function setup_gruvbox()
      require('gruvbox').setup({
        terminal_colors = true,
        contrast = night_mode and 'soft' or 'hard',
        transparent_mode = true,
        palette_overrides = night_mode and {
          bright_red = "#cc6666",
          bright_green = "#b5bd68",
          bright_yellow = "#f0c674",
          bright_blue = "#81a2be",
          bright_purple = "#b294bb",
          bright_aqua = "#8abeb7",
          bright_orange = "#de935f",
        } or {},
      })
      vim.cmd.colorscheme('gruvbox')
      
      -- Force transparent background
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
      
      -- Night mode adjustments
      if night_mode then
        -- Dim bright syntax elements
        vim.api.nvim_set_hl(0, "String", { fg = "#8f9768" })
        vim.api.nvim_set_hl(0, "Function", { fg = "#7a9bb8" })
        vim.api.nvim_set_hl(0, "Keyword", { fg = "#a68598" })
        vim.api.nvim_set_hl(0, "Number", { fg = "#b5906f" })
        vim.api.nvim_set_hl(0, "Constant", { fg = "#b5906f" })
        vim.api.nvim_set_hl(0, "Type", { fg = "#9fb56f" })
        vim.api.nvim_set_hl(0, "Comment", { fg = "#665c54", italic = true })
        
        -- Soften UI elements
        vim.api.nvim_set_hl(0, "LineNr", { fg = "#504945" })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#7c6f64" })
        vim.api.nvim_set_hl(0, "StatusLine", { fg = "#7c6f64", bg = "none" })
        
        print("Night mode enabled - easier on the eyes!")
      else
        print("Day mode enabled")
      end
    end
    
    -- Toggle night mode function
    local function toggle_night_mode()
      night_mode = not night_mode
      save_theme_preference(night_mode)
      setup_gruvbox()
    end
    
    -- Set up initial colorscheme
    setup_gruvbox()
    
    -- Create command and keybinding for night mode toggle
    vim.api.nvim_create_user_command('ToggleNightMode', toggle_night_mode, {})
    vim.keymap.set('n', '<leader>n', toggle_night_mode, { desc = 'Toggle night mode' })
  end,
}