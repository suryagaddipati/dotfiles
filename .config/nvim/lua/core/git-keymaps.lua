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
      if result.code == 0 then
        if success_msg then
          -- Update existing notification with success
          Snacks.notifier.notify(success_msg, "info", {
            id = note_id,  -- Reuse the same ID to update in-place
            title = "Git ✓",
            position = "bottom_right",
            spinner = false,  -- Remove spinner
            timeout = 2000,  -- Auto-dismiss success after 2 seconds
          })
        else
          -- Just hide if no success message
          Snacks.notifier.hide(note_id)
        end
      else
        -- Update existing notification with error
        local error_text = error_msg or "Git command failed"
        Snacks.notifier.notify(error_text .. ": " .. (result.stderr or ""), "error", {
          id = note_id,  -- Reuse the same ID to update in-place
          title = "Git ✗",
          position = "bottom_right",
          spinner = false,  -- Remove spinner
          timeout = 5000,  -- Keep errors visible longer (5 seconds)
        })
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
  local branch = wt.name == 'main' and 'master' or wt.name
  local repo_root = vim.fn.system('git worktree list | head -1 | awk \'{print $1}\''):gsub('\n', '')
  local worktree_path = repo_root .. '/.worktrees/' .. branch

  -- For main/master branch, use the repo root
  if branch == 'master' or branch == 'main' then
    worktree_path = repo_root
  end


  -- If in tmux, switch or create window
  if vim.env.TMUX then
    local window_exists = vim.fn.system('tmux list-windows -F "#W" | grep -q "^' .. branch .. '$"; echo $?'):gsub('\n', '')
    if window_exists == '0' then
      -- Window exists, switch to it
      vim.fn.system('tmux select-window -t ":' .. branch .. '"')
    else
      -- Create new window
      vim.fn.system('tmux new-window -n "' .. branch .. '" -c "' .. worktree_path .. '"')
    end
  end

  vim.notify('Switched to worktree: ' .. wt.name .. ' at ' .. worktree_path, vim.log.levels.INFO)
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
            local output = vim.fn.system(string.format('twc "%s"', branch))

            if vim.v.shell_error == 0 then
              vim.notify('Worktree created: ' .. branch, vim.log.levels.INFO)
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
        local output = vim.fn.system(string.format('twd "%s"', wt.name))
        if vim.v.shell_error == 0 then
          vim.notify('Worktree deleted: ' .. wt.name, vim.log.levels.INFO)
        else
          vim.notify('Failed to delete worktree: ' .. output, vim.log.levels.ERROR)
        end
      end
    end)
  end, function(wt) return wt.name ~= 'main' end)
end, { desc = 'Delete git worktree' })

-- List worktrees
keymap('n', '<leader>gwl', function()
  local worktrees = get_worktrees()
  local items = {}
  
  -- Get current worktree path to identify the active one
  local current_path = vim.fn.getcwd()
  local current_wt_output = vim.fn.system('git rev-parse --show-toplevel 2>/dev/null'):gsub('\n', '')
  
  for _, wt in ipairs(worktrees) do
    local is_active = (wt.path == current_wt_output)
    local marker = is_active and '● ' or '  '
    local format_string = is_active and '%s%-18s %-30s %s' or '%s%-18s %-30s %s'
    
    table.insert(items, string.format(format_string,
      marker, wt.name, wt.branch or '(detached)', wt.commit or ''))
  end
  
  if #items == 0 then
    vim.notify('No worktrees found', vim.log.levels.INFO)
    return
  end
  
  require('fzf-lua').fzf_exec(items, {
    prompt = 'Git worktrees> ',
    actions = {
      ['default'] = function(selected)
        if selected and #selected > 0 then
          -- Skip the marker when extracting the name
          local name = selected[1]:match('^%s*%S*%s+(%S+)') or selected[1]:match('^%s*(%S+)')
          for _, wt in ipairs(worktrees) do
            if wt.name == name then
              switch_to_worktree(wt)
              break
            end
          end
        end
      end
    }
  })
end, { desc = 'List git worktrees' })

-- Sync tmux windows with worktrees
keymap('n', '<leader>gwS', function()
  if not vim.env.TMUX then
    vim.notify('Not in a tmux session', vim.log.levels.WARN)
    return
  end

  vim.fn.system('twsync')
  vim.notify('Synced tmux windows with worktrees', vim.log.levels.INFO)
end, { desc = 'Sync tmux windows with worktrees' })

-- Git fzf-lua integration
keymap('n', '<leader>gf', function() require('fzf-lua').git_files() end, { desc = 'Git files' })
keymap('n', '<leader>gs', function() require('fzf-lua').git_status() end, { desc = 'Git status' })
keymap('n', '<leader>gl', function() require('fzf-lua').git_commits() end, { desc = 'Git log' })
keymap('n', '<leader>gL', function() require('fzf-lua').git_bcommits() end, { desc = 'Git log (current file)' })
keymap('n', '<leader>gb', function() require('fzf-lua').git_branches() end, { desc = 'Git branches' })
