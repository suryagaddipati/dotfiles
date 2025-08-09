return {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false,
  priority = 1000,
  config = function()
    require('catppuccin').setup({
      flavour = 'mocha',
      background = {
        light = 'latte',
        dark = 'mocha',
      },
      transparent_background = true,
      show_end_of_buffer = false,
      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 1.0,
      },
      default_integrations = true,
      auto_integrations = false,
      custom_highlights = function(colors)
        return {
          Comment = { fg = colors.flamingo },
        }
      end
    })
    vim.cmd.colorscheme('catppuccin-mocha')

    -- Force transparent background
  end,
}
