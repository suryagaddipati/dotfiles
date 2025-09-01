return {
  'rose-pine/neovim',
  name = 'rose-pine',
  lazy = false,
  priority = 1000,
  config = function()
    require('rose-pine').setup({
      variant = 'auto',
      dark_variant = 'main',
      dim_inactive_windows = true,
      extend_background_behind_borders = true,
      enable = {
        terminal = true,
      },
      styles = {
        bold = true,
        italic = true,
        transparency = false,
      },
    })
  end,
}