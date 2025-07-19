return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    { '<leader>f', '<cmd>Telescope live_grep<cr>', desc = 'Live grep' },
    { '<leader>p', '<cmd>Telescope find_files<cr>', desc = 'Find files' },
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