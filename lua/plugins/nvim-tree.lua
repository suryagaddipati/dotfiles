return {
  'nvim-tree/nvim-tree.lua',
  keys = {
    { '<leader>p', '<cmd>NvimTreeToggle<cr>', desc = 'Toggle tree' },
  },
  config = function()
    require('nvim-tree').setup({
      hijack_netrw = true,
      view = { 
        width = 30,
        adaptive_size = false,
        preserve_window_proportions = false,
      },
      renderer = { group_empty = true },
      filters = { dotfiles = false },
      git = { enable = true },
    })
  end,
}