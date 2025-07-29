return {
  'sindrets/diffview.nvim',
  keys = {
    { '<leader>gg', function()
        local lib = require('diffview.lib')
        if lib.get_current_view() then
          vim.cmd('DiffviewClose')
        else
          vim.cmd('DiffviewOpen')
        end
      end, desc = 'Git status (diffview)' },
    { '<leader>gh', '<cmd>DiffviewFileHistory<cr>', desc = 'Git file history' },
    { '<leader>gf', '<cmd>DiffviewToggleFiles<cr>', desc = 'Git files panel' },
  },
  config = function()
    require('diffview').setup({
      diff_binaries = false,
      enhanced_diff_hl = true,
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