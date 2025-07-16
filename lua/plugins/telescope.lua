return {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    { '<leader>f', '<cmd>Telescope find_files<cr>', desc = 'Find files' },
    { '<leader>g', '<cmd>Telescope live_grep<cr>', desc = 'Grep' },
    { '<leader>b', '<cmd>Telescope buffers<cr>', desc = 'Buffers' },
    { '<leader>hr', '<cmd>Telescope oldfiles<cr>', desc = 'Recent files' },
  },
  config = function()
    require('telescope').setup({
      defaults = {
        layout_strategy = 'horizontal',
        layout_config = { prompt_position = 'top' },
        sorting_strategy = 'ascending',
        winblend = 0,
      },
    })
  end,
}