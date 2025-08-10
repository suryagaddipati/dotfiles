return {
  'sindrets/diffview.nvim',
  keys = {
    {
      '<leader>gg',
      function()
        local lib = require('diffview.lib')
        if lib.get_current_view() then
          vim.cmd('DiffviewClose')
        else
          vim.cmd('DiffviewOpen')
        end
      end,
      desc = 'Git status (diffview)'
    },
    { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = 'Git file history' },
    { '<leader>gf', '<cmd>DiffviewToggleFiles<cr>', desc = 'Git files panel' },
  },
  config = function()
    local actions = require('diffview.actions')

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
      keymaps = {
        file_panel = {
          ['D'] = function()
            local view = require('diffview.lib').get_current_view()
            if not view then return end

            local file = view.panel:get_item_at_cursor()
            if not file then return end

            -- Check if file is untracked
            if file.status and file.status == '?' then
              local ok = pcall(vim.fn.delete, file.absolute_path)
              if ok then
                vim.notify(string.format('Deleted: %s', file.path))
                -- Refresh the view
                actions.refresh_files()
              end
            else
              vim.notify('File is not untracked', vim.log.levels.WARN)
            end
          end,
        },
      },
    })
  end,
}

