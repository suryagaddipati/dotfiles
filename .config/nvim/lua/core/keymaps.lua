local keymap = vim.keymap.set
local function skip_closer()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1], cursor[2]
  local line = vim.api.nvim_get_current_line()
  local next_char = line:sub(col + 1, col + 1)

  if next_char ~= '' and next_char:match("[%])}%>\"']") then
    vim.api.nvim_win_set_cursor(0, { row, col + 1 })
    return
  end

  local ok, luasnip = pcall(require, 'luasnip')
  if ok and luasnip.choice_active() then
    luasnip.change_choice(1)
    return
  end

  local rest = line:sub(col + 2)
  local move = rest:find("[%])}%>\"']")
  if move then
    vim.api.nvim_win_set_cursor(0, { row, col + move + 1 })
  end
end

keymap({ 'i', 's' }, '<C-]>', skip_closer, { silent = true, desc = 'Skip closing pair or cycle snippet choice' })

keymap('i', 'jj', '<Esc>', { noremap = true, silent = true, desc = 'Exit insert mode' })
keymap('i', 'jk', '<Esc>', { noremap = true, silent = true, desc = 'Exit insert mode' })
keymap('i', '<C-;>', '<C-o>a')
keymap('i', '<C-e>', '<C-o>$', { noremap = true, silent = true, desc = 'Move to end of line' })
keymap('i', '<C-a>', '<C-o>^', { noremap = true, silent = true, desc = 'Move to start of line' })
keymap('i', '<C-b>', '<Left>', { noremap = true, silent = true, desc = 'Move left one character' })
keymap('i', '<C-f>', '<Right>', { noremap = true, silent = true, desc = 'Move right one character' })

keymap('t', 'jj', '<C-\\><C-n>', { noremap = true, silent = true, desc = 'Exit terminal mode' })
keymap('t', 'jk', '<C-\\><C-n>', { noremap = true, silent = true, desc = 'Exit terminal mode' })
keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true, desc = 'Exit terminal mode' })

keymap('n', '<leader>w', '<cmd>w<cr>')
keymap('n', '<leader>q', '<cmd>q<cr>')
keymap('n', '<leader>x', '<cmd>wa<cr><cmd>qa!<cr>')
keymap('n', '<leader>X', '<cmd>qa!<cr>', { desc = 'Force quit without saving' })
keymap('n', '<leader>/', '<cmd>noh<cr>')
keymap('n', '<leader>h', '<cmd>noh<cr>')

keymap('n', '<C-h>', '<C-w>h')
keymap('n', '<C-j>', '<C-w>j')
keymap('n', '<C-k>', '<C-w>k')
keymap('n', '<C-l>', '<C-w>l')

-- Window resizing
keymap('n', '<leader>+', '<cmd>resize -4<cr>')
keymap('n', '<leader>-', '<cmd>resize +4<cr>')
keymap('n', '<leader>>', '<cmd>vertical resize -10<cr>')
keymap('n', '<leader><', '<cmd>vertical resize +10<cr>')

-- Buffer navigation (vim-standard approach)
keymap('n', '<C-^>', '<cmd>b#<cr>', { desc = 'Switch to last buffer' })
keymap('n', '<leader><leader>', '<cmd>b#<cr>', { desc = 'Switch to last buffer' })
keymap('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer' })
keymap('n', '[b', '<cmd>bprev<cr>', { desc = 'Previous buffer' })
keymap('n', '<leader>bd', '<cmd>bd<cr>', { desc = 'Delete buffer' })
keymap('n', '<leader>bD', '<cmd>bd!<cr>', { desc = 'Force delete buffer' })
keymap('n', '<leader>ba', '<cmd>bufdo bd<cr>', { desc = 'Delete all buffers' })

-- Smart buffer management
keymap('n', '<leader>bo', '<cmd>%bd|e#|bd#<cr>', { desc = 'Delete all buffers except current' })
keymap('n', '<leader>bw', '<cmd>w|bd<cr>', { desc = 'Save and close buffer' })

keymap('n', 'j', 'gj')
keymap('n', 'k', 'gk')
keymap('n', 'n', 'nzzzv')
keymap('n', 'N', 'Nzzzv')

-- Enhanced search and navigation
keymap('n', '*', '*zzzv', { desc = 'Search word under cursor forward' })
keymap('n', '#', '#zzzv', { desc = 'Search word under cursor backward' })
keymap('n', 'g*', 'g*zzzv', { desc = 'Search partial word forward' })
keymap('n', 'g#', 'g#zzzv', { desc = 'Search partial word backward' })

