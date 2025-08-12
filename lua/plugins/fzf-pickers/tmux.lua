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

return M