return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = function()
    require('claudecode').setup({
      terminal_cmd = 'claude --dangerously-skip-permissions',
      terminal = {
        split_side = "right",           -- "left", "right", "top", "bottom"
        split_height_percentage = 0.30, -- For horizontal splits (top/bottom)
        split_width_percentage = 0.40,  -- For vertical splits (left/right)
        provider = "auto",              -- "auto", "toggleterm", "native"
        direction = nil,                -- Auto-determined from split_side
        auto_close = true,
      },
    })
  end,
  keys = {
    -- Core Claude Code operations
    { '<leader>c',  nil,                              desc = 'Claude Code' },
    { '<leader>cc', '<cmd>ClaudeCode<cr>',            desc = 'Toggle Claude' },
    { '<leader>cf', '<cmd>ClaudeCodeFocus<cr>',       desc = 'Focus Claude' },
    { '<leader>cr', '<cmd>ClaudeCode --resume<cr>',   desc = 'Resume Claude' },
    { '<leader>cC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
    { '<leader>cb', '<cmd>ClaudeCodeAdd %<cr>',       desc = 'Add current buffer' },
    { '<leader>cs', '<cmd>ClaudeCodeSend<cr>',        mode = 'v',                 desc = 'Send to Claude' },
    {
      '<leader>ct',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Add file',
      ft = { 'NvimTree', 'neo-tree', 'oil' },
    },
    { '<leader>ca', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>cd', '<cmd>ClaudeCodeDiffDeny<cr>',   desc = 'Deny diff' },

    -- Git + Claude Integration (moved to <leader>g* namespace)
    { '<leader>ga', '<cmd>ClaudeCodeSendHunk<cr>',   desc = 'Git: Add hunk to Claude' },
    { '<leader>gA', '<cmd>ClaudeCodeAdd %<cr>',      desc = 'Git: Add buffer to Claude' },
    { '<leader>gi', '<cmd>ClaudeCodeSendHunk<cr>',   desc = 'Git: Send hunk info to Claude' },
    {
      '<leader>gI',
      function()
        -- Send entire diff to Claude for review
        vim.cmd('ClaudeCodeAdd %')
        vim.notify('Buffer added to Claude for diff review', vim.log.levels.INFO)
      end,
      desc = 'Git: Send diff to Claude for review'
    },
  },
}
