return {
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    config = function()
      require('rose-pine').setup({
        variant = 'auto',      -- auto, main, moon, or dawn
        dark_variant = 'main', -- main, moon, or dawn
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
  },
}
