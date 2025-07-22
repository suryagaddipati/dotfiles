return {
  'sindrets/diffview.nvim',
  keys = {
    { '<leader>dd', function()
        local lib = require('diffview.lib')
        if lib.get_current_view() then
          vim.cmd('DiffviewClose')
        else
          vim.cmd('DiffviewOpen')
        end
      end, desc = 'Toggle diffview' },
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