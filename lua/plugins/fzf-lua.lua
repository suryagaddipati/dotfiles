return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    -- File operations
    { '<leader>f', function() require('fzf-lua').files() end, desc = 'Find files' },
    { '<leader>e', function() require('fzf-lua').live_grep() end, desc = 'Live grep' },
    { '<leader>b', function() require('fzf-lua').buffers() end, desc = 'Buffers' },
    { '<leader>hr', function() require('fzf-lua').oldfiles() end, desc = 'Recent files' },
    
    -- Git integration
    { '<leader>gf', function() require('fzf-lua').git_files() end, desc = 'Git files' },
    { '<leader>gs', function() require('fzf-lua').git_status() end, desc = 'Git status' },
    { '<leader>gl', function() require('fzf-lua').git_commits() end, desc = 'Git log' },
    { '<leader>gb', function() require('fzf-lua').git_branches() end, desc = 'Git branches' },
    
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
        default = 'bat',
        border = 'border',
        wrap = 'nowrap',
        hidden = 'nohidden',
        vertical = 'down:45%',
        horizontal = 'right:50%',
        layout = 'flex',
        flip_columns = 120,
        scrollbar = 'float',
      },
    },
    
    -- Files configuration
    files = {
      prompt = 'Files❯ ',
      multiprocess = true,
      file_icons = true,
      color_icons = true,
      git_icons = true,
      -- Use same command as your bash FZF_DEFAULT_COMMAND
      cmd = 'git ls-files --cached --others --exclude-standard 2>/dev/null || find . -type f -not -path "*/\\.git/*" 2>/dev/null',
      find_opts = [[-type f -not -path "*/\\.git/*" -printf "%P\n"]],
      rg_opts = "--color=never --files --hidden --follow -g '!.git'",
      fd_opts = "--color=never --type f --hidden --follow --exclude .git",
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
        cmd = 'git ls-files --exclude-standard',
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
        preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
      },
      commits = {
        prompt = 'Commits❯ ',
        cmd = "git log --color=always --pretty=format:'%C(yellow)%h%C(red)%d%C(reset) - %C(bold green)(%cr)%C(reset) %s %C(blue)<%an>%C(reset)'",
        preview = "git show --color=always {1}",
        preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
      },
      branches = {
        prompt = 'Branches❯ ',
        cmd = "git branch --all --color=always",
        preview = "git log --oneline --graph --date=short --color=always --pretty='format:%C(auto)%cd %h%d %s' {1}",
        preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
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