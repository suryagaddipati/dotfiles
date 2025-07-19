return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  keys = {
    { '<leader>gb', '<cmd>Gitsigns blame_line<cr>', desc = 'Git blame line' },
    { '<leader>gp', '<cmd>Gitsigns preview_hunk<cr>', desc = 'Preview git hunk' },
    { '<leader>gr', '<cmd>Gitsigns reset_hunk<cr>', desc = 'Reset git hunk' },
    { '<leader>gs', '<cmd>Gitsigns stage_hunk<cr>', desc = 'Stage git hunk' },
    { '<leader>gu', '<cmd>Gitsigns undo_stage_hunk<cr>', desc = 'Undo stage hunk' },
    { ']c', '<cmd>Gitsigns next_hunk<cr>', desc = 'Next git hunk' },
    { '[c', '<cmd>Gitsigns prev_hunk<cr>', desc = 'Previous git hunk' },
  },
  config = function()
    require('gitsigns').setup({
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '-' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    })
  end,
}