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
keymap('n', '<leader>gc', function()
  run_git_command(
    { "git", "ai-commit-staged" },
    "Running git commit...",
    "Git commit successful",
    "Git commit failed"
  )
end, { desc = 'AI Commit staged changes' })

keymap('n', '<leader>gC', function()
  run_git_command(
    { "git", "ai-commit" },
    "Running AI commit...",
    "AI commit successful",
    "AI commit failed"
  )
end, { desc = 'AI commit everything' })

keymap('n', '<leader>gp', function()
  run_git_command(
    { "git", "push" },
    "Running git push...",
    "Git push successful",
    "Git push failed"
  )
end, { desc = 'Git push' })

-- Git worktree shortcuts
local function get_worktrees()
  local output = vim.fn.system('git worktree list --porcelain')
  local worktrees = {}
  local current = {}
  
  for line in output:gmatch('[^\r\n]+') do
    if line:match('^worktree ') then
      if current.path then table.insert(worktrees, current) end
      current = { path = line:match('^worktree (.+)') }
      current.name = current.path:match('/%.worktrees/([^/]+)') or 'main'
    elseif line:match('^HEAD ') then
      current.commit = line:match('^HEAD (.+)'):sub(1, 8)
    elseif line:match('^branch ') then
      current.branch = line:match('^branch refs/heads/(.+)')
    end
  end
  if current.path then table.insert(worktrees, current) end
  return worktrees
end

local function switch_to_worktree(wt)
  vim.cmd('cd ' .. vim.fn.fnameescape(wt.path))
  vim.notify('Switched to worktree: ' .. wt.name, vim.log.levels.INFO)
  if vim.env.TMUX then
    local window_name = wt.name == 'main' and 'master' or wt.name
    vim.fn.system(string.format('tmux new-window -n "%s" -c "%s" || tmux select-window -t ":%s"', 
      window_name, wt.path, window_name))
  end
end

local function worktree_picker(prompt, action, filter)
  local worktrees = get_worktrees()
  local items = {}
  
  for _, wt in ipairs(worktrees) do
    if not filter or filter(wt) then
      table.insert(items, string.format('%-20s %-30s %s', 
        wt.name, wt.branch or '(detached)', wt.commit or ''))
    end
  end
  
  if #items == 0 then
    vim.notify('No worktrees available', vim.log.levels.INFO)
    return
  end
  
  require('fzf-lua').fzf_exec(items, {
    prompt = prompt,
    actions = {
      ['default'] = function(selected)
        if selected and #selected > 0 then
          local name = selected[1]:match('^(%S+)')
          for _, wt in ipairs(worktrees) do
            if wt.name == name then
              action(wt)
              break
            end
          end
        end
      end
    }
  })
end

-- Create worktree
keymap('n', '<leader>gwc', function()
  require('fzf-lua').fzf_exec(
    'git branch -a --no-color | sed "s/^[* ] //" | sed "s/^remotes\\///"',
    {
      prompt = 'Create worktree for branch> ',
      actions = {
        ['default'] = function(selected)
          if selected and #selected > 0 then
            local branch = selected[1]:gsub('^origin/', '')
            local cmd = string.format('cd "$(git rev-parse --show-toplevel)" && git-wt cr "%s"', branch)
            local output = vim.fn.system(cmd)
            
            if vim.v.shell_error == 0 then
              vim.notify('Worktree created: ' .. branch, vim.log.levels.INFO)
              local cd_cmd = output:match('cd "([^"]+)"')
              if cd_cmd then
                vim.cmd('cd ' .. vim.fn.fnameescape(cd_cmd))
                vim.notify('Changed to worktree: ' .. branch, vim.log.levels.INFO)
                if vim.env.TMUX then
                  vim.fn.system(string.format('tmux new-window -n "%s" -c "%s" || tmux select-window -t ":%s"', 
                    branch, cd_cmd, branch))
                end
              end
            else
              vim.notify('Failed to create worktree: ' .. output, vim.log.levels.ERROR)
            end
          end
        end
      }
    }
  )
end, { desc = 'Create git worktree' })

-- Switch worktree
keymap('n', '<leader>gws', function()
  worktree_picker('Switch to worktree> ', switch_to_worktree)
end, { desc = 'Switch git worktree' })

-- Delete worktree
keymap('n', '<leader>gwd', function()
  worktree_picker('Delete worktree> ', function(wt)
    vim.ui.select({'Yes', 'No'}, {
      prompt = 'Delete worktree "' .. wt.name .. '"?'
    }, function(choice)
      if choice == 'Yes' then
        local cmd = string.format('cd "$(git rev-parse --show-toplevel)" && git-wt d "%s"', wt.name)
        local output = vim.fn.system(cmd)
        if vim.v.shell_error == 0 then
          vim.notify('Worktree deleted: ' .. wt.name, vim.log.levels.INFO)
          if vim.env.TMUX then
            vim.fn.system(string.format('tmux kill-window -t ":%s" 2>/dev/null', wt.name))
          end
        else
          vim.notify('Failed to delete worktree: ' .. output, vim.log.levels.ERROR)
        end
      end
    end)
  end, function(wt) return wt.name ~= 'main' end)
end, { desc = 'Delete git worktree' })

-- Sync tmux windows with worktrees
keymap('n', '<leader>gwS', function()
  if not vim.env.TMUX then
    vim.notify('Not in a tmux session', vim.log.levels.WARN)
    return
  end
  
  local worktrees = get_worktrees()
  local synced = 0
  
  for _, wt in ipairs(worktrees) do
    local window_name = wt.name == 'main' and 'master' or wt.name
    local check_cmd = string.format('tmux list-windows -F "#W" | grep -q "^%s$"', window_name)
    if vim.fn.system(check_cmd) ~= '' then
      vim.fn.system(string.format('tmux new-window -n "%s" -c "%s"', window_name, wt.path))
      synced = synced + 1
    end
  end
  
  vim.notify(synced > 0 and 
    string.format('Synced %d tmux windows with worktrees', synced) or
    'All worktrees already have tmux windows', vim.log.levels.INFO)
end, { desc = 'Sync tmux windows with worktrees' })

-- Git fzf-lua integration
keymap('n', '<leader>gf', function() require('fzf-lua').git_files() end, { desc = 'Git files' })
keymap('n', '<leader>gs', function() require('fzf-lua').git_status() end, { desc = 'Git status' })
keymap('n', '<leader>gl', function() require('fzf-lua').git_commits() end, { desc = 'Git log' })
keymap('n', '<leader>gb', function() require('fzf-lua').git_branches() end, { desc = 'Git branches' })