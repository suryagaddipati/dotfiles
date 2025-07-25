return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    { '<leader>f', '<cmd>Telescope live_grep<cr>', desc = 'Live grep' },
    { '<leader>p', '<cmd>Telescope find_files<cr>', desc = 'Find files' },
    { '<leader>b', '<cmd>Telescope buffers<cr>', desc = 'Buffers' },
    { '<leader>hr', '<cmd>Telescope oldfiles<cr>', desc = 'Recent files' },
    { '<leader>r', '<cmd>Telescope registers<cr>', desc = 'Registers' },
    { '<leader>:', '<cmd>Telescope command_history<cr>', desc = 'Command history' },
    { '<leader>;', '<cmd>Telescope commands<cr>', desc = 'Commands' },
  },
  config = function()
    require('telescope').setup({
      defaults = {
        layout_strategy = 'horizontal',
        layout_config = { prompt_position = 'top' },
        sorting_strategy = 'ascending',
        winblend = 0,
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
          },
        },
      },
      pickers = {
        buffers = {
          sort_mru = true,
          ignore_current_buffer = true,
          mappings = {
            i = {
              ['<C-d>'] = 'delete_buffer',
            },
            n = {
              ['dd'] = 'delete_buffer',
            },
          },
        },
        find_files = {
          hidden = true,
          find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
        },
        live_grep = {
          additional_args = function() return { '--hidden' } end,
        },
      },
    })
  end,
}