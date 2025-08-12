return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    -- File operations
    { '<leader>o', function()
        -- Use git_files if in a git repo, otherwise files
        local ok = pcall(require('fzf-lua').git_files, {
          show_untracked = true,
          -- This ensures we show both tracked and untracked files
          cmd = 'git ls-files --cached --others --exclude-standard'
        })
        if not ok then
          require('fzf-lua').files()
        end
      end, desc = 'Find files' },
    { '<leader>e', function() require('fzf-lua').live_grep() end, desc = 'Live grep' },
    { '<leader>b', function() require('fzf-lua').buffers() end, desc = 'Buffers' },
    { '<leader>hr', function() require('fzf-lua').oldfiles() end, desc = 'Recent files' },

    -- LSP integration (avoiding conflicts with existing LSP keybindings)
    { '<leader>fD', function() require('fzf-lua').lsp_definitions() end, desc = 'LSP definitions (fzf)' },
    { '<leader>fR', function() require('fzf-lua').lsp_references() end, desc = 'LSP references (fzf)' },
    { '<leader>fy', function() require('fzf-lua').lsp_document_symbols() end, desc = 'Document symbols' },
    { '<leader>fY', function() require('fzf-lua').lsp_workspace_symbols() end, desc = 'Workspace symbols' },
    { '<leader>fd', function() require('fzf-lua').lsp_document_diagnostics() end, desc = 'Document diagnostics' },
    { '<leader>fA', function() require('fzf-lua').lsp_workspace_diagnostics() end, desc = 'Workspace diagnostics' },

    -- Utility functions
    { '<leader>r', function() require('fzf-lua').registers() end, desc = 'Registers' },
    { '<leader>:', function() require('fzf-lua').command_history() end, desc = 'Command history' },
    { '<leader>;', function() require('fzf-lua').commands() end, desc = 'Commands' },
    { '<leader>/', function() require('fzf-lua').blines() end, desc = 'Search in buffer' },
    { '<leader>?', function() require('fzf-lua').grep_curbuf() end, desc = 'Grep current buffer' },
    { '<leader>k', function() require('fzf-lua').keymaps() end, desc = 'Keymaps' },
    { '<leader>ht', function() require('fzf-lua').help_tags() end, desc = 'Help tags' },

    -- Enhanced search functions matching your bash fzf functions
    { '<leader>fp', function() require('fzf-lua').grep_project() end, desc = 'Grep project' },
    { '<leader>fw', function() require('fzf-lua').grep_cword() end, desc = 'Grep word under cursor' },
    { '<leader>fW', function() require('fzf-lua').grep_cWORD() end, desc = 'Grep WORD under cursor' },
    
    -- Tmux integration pickers
    { '<leader>tw', function()
        -- Tmux window picker for current session
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
      end, desc = 'Tmux windows (current session)' },
    
    { '<leader>ts', function()
        -- Tmux session picker
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
      end, desc = 'Tmux sessions' },
  },
  opts = {
    -- Global settings
    global_resume = true,
    global_resume_query = true,

    -- Use the same fzf binary as your bash setup
    fzf_bin = 'fzf',

    -- Match your bash FZF_DEFAULT_OPTS
    fzf_opts = {
      ['--height'] = '40%',
      ['--layout'] = 'reverse',
      ['--border'] = 'rounded',
      ['--multi'] = '',
      ['--info'] = 'inline',
      ['--cycle'] = '',
    },

    -- Window configuration
    winopts = {
      height = 0.85,
      width = 0.80,
      row = 0.35,
      col = 0.50,
      border = 'rounded',
      preview = {
        hidden = 'hidden',  -- Disable all previews
      },
    },

    -- Files configuration - ONLY use git ls-files
    files = {
      prompt = 'Files❯ ',
      multiprocess = false,  -- Disable multiprocess to ensure our cmd is used
      file_icons = true,
      color_icons = true,
      git_icons = true,
      -- Force ONLY git ls-files, no fallbacks
      cmd = 'git ls-files --cached --others --exclude-standard',
    },

    -- Grep configuration
    grep = {
      prompt = 'Grep❯ ',
      input_prompt = 'Grep For❯ ',
      multiprocess = true,
      file_icons = true,
      color_icons = true,
      git_icons = true,
      rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
      grep_opts = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp -e",
    },

    -- Buffer configuration
    buffers = {
      prompt = 'Buffers❯ ',
      file_icons = true,
      color_icons = true,
      sort_lastused = true,
      show_unloaded = true,
    },

    -- Git configuration
    git = {
      files = {
        prompt = 'GitFiles❯ ',
        cmd = 'git ls-files --cached --others --exclude-standard',
        show_untracked = true,
        multiprocess = true,
        file_icons = true,
        color_icons = true,
        git_icons = true,
      },
      status = {
        prompt = 'GitStatus❯ ',
        cmd = "git status --porcelain=v1",
        file_icons = true,
        color_icons = true,
        git_icons = true,
      },
      commits = {
        prompt = 'Commits❯ ',
        cmd = "git log --color=always --pretty=format:'%C(yellow)%h%C(red)%d%C(reset) - %C(bold green)(%cr)%C(reset) %s %C(blue)<%an>%C(reset)'",
      },
      branches = {
        prompt = 'Branches❯ ',
        cmd = "git branch --all --color=always",
      },
    },

    -- LSP configuration
    lsp = {
      prompt_postfix = '❯ ',
      cwd_only = false,
      async_or_timeout = 5000,
      file_icons = true,
      color_icons = true,
      git_icons = false,
      symbols = {
        async_or_timeout = true,
        symbol_style = 1,
        symbol_icons = {
          File = "󰈙",
          Module = "",
          Namespace = "󰌗",
          Package = "",
          Class = "󰌗",
          Method = "󰆧",
          Property = "",
          Field = "",
          Constructor = "",
          Enum = "󰕘",
          Interface = "󰕘",
          Function = "󰊕",
          Variable = "󰆧",
          Constant = "󰏿",
          String = "󰀬",
          Number = "󰎠",
          Boolean = "◩",
          Array = "󰅪",
          Object = "󰅩",
          Key = "󰌋",
          Null = "󰟢",
          EnumMember = "",
          Struct = "󰌗",
          Event = "",
          Operator = "󰆕",
          TypeParameter = "󰊄",
        },
      },
    },

    -- Colorscheme integration (match your gruvbox theme)
    defaults = {
      file_icons = true,
      color_icons = true,
      git_icons = true,
    },
  },
}
