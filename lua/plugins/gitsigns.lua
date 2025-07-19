return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  keys = {
    { '<leader>gb', '<cmd>Gitsigns blame_line<cr>', desc = 'Git blame line' },
    { '<leader>gp', '<cmd>Gitsigns preview_hunk<cr>', desc = 'Preview git hunk' },
    { '<leader>gr', '<cmd>Gitsigns reset_hunk<cr>', desc = 'Reset git hunk' },
    { '<leader>gs', '<cmd>Gitsigns stage_hunk<cr>', desc = 'Stage git hunk' },
    { '<leader>gS', '<cmd>Gitsigns stage_buffer<cr>', desc = 'Stage entire buffer' },
    { '<leader>gu', '<cmd>Gitsigns undo_stage_hunk<cr>', desc = 'Undo stage hunk' },
    { '<leader>gR', '<cmd>Gitsigns reset_buffer<cr>', desc = 'Reset entire buffer' },
    { ']c', '<cmd>Gitsigns next_hunk<cr>', desc = 'Next git hunk' },
    { '[c', '<cmd>Gitsigns prev_hunk<cr>', desc = 'Previous git hunk' },
    -- Visual mode mappings
    { '<leader>gs', ':Gitsigns stage_hunk<CR>', mode = 'v', desc = 'Stage selected hunk' },
    { '<leader>gr', ':Gitsigns reset_hunk<CR>', mode = 'v', desc = 'Reset selected hunk' },
  },
  config = function()
    require('gitsigns').setup({
      signs = {
        add = { text = '│' },
        change = { text = '│' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    })
  end,
}