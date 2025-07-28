return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  keys = {
    { '<leader>gb', function() require('gitsigns').blame_line() end, desc = 'Git blame line' },
    { '<leader>gp', function() require('gitsigns').preview_hunk() end, desc = 'Preview git hunk' },
    { '<leader>gn', function() require('gitsigns').nav_hunk('next', {preview = true}) end, desc = 'Preview next hunk' },
    { ',n',         function() require('gitsigns').nav_hunk('next', {preview = true}) end, desc = 'Preview next hunk' },
    { '<leader>gN', function() require('gitsigns').nav_hunk('prev', {preview = true}) end, desc = 'Preview previous hunk' },
    { '<leader>gd', function() require('gitsigns').reset_hunk() end, desc = 'Reset git hunk' },
    { '<leader>gs', function() require('gitsigns').stage_hunk() end, desc = 'Stage git hunk' },
    {
      '<leader>gS',
      function()
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
      end,
      desc = 'Stage entire buffer (handles new files)'
    },
    { '<leader>gu', function() require('gitsigns').undo_stage_hunk() end, desc = 'Undo stage hunk' },
    { '<leader>gR', function() require('gitsigns').reset_buffer() end, desc = 'Reset entire buffer' },
    {
      '<leader>gc',
      function()
        local notify_id = Snacks.notify('Running git auto-commit...', { 
          level = 'info',
          timeout = false  -- Keep notification open
        })
        vim.system({'git', 'auto-commit'}, {}, function(result)
          notify_id.hide()  -- Dismiss the running notification
          if result.code == 0 then
            Snacks.notify('Git auto-commit completed', { level = 'info' })
          else
            Snacks.notify('Git auto-commit failed', { level = 'error' })
          end
        end)
      end,
      desc = 'Commit staged changes'
    },
    {
      '<leader>gC',
      function()
        local notify_handle = nil
        
        -- Show notification with error handling
        local ok, result = pcall(function()
          return Snacks.notify('Running Claude commit...', { 
            level = 'info',
            timeout = false  -- Keep notification open
          })
        end)
        
        if ok then
          notify_handle = result
        end
        
        vim.system({'claude', 'commit', '-p', '--dangerously-skip-permissions'}, {}, function(result)
          -- Dismiss the running notification
          if notify_handle and notify_handle.hide then
            pcall(function()
              notify_handle.hide()
            end)
          end
          
          -- Show completion notification
          pcall(function()
            if result.code == 0 then
              Snacks.notify('Claude commit completed', { level = 'info' })
            else
              Snacks.notify('Claude commit failed: ' .. (result.stderr or 'Unknown error'), { level = 'error' })
            end
          end)
        end)
      end,
      desc = 'Commit with Claude message'
    },
    { '<leader>gs', function() require('gitsigns').stage_hunk() end, mode = 'v', desc = 'Stage selected hunk' },
    { '<leader>gr', function() require('gitsigns').reset_hunk() end, mode = 'v', desc = 'Reset selected hunk' },
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