-- Better search and replace workflow
keymap('n', '<leader>sr', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>',
  { desc = 'Search and replace word under cursor' })
keymap('v', '<leader>sr', '"hy:%s/<C-r>h/<C-r>h/gc<left><left><left>', { desc = 'Search and replace selection' })

keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

-- Smart text editing features
keymap('n', 'J', function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd('join')
  vim.api.nvim_win_set_cursor(0, cursor_pos)
end, { desc = 'Smart line join (preserve cursor)' })

-- Better text objects and manipulation
keymap('n', '<leader>cc', 'gcc', { desc = 'Comment line', remap = true })
keymap('v', '<leader>cc', 'gc', { desc = 'Comment selection', remap = true })

-- Quick word/WORD deletion and change
keymap('n', 'dw', 'diw', { desc = 'Delete inner word' })
keymap('n', 'cw', 'ciw', { desc = 'Change inner word' })
keymap('n', 'dW', 'diW', { desc = 'Delete inner WORD' })
keymap('n', 'cW', 'ciW', { desc = 'Change inner WORD' })

-- Smart indentation
keymap('n', '>', '>>', { desc = 'Indent line' })
keymap('n', '<', '<<', { desc = 'Unindent line' })

-- Quick line duplication
keymap('n', '<leader>ld', 'yyp', { desc = 'Duplicate line down' })
keymap('n', '<leader>lu', 'yyP', { desc = 'Duplicate line up' })

-- Move lines up/down
keymap('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down' })
keymap('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })
keymap('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
keymap('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Fix paste behavior - paste without overriding register
keymap('v', '<leader>p', '"_dP', { desc = 'Paste without overriding register' })
keymap('v', 'p', '"_dP', { desc = 'Paste without overriding register (default)' })

-- Advanced register management
keymap('n', '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
keymap('v', '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
keymap('n', '<leader>Y', '"+Y', { desc = 'Yank line to system clipboard' })
keymap('n', '<leader>d', '"_d', { desc = 'Delete without yanking' })
keymap('v', '<leader>d', '"_d', { desc = 'Delete without yanking' })

-- Quick register access (commonly used registers)
keymap('n', '<leader>1', '"1p', { desc = 'Paste from register 1' })
keymap('n', '<leader>2', '"2p', { desc = 'Paste from register 2' })
keymap('n', '<leader>3', '"3p', { desc = 'Paste from register 3' })
keymap('n', '<leader>0', '"0p', { desc = 'Paste from yank register' })

keymap('n', '<leader>mg', function()
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
end, { desc = 'Preview markdown with glow' })

keymap('n', '<leader>gc', ':ToggleTerm direction=float<CR>git commit<CR>', { desc = 'Git Commit' })

-- Convenience features and quality of life improvements
keymap('n', '<leader>cd', ':cd %:p:h<CR>:pwd<CR>', { desc = 'Change to file directory' })
keymap('n', '<leader>cp', ':let @+ = expand("%:p")<CR>', { desc = 'Copy file path to clipboard' })
keymap('n', '<leader>cf', ':let @+ = expand("%:t")<CR>', { desc = 'Copy filename to clipboard' })

-- Quick list navigation
keymap('n', ']q', ':cnext<CR>zz', { desc = 'Next quickfix item' })
keymap('n', '[q', ':cprev<CR>zz', { desc = 'Previous quickfix item' })
keymap('n', ']l', ':lnext<CR>zz', { desc = 'Next location list item' })
keymap('n', '[l', ':lprev<CR>zz', { desc = 'Previous location list item' })

-- Better window closing
keymap('n', '<leader>wq', ':wq<CR>', { desc = 'Save and quit window' })
keymap('n', '<leader>wa', ':wa<CR>', { desc = 'Save all windows' })
keymap('n', '<leader>wA', ':wa!<CR>', { desc = 'Force save all windows' })

-- Toggle settings
keymap('n', '<leader>tn', ':set number!<CR>', { desc = 'Toggle line numbers' })
keymap('n', '<leader>tr', ':set relativenumber!<CR>', { desc = 'Toggle relative numbers' })
keymap('n', '<leader>tw', ':set wrap!<CR>', { desc = 'Toggle word wrap' })
keymap('n', '<leader>ts', ':set spell!<CR>', { desc = 'Toggle spell check' })
