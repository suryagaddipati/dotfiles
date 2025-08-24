local M = {}

function M.tmux_windows()
  local fzf = require('fzf-lua')
  local utils = require('fzf-lua.utils')

  -- Check if inside tmux
  if vim.env.TMUX == nil then
    utils.warn("Not inside a tmux session")
    return
  end

  -- Get current session windows
  local cmd = "tmux list-windows -F '#{window_index}: #{window_name}#{window_flags}'"

  fzf.fzf_exec(cmd, {
    prompt = 'Tmux Windows❯ ',
    actions = {
      ['default'] = function(selected)
        if selected and #selected > 0 then
          local window_idx = selected[1]:match("^(%d+):")
          if window_idx then
            vim.fn.system("tmux select-window -t " .. window_idx)
          end
        end
      end
    },
    fzf_opts = {
      ['--no-multi'] = '',
      ['--header'] = '[Enter:switch] [Esc:cancel]',
    },
  })
end

function M.tmux_sessions()
  local fzf = require('fzf-lua')
  local utils = require('fzf-lua.utils')

  -- Get all tmux sessions
  local cmd = "tmux list-sessions -F '#{session_name}: #{session_windows} windows#{?session_attached, (attached),}' 2>/dev/null"

  fzf.fzf_exec(cmd, {
    prompt = 'Tmux Sessions❯ ',
    actions = {
      ['default'] = function(selected)
        if selected and #selected > 0 then
          local session_name = selected[1]:match("^([^:]+):")
          if session_name then
            if vim.env.TMUX then
              -- Inside tmux, switch client
              vim.fn.system("tmux switch-client -t " .. session_name)
            else
              -- Outside tmux, attach to session
              vim.cmd("!tmux attach-session -t " .. session_name)
            end
          end
        end
      end
    },
    fzf_opts = {
      ['--no-multi'] = '',
      ['--header'] = '[Enter:switch/attach] [Esc:cancel]',
    },
  })
end

function M.claude_activity_windows()
  local fzf = require('fzf-lua')
  local utils = require('fzf-lua.utils')

  -- Check if inside tmux
  if vim.env.TMUX == nil then
    utils.warn("Not inside a tmux session")
    return
  end

  -- Read activity log
  local home = vim.env.HOME
  local activity_log = home .. "/.claude/activity.log"

  -- Check if file exists and has content
  local f = io.open(activity_log, "r")
  if not f then
    utils.info("No Claude notifications")
    return
  end

  local entries = {}
  for line in f:lines() do
    if line and line ~= "" then
      table.insert(entries, line)
    end
  end
  f:close()

  if #entries == 0 then
    utils.info("No Claude notifications")
    return
  end

  -- Get current session and window
  local current_session = vim.fn.system("tmux display-message -p '#{session_name}'"):gsub("\n", "")
  local current_window = vim.fn.system("tmux display-message -p '#{window_index}'"):gsub("\n", "")

  -- Process entries to get window details
  local function process_entries(fzf_cb)
    for _, entry in ipairs(entries) do
      local session, window_idx = entry:match("^([^:]+):(%d+)$")
      if session and window_idx then
        -- Get window name for this session:window
        local window_info = vim.fn.system(string.format(
          "tmux list-windows -t %s -F '#{window_index}:#{window_name}' 2>/dev/null | grep '^%s:'",
          vim.fn.shellescape(session),
          window_idx
        )):gsub("\n", "")

        local window_name = window_info:match("^%d+:(.+)$") or "unknown"

        -- Format display with current marker
        local display = string.format("%s:%s - %s", session, window_idx, window_name)
        if session == current_session and window_idx == current_window then
          display = display .. " (current)"
        end

        fzf_cb(display)
      end
    end
    fzf_cb()
  end

  fzf.fzf_exec(process_entries, {
    prompt = 'Claude Activity❯ ',
    actions = {
      ['default'] = function(selected)
        if selected and #selected > 0 then
          -- Parse selection
          local session, window_idx = selected[1]:match("^([^:]+):(%d+)")
          if session and window_idx then
            -- Switch to the session and window
            vim.fn.system(string.format("tmux switch-client -t %s:%s",
              vim.fn.shellescape(session),
              window_idx))

          end
        end
      end
    },
    fzf_opts = {
      ['--no-multi'] = '',
      ['--header'] = '[Enter:switch & clear] [Esc:cancel] | Windows with Claude notifications',
    },
  })
end

function M.code_projects()
  local fzf = require('fzf-lua')
  local utils = require('fzf-lua.utils')

  -- Get directories in ~/code/
  local home = vim.env.HOME
  local code_path = home .. "/code"

  -- List only directories in ~/code/, excluding hidden directories
  local cmd = "find " .. code_path .. " -maxdepth 1 -type d -not -path " .. code_path .. " -not -path '*/\\.*' | sed 's|" .. code_path .. "/||' | sort"

  -- Get existing tmux sessions for annotation
  local sessions = {}
  local session_list = vim.fn.systemlist("tmux list-sessions -F '#{session_name}' 2>/dev/null")
  for _, session in ipairs(session_list) do
    sessions[session] = true
  end

  -- Process directory list and annotate with session status
  local function process_dirs(fzf_cb)
    local dirs = vim.fn.systemlist(cmd)
    local active_dirs = {}
    local inactive_dirs = {}

    -- Separate active and inactive directories
    for _, dir in ipairs(dirs) do
      if sessions[dir] then
        -- Prefix with "★" to boost in search ranking
        table.insert(active_dirs, "★ " .. dir .. " [active]")
      else
        table.insert(inactive_dirs, "  " .. dir)
      end
    end

    -- Sort both groups alphabetically
    table.sort(active_dirs)
    table.sort(inactive_dirs)

    -- Output active sessions first, then inactive ones
    for _, dir in ipairs(active_dirs) do
      fzf_cb(dir)
    end
    for _, dir in ipairs(inactive_dirs) do
      fzf_cb(dir)
    end
    fzf_cb()
  end

  fzf.fzf_exec(process_dirs, {
    prompt = 'Code Projects❯ ',
    actions = {
      ['default'] = function(selected)
        if selected and #selected > 0 then
          -- Extract project name (remove prefix and annotations)
          local project_name = selected[1]:gsub("^[★ ]*", ""):gsub("%s*%[active%]%s*$", "")

          if project_name and project_name ~= "" then
            -- Check if session exists
            local session_exists = vim.fn.system("tmux has-session -t " .. vim.fn.shellescape(project_name) .. " 2>/dev/null; echo $?"):gsub("\n", "") == "0"

            if not session_exists then
              -- Create new session with the project directory as working directory
              local project_path = code_path .. "/" .. project_name
              vim.fn.system("tmux new-session -d -s " .. vim.fn.shellescape(project_name) .. " -c " .. vim.fn.shellescape(project_path))
            end

            -- Switch to or attach to the session
            if vim.env.TMUX then
              -- Inside tmux, switch client
              vim.fn.system("tmux switch-client -t " .. vim.fn.shellescape(project_name))
            else
              -- Outside tmux, attach to session
              vim.cmd("!tmux attach-session -t " .. vim.fn.shellescape(project_name))
            end
          end
        end
      end
    },
    fzf_opts = {
      ['--no-multi'] = '',
      ['--header'] = '[Enter:switch/create] [Esc:cancel] | [active] = existing session',
    },
  })
end

return M
