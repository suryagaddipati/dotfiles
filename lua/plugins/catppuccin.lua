return {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false,
  priority = 1000,
  config = function()
    require('catppuccin').setup({
      flavour = "auto", -- latte, frappe, macchiato, mocha
      background = {    -- :h background
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      default_integrations = true,
      auto_integrations = false,
      color_overrides = {
        mocha = {
          base = "#000000",
          mantle = "#000000",
          crust = "#000000",
        },
      },
      dim_inactive = {
        enabled = true,
        shade = "light",
        percentage = 0.5,
      },
    })
    vim.cmd.colorscheme('catppuccin')
  end,
}
