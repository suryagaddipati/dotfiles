local keymap = vim.keymap.set

keymap('n', '<leader>w', '<cmd>w<cr>')
keymap('n', '<leader>q', '<cmd>q<cr>')
keymap('n', '<leader>x', '<cmd>x<cr>')
keymap('n', '<leader>/', '<cmd>noh<cr>')
keymap('n', '<leader>h', '<cmd>noh<cr>')

keymap('n', '<C-h>', '<C-w>h')
keymap('n', '<C-j>', '<C-w>j')
keymap('n', '<C-k>', '<C-w>k')
keymap('n', '<C-l>', '<C-w>l')

-- Window resizing
keymap('n', '<leader>+', '<cmd>resize +4<cr>')
keymap('n', '<leader>-', '<cmd>resize -4<cr>')
keymap('n', '<leader>>', '<cmd>vertical resize +4<cr>')
keymap('n', '<leader><', '<cmd>vertical resize -4<cr>')

keymap('n', '<Tab>', '<cmd>bnext<cr>')
keymap('n', '<S-Tab>', '<cmd>bprev<cr>')
keymap('n', '<leader>bd', '<cmd>bd<cr>')

keymap('n', 'j', 'gj')
keymap('n', 'k', 'gk')
keymap('n', 'n', 'nzzzv')
keymap('n', 'N', 'Nzzzv')

keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

keymap('n', '<leader>m', function()
  local file = vim.fn.expand('%')
  if vim.bo.filetype == 'markdown' then
    require('toggleterm.terminal').Terminal:new({
      cmd = 'glow ' .. file,
      direction = 'vertical',
      size = 80,
      close_on_exit = false,
    }):toggle()
  else
    print('Not a markdown file')
  end
end, { desc = 'Preview markdown' })

keymap('n', '<leader>gc', ':ToggleTerm direction=float<CR>git commit<CR>', { desc = 'Git Commit' })


