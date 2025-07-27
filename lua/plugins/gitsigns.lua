return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  keys = {
    { '<leader>gb', '<cmd>Gitsigns blame_line<cr>', desc = 'Git blame line' },
    { '<leader>gp', '<cmd>Gitsigns preview_hunk<cr>', desc = 'Preview git hunk' },
    { '<leader>gn', '<cmd>Gitsigns nav_hunk next preview=true<cr>', desc = 'Preview next hunk' },
    { '<leader>gN', '<cmd>Gitsigns nav_hunk prev preview=true<cr>', desc = 'Preview previous hunk' },
    { '<leader>gd', '<cmd>Gitsigns reset_hunk<cr>', desc = 'Reset git hunk' },
    { '<leader>gs', '<cmd>Gitsigns stage_hunk<cr>', desc = 'Stage git hunk' },
    { '<leader>gS', function()
        local gitsigns = require('gitsigns')
        local bufnr = vim.api.nvim_get_current_buf()
        local filepath = vim.api.nvim_buf_get_name(bufnr)

        -- Check if file is new/untracked
        vim.fn.system('git ls-files --error-unmatch ' .. vim.fn.shellescape(filepath))
        if vim.v.shell_error ~= 0 then
          -- File is untracked, add it first
          vim.fn.system('git add ' .. vim.fn.shellescape(filepath))
          print('Added and staged: ' .. vim.fn.fnamemodify(filepath, ':t'))
        else
          -- File is tracked, use gitsigns
          gitsigns.stage_buffer()
        end
      end, desc = 'Stage entire buffer (handles new files)' },
    { '<leader>gu', '<cmd>Gitsigns undo_stage_hunk<cr>', desc = 'Undo stage hunk' },
    { '<leader>gR', '<cmd>Gitsigns reset_buffer<cr>', desc = 'Reset entire buffer' },
    { '<leader>gc', function()
        vim.notify('Generating commit message...', vim.log.levels.INFO, { title = 'Git Auto-Commit' })

        vim.fn.jobstart('git auto-commit', {
          on_exit = function(_, exit_code)
            if exit_code == 0 then
              vim.notify('Commit created successfully!', vim.log.levels.INFO, { title = 'Git Auto-Commit' })
            else
              vim.notify('Failed to create commit (exit code: ' .. exit_code .. ')', vim.log.levels.ERROR, { title = 'Git Auto-Commit' })
            end
          end,
          on_stderr = function(_, data)
            if data and #data > 0 and data[1] ~= '' then
              vim.notify('Error: ' .. table.concat(data, '\n'), vim.log.levels.ERROR, { title = 'Git Auto-Commit' })
            end
          end
        })
      end, desc = 'Commit staged changes' },
    { '<leader>gC', function()
        -- Interactive commit - opens terminal for manual commit message
        vim.cmd('ToggleTerm direction=float')
        vim.defer_fn(function()
          vim.api.nvim_feedkeys('git commit\r', 'n', false)
        end, 100)
      end, desc = 'Interactive commit' },
    { '<leader>gm', function()
        vim.notify('Running Claude commit ...', vim.log.levels.INFO, { title = 'Claude Commit' })

        vim.fn.jobstart('~/.claude/local/claude commit -p --dangerously-skip-permissions ', {
          on_exit = function(_, exit_code)
            if exit_code == 0 then
              vim.notify('Claude commit completed successfully!', vim.log.levels.INFO, { title = 'Claude Commit' })
            else
              vim.notify('Claude commit failed (exit code: ' .. exit_code .. ')', vim.log.levels.ERROR, { title = 'Claude Commit' })
            end
          end,
          on_stdout = function(_, data)
            if data and #data > 0 and data[1] ~= '' then
              vim.notify(table.concat(data, '\n'), vim.log.levels.INFO, { title = 'Claude Commit' })
            end
          end,
          on_stderr = function(_, data)
            if data and #data > 0 and data[1] ~= '' then
              vim.notify('Error: ' .. table.concat(data, '\n'), vim.log.levels.ERROR, { title = 'Claude Commit' })
            end
          end
        })
      end, desc = 'Commit with Claude message' },
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
        untracked = { text = '┆' },
      },
      signs_staged = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      signs_staged_enable = true,
    })
  end,
}
