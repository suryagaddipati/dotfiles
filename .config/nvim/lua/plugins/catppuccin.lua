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
      auto_integrations = true,
      color_overrides = {
        mocha = {
          base = "#000000",
          mantle = "#000000",
          crust = "#000000",
          surface0 = "#0a0a0a",
          surface1 = "#121212",
          surface2 = "#1a1a1a",
          overlay0 = "#1e1e1e",
          overlay1 = "#262626",
          overlay2 = "#2e2e2e",
        },
      },
      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.25,
      },
    })
    vim.cmd.colorscheme('catppuccin')
  end,
}
