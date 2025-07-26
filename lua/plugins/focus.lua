return {
  'nvim-focus/focus.nvim',
  version = '*',
  config = function()
    require('focus').setup({
      enable = true,
      commands = true,
      autoresize = {
        enable = false,
        width = 0,
        height = 0,
        minwidth = 0,
        minheight = 0,
        height_quickfix = 10,
      },
      split = {
        bufnew = false,
        tmux = false,
      },
      ui = {
        number = false,
        relativenumber = false,
        hybridnumber = false,
        absolutenumber_unfocussed = false,
        cursorline = false,
        cursorcolumn = false,
        colorcolumn = {
          enable = false,
          list = '+1',
        },
        signcolumn = true,
        winhighlight = true,
      }
    })
  end,
}