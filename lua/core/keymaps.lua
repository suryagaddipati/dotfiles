local keymap = vim.keymap.set

keymap('n', '<leader>w', '<cmd>w<cr>')
keymap('n', '<leader>q', '<cmd>q<cr>')
keymap('n', '<leader>x', '<cmd>wa<cr><cmd>qa!<cr>')
keymap('n', '<leader>/', '<cmd>noh<cr>')
keymap('n', '<leader>h', '<cmd>noh<cr>')

keymap('n', '<C-h>', '<C-w>h')
keymap('n', '<C-j>', '<C-w>j')
keymap('n', '<C-k>', '<C-w>k')
keymap('n', '<C-l>', '<C-w>l')

-- Window resizing
keymap('n', '<leader>+', '<cmd>resize +4<cr>')
keymap('n', '<leader>-', '<cmd>resize -4<cr>')
keymap('n', '<leader>>', '<cmd>vertical resize +10<cr>')
keymap('n', '<leader><', '<cmd>vertical resize -10<cr>')

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

--- Git shortcuts
keymap('n',
  '<leader>gc',
  function()
    local note_id = Snacks.notifier.notify("Running git commit...", "info", {
      spinner = true,
      title = "Git",
      position = "bottom_right",
    })
    vim.system({ "git", "claude-staged-commit" }, {}, function(_)
      vim.schedule(function()
        Snacks.notifier.hide(note_id)
      end)
    end)
  end,
  { desc = 'Commit staged changes' }
)

keymap('n',
  '<leader>gC',
  function()
    local note_id = Snacks.notifier.notify("Running Claude commit...", "info", {
      spinner = true,
      title = "Git",
      position = "bottom_right",
    })
    vim.system({ "git", "claude-commit" }, {}, function(_)
      vim.schedule(function()
        Snacks.notifier.hide(note_id)
      end)
    end)
  end,
  { desc = 'Claude commit everything' }
)

-- Git worktree shortcuts
keymap('n', '<leader>gwc', function()
  vim.ui.input({ prompt = 'Create worktree for branch: ' }, function(branch)
    if branch and branch ~= '' then
      local cmd = 'git wtc ' .. branch
      local output = vim.fn.system(cmd)
      if vim.v.shell_error == 0 then
        vim.notify('Worktree created: ' .. branch, vim.log.levels.INFO)
        -- Extract cd command from output and execute it
        local cd_cmd = output:match('cd (.+)')
        if cd_cmd then
          vim.cmd('cd ' .. cd_cmd)
          vim.notify('Changed directory to: ' .. cd_cmd, vim.log.levels.INFO)
        end
      else
        vim.notify('Failed to create worktree: ' .. branch, vim.log.levels.ERROR)
      end
    end
  end)
end, { desc = 'Create git worktree' })

keymap('n', '<leader>gwt', function()
  vim.ui.input({ prompt = 'Switch to worktree: ' }, function(branch)
    if branch and branch ~= '' then
      local output = vim.fn.system('git wt ' .. branch)
      if vim.v.shell_error == 0 then
        -- Extract cd command from output and execute it
        local cd_cmd = output:match('cd (.+)')
        if cd_cmd then
          vim.cmd('cd ' .. cd_cmd)
          vim.notify('Switched to worktree: ' .. branch, vim.log.levels.INFO)
        end
      else
        vim.notify('Worktree not found: ' .. branch, vim.log.levels.ERROR)
      end
    end
  end)
end, { desc = 'Switch to git worktree' })

keymap('n', '<leader>gwl', function()
  local output = vim.fn.system('git wtl')
  if vim.v.shell_error == 0 then
    -- Create a new buffer to display worktree list
    local buf = vim.api.nvim_create_buf(false, true)
    local lines = vim.split(output, '\n')
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(buf, 'filetype', 'gitworktree')
    
    -- Open in a split
    vim.cmd('split')
    vim.api.nvim_win_set_buf(0, buf)
    vim.api.nvim_buf_set_name(buf, 'Git Worktrees')
    
    -- Add keymaps for the worktree list buffer
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', '', {
      noremap = true,
      silent = true,
      callback = function()
        local line = vim.api.nvim_get_current_line()
        local worktree_name = line:match('^(%S+)')
        if worktree_name and worktree_name ~= '' then
          vim.cmd('q') -- Close the list window
          local output = vim.fn.system('git wt ' .. worktree_name)
          if vim.v.shell_error == 0 then
            local cd_cmd = output:match('cd (.+)')
            if cd_cmd then
              vim.cmd('cd ' .. cd_cmd)
              vim.notify('Switched to worktree: ' .. worktree_name, vim.log.levels.INFO)
            end
          end
        end
      end
    })
  else
    vim.notify('Failed to list worktrees', vim.log.levels.ERROR)
  end
end, { desc = 'List git worktrees' })

keymap('n', '<leader>gwr', function()
  vim.ui.input({ prompt = 'Remove worktree: ' }, function(branch)
    if branch and branch ~= '' then
      local repo_root = vim.fn.system('git rev-parse --show-toplevel'):gsub('\n', '')
      local worktree_path = repo_root .. '/.worktrees/' .. branch
      local cmd = 'git worktree remove ' .. worktree_path
      vim.fn.system(cmd)
      if vim.v.shell_error == 0 then
        vim.notify('Worktree removed: ' .. branch, vim.log.levels.INFO)
      else
        vim.notify('Failed to remove worktree: ' .. branch, vim.log.levels.ERROR)
      end
    end
  end)
end, { desc = 'Remove git worktree' })
