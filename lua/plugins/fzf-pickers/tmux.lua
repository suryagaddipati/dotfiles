local M = {}
local fzf = require('fzf-lua')
local utils = require('fzf-lua.utils')

-- Helper to check tmux environment
local function check_tmux()
  if not vim.env.TMUX then
    utils.warn("Not inside a tmux session")
    return false
  end
  return true
end

-- Helper to switch/attach to tmux target
local function switch_to_target(target, is_session)
  if vim.env.TMUX then
    vim.fn.system("tmux switch-client -t " .. target)
  elseif is_session then
    vim.cmd("!tmux attach-session -t " .. target)
  end
end

function M.tmux_windows()
  if not check_tmux() then return end
  
  fzf.fzf_exec("tmux list-windows -F '#{window_index}: #{window_name}#{window_flags}'", {
    prompt = 'Tmux Windows❯ ',
    actions = {
      ['default'] = function(selected)
        if selected and selected[1] then
          local idx = selected[1]:match("^(%d+):")
          if idx then vim.fn.system("tmux select-window -t " .. idx) end
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
  local cmd = "tmux list-sessions -F '#{session_name}: #{session_windows} windows#{?session_attached, (attached),}' 2>/dev/null"
  
  fzf.fzf_exec(cmd, {
    prompt = 'Tmux Sessions❯ ',
    actions = {
      ['default'] = function(selected)
        if selected and selected[1] then
          local session = selected[1]:match("^([^:]+):")
          if session then switch_to_target(session, true) end
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
  if not check_tmux() then return end
  
  local activity_log = vim.env.HOME .. "/.claude/activity.log"
  local f = io.open(activity_log, "r")
  if not f then
    utils.info("No Claude notifications")
    return
  end
  
  local entries = {}
  for line in f:lines() do
    if line ~= "" then table.insert(entries, line) end
  end
  f:close()
  
  if #entries == 0 then
    utils.info("No Claude notifications")
    return
  end
  
  local current = vim.fn.system("tmux display-message -p '#{session_name}:#{window_index}'"):gsub("\n", "")
  
  fzf.fzf_exec(function(fzf_cb)
    for _, entry in ipairs(entries) do
      local session, idx = entry:match("^([^:]+):(%d+)$")
      if session and idx then
        local win_info = vim.fn.system(string.format(
          "tmux list-windows -t %s -F '#{window_index}:#{window_name}' 2>/dev/null | grep '^%s:'",
          vim.fn.shellescape(session), idx
        )):gsub("\n", "")
        
        local name = win_info:match("^%d+:(.+)$") or "unknown"
        local display = string.format("%s:%s - %s%s", session, idx, name,
          entry == current and " (current)" or "")
        fzf_cb(display)
      end
    end
    fzf_cb()
  end, {
    prompt = 'Claude Activity❯ ',
    actions = {
      ['default'] = function(selected)
        if selected and selected[1] then
          local session, idx = selected[1]:match("^([^:]+):(%d+)")
          if session and idx then
            vim.fn.system(string.format("tmux switch-client -t %s:%s",
              vim.fn.shellescape(session), idx))
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
  local code_path = vim.env.HOME .. "/code"
  local cmd = "find " .. code_path .. " -maxdepth 1 -type d -not -path " .. code_path .. 
              " -not -path '*/\\.*' | sed 's|" .. code_path .. "/||' | sort"
  
  -- Get existing sessions
  local sessions = {}
  for _, s in ipairs(vim.fn.systemlist("tmux list-sessions -F '#{session_name}' 2>/dev/null")) do
    sessions[s] = true
  end
  
  fzf.fzf_exec(function(fzf_cb)
    local dirs = vim.fn.systemlist(cmd)
    local active, inactive = {}, {}
    
    for _, dir in ipairs(dirs) do
      table.insert(sessions[dir] and active or inactive,
                   sessions[dir] and ("★ " .. dir .. " [active]") or ("  " .. dir))
    end
    
    table.sort(active)
    table.sort(inactive)
    
    for _, dir in ipairs(active) do fzf_cb(dir) end
    for _, dir in ipairs(inactive) do fzf_cb(dir) end
    fzf_cb()
  end, {
    prompt = 'Code Projects❯ ',
    actions = {
      ['default'] = function(selected)
        if selected and selected[1] then
          local project = selected[1]:gsub("^[★ ]*", ""):gsub("%s*%[active%]%s*$", "")
          if project ~= "" then
            local exists = vim.fn.system("tmux has-session -t " .. vim.fn.shellescape(project) .. 
                                        " 2>/dev/null; echo $?"):gsub("\n", "") == "0"
            if not exists then
              vim.fn.system(string.format("tmux new-session -d -s %s -c %s",
                vim.fn.shellescape(project),
                vim.fn.shellescape(code_path .. "/" .. project)))
            end
            switch_to_target(project, true)
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
