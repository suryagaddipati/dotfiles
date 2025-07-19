return {
  'szw/vim-maximizer',
  keys = {
    { '<leader>z', '<cmd>MaximizerToggle<cr>', desc = 'Toggle maximize split' },
  },
  config = function()
    vim.g.maximizer_set_default_mapping = 0
  end,
}