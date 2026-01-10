return {
  'sindrets/diffview.nvim',
  event = 'VeryLazy',
  keys = {
    {
      '<leader>gg',
      function()
        local ok, lib = pcall(require, 'diffview.lib')
        if ok and lib.get_current_view() then
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
          ['I'] = function()
            local view = require('diffview.lib').get_current_view()
            if not view then return end

            local file = view.panel:get_item_at_cursor()
            if not file then return end

            -- Get git root directory
            local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
            if vim.v.shell_error ~= 0 then
              vim.notify('Not in a git repository', vim.log.levels.ERROR)
              return
            end

            local gitignore_path = git_root .. '/.gitignore'
            local file_path = file.path

            -- Read existing gitignore or create empty table
            local gitignore_lines = {}
            local gitignore_file = io.open(gitignore_path, 'r')
            if gitignore_file then
              for line in gitignore_file:lines() do
                table.insert(gitignore_lines, line)
              end
              gitignore_file:close()
            end

            -- Check if file is already in gitignore
            for _, line in ipairs(gitignore_lines) do
              if line:gsub('^%s*(.-)%s*$', '%1') == file_path then
                vim.notify(string.format('%s is already in .gitignore', file_path), vim.log.levels.WARN)
                return
              end
            end

            -- Add file to gitignore
            table.insert(gitignore_lines, file_path)

            -- Write updated gitignore
            gitignore_file = io.open(gitignore_path, 'w')
            if gitignore_file then
              for _, line in ipairs(gitignore_lines) do
                gitignore_file:write(line .. '\n')
              end
              gitignore_file:close()
              vim.notify(string.format('Added %s to .gitignore', file_path))
              -- Refresh the view
              actions.refresh_files()
            else
              vim.notify('Failed to write .gitignore', vim.log.levels.ERROR)
            end
          end,
        },
      },
    })
  end,
}

