return {
  'nvim-tree/nvim-tree.lua',
  cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
  keys = {
    { '<leader>e', '<cmd>NvimTreeToggle<cr>', desc = 'Toggle tree' },
  },
  config = function()
    require('nvim-tree').setup({
      hijack_netrw = true,
      view = { width = 30 },
      renderer = { group_empty = true },
      filters = { dotfiles = false },
      git = { enable = true },
    })
  end,
}