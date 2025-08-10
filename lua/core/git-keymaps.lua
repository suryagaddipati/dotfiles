local keymap = vim.keymap.set

--- Helper function for git commands with notifications
local function run_git_command(command, message, success_msg, error_msg)
  local note_id = Snacks.notifier.notify(message, "info", {
    spinner = true,
    title = "Git",
    position = "bottom_right",
  })

  vim.system(command, {}, function(result)
    vim.schedule(function()
      Snacks.notifier.hide(note_id)
      if result.code == 0 then
        if success_msg then
          vim.notify(success_msg, vim.log.levels.INFO)
        end
      else
        local error_text = error_msg or "Git command failed"
        vim.notify(error_text .. ": " .. (result.stderr or ""), vim.log.levels.ERROR)
      end
    end)
  end)
end

--- Git shortcuts
keymap('n',
  '<leader>gc',
  function()
    run_git_command(
      { "git", "ai-commit-staged" },
      "Running git commit...",
      "Git commit successful",
      "Git commit failed"
    )
  end,
  { desc = 'AI Commit staged changes' }
)

keymap('n',
  '<leader>gC',
  function()
    run_git_command(
      { "git", "ai-commit" },
      "Running AI commit...",
      "AI commit successful",
      "AI commit failed"
    )
  end,
  { desc = 'AI commit everything' }
)

keymap('n',
  '<leader>gp',
  function()
    run_git_command(
      { "git", "push" },
      "Running git push...",
      "Git push successful",
      "Git push failed"
    )
  end,
  { desc = 'Git push' }
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

keymap('n', '<leader>gwd', function()
  vim.ui.input({ prompt = 'Delete worktree: ' }, function(branch)
    if branch and branch ~= '' then
      local repo_root = vim.fn.system('git rev-parse --show-toplevel'):gsub('\n', '')
      local worktree_path = repo_root .. '/.worktrees/' .. branch
      local cmd = 'git wtd ' .. worktree_path
      vim.fn.system(cmd)
      if vim.v.shell_error == 0 then
        vim.notify('Worktree deleted: ' .. branch, vim.log.levels.INFO)
      else
        vim.notify('Failed to delete worktree: ' .. branch, vim.log.levels.ERROR)
      end
    end
  end)
end, { desc = 'Delete git worktree' })

-- Git fzf-lua integration
keymap('n', '<leader>gf', function() require('fzf-lua').git_files() end, { desc = 'Git files' })
keymap('n', '<leader>gs', function() require('fzf-lua').git_status() end, { desc = 'Git status' })
keymap('n', '<leader>gl', function() require('fzf-lua').git_commits() end, { desc = 'Git log' })
keymap('n', '<leader>gb', function() require('fzf-lua').git_branches() end, { desc = 'Git branches' })

