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
    { '<leader>gc', '<cmd>!git auto-commit<cr>', desc = 'Auto-commit with AI message' },
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