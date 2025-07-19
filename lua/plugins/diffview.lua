return {
  'sindrets/diffview.nvim',
  keys = {
    { '<leader>do', '<cmd>DiffviewOpen<cr>', desc = 'Open diffview' },
    { '<leader>dc', '<cmd>DiffviewClose<cr>', desc = 'Close diffview' },
    { '<leader>dh', '<cmd>DiffviewFileHistory<cr>', desc = 'File history' },
    { '<leader>df', '<cmd>DiffviewToggleFiles<cr>', desc = 'Toggle diffview files' },
  },
  config = function()
    require('diffview').setup({
      diff_binaries = false,
      enhanced_diff_hl = false,
      git_cmd = { 'git' },
      use_icons = false,
      show_help_hints = true,
      watch_index = true,
      icons = {
        folder_closed = '',
        folder_open = '',
      },
      signs = {
        fold_closed = '',
        fold_open = '',
        done = '✓',
      },
    })
  end,
}