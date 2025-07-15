vim.g.mapleader = ' '
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300
vim.opt.lazyredraw = true
vim.opt.synmaxcol = 200
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wrap = false
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.autoread = true
vim.opt.hidden = true
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false

vim.keymap.set('n', '<leader>w', '<cmd>w<cr>')
vim.keymap.set('n', '<leader>q', '<cmd>q<cr>')
vim.keymap.set('n', '<leader>x', '<cmd>x<cr>')
vim.keymap.set('n', '<leader>/', '<cmd>noh<cr>')
vim.keymap.set('n', '<leader>h', '<cmd>noh<cr>')

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

vim.keymap.set('n', '<Tab>', '<cmd>bnext<cr>')
vim.keymap.set('n', '<S-Tab>', '<cmd>bprev<cr>')
vim.keymap.set('n', '<leader>bd', '<cmd>bd<cr>')

vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

vim.keymap.set('n', '<leader>m', function()
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

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'morhetz/gruvbox',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_contrast_dark = 'hard'
      vim.g.gruvbox_bold = 1
      vim.cmd.colorscheme('gruvbox')
    end,
  },

  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>f', '<cmd>Telescope find_files<cr>', desc = 'Find files' },
      { '<leader>g', '<cmd>Telescope live_grep<cr>', desc = 'Grep' },
      { '<leader>b', '<cmd>Telescope buffers<cr>', desc = 'Buffers' },
      { '<leader>hr', '<cmd>Telescope oldfiles<cr>', desc = 'Recent files' },
    },
    config = function()
      require('telescope').setup({
        defaults = {
          layout_strategy = 'horizontal',
          layout_config = { prompt_position = 'top' },
          sorting_strategy = 'ascending',
          winblend = 0,
        },
      })
    end,
  },

  {
    'nvim-tree/nvim-tree.lua',
    cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
    keys = {
      { '<leader>e', '<cmd>NvimTreeToggle<cr>', desc = 'Toggle tree' },
    },
    config = function()
      require('nvim-tree').setup({
        hijack_netrw = true,
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
        git = { enable = true },
      })
    end,
  },

  {
    'neovim/nvim-lspconfig',
    version = 'v0.1.7',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
      })

      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, silent = true }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
      end

      local servers = { 'lua_ls', 'pyright', 'tsserver' }
      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup({
          on_attach = on_attach,
          capabilities = capabilities,
          settings = lsp == 'lua_ls' and {
            Lua = {
              diagnostics = { globals = {'vim'} }
            }
          } or nil,
        })
      end
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { 'lua', 'python', 'javascript', 'typescript', 'bash', 'json', 'yaml' },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup({})
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('gitsigns').setup({
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '-' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      })
    end,
  },

  {
    'numToStr/Comment.nvim',
    keys = {
      { 'gcc', mode = 'n' },
      { 'gc', mode = 'v' },
    },
    config = function()
      require('Comment').setup()
    end,
  },

  {
    'tpope/vim-surround',
    event = 'VeryLazy',
  },

  {
    'akinsho/toggleterm.nvim',
    version = '*',
    cmd = { 'ToggleTerm', 'TermExec' },
    keys = {
      { '<C-\\>', '<cmd>ToggleTerm<cr>', desc = 'Toggle terminal' },
      { '<leader>tt', '<cmd>ToggleTerm<cr>', desc = 'Toggle terminal' },
      { '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', desc = 'Float terminal' },
      { '<leader>th', '<cmd>ToggleTerm direction=horizontal<cr>', desc = 'Horizontal terminal' },
      { '<leader>tv', '<cmd>ToggleTerm direction=vertical<cr>', desc = 'Vertical terminal' },
    },
    config = function()
      require('toggleterm').setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<C-\>]],
        hide_numbers = true,
        shade_terminals = true,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        direction = 'float',
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = 'curved',
          winblend = 0,
        },
        winbar = {
          enabled = false,
        },
      })

      function _G.set_terminal_keymaps()
        local opts = {buffer = 0}
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
      end

      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end,
  },

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('which-key').setup({
        preset = 'modern',
        delay = 300,
      })
    end,
  },

  {
    dir = '/home/surya/code/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    config = function()
      require('claudecode').setup({
      opts = {
        terminal = {
          provider = "native",
        }},

        diff = {
          unique_buffers = true,
          cleanup_on_exit = true,
        },
        claude_command = 'claude',
        mouse = false,
      })
    end,
    cmd = { 'ClaudeCode', 'ClaudeCodeFocus', 'ClaudeCodeAdd', 'ClaudeCodeSend', 'ClaudeCodeTreeAdd', 'ClaudeCodeDiffAccept', 'ClaudeCodeDiffDeny' },
    keys = {
      { '<leader>a', nil, desc = 'AI/Claude Code' },
      { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
      { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
      { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
      { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
      { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
      { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
      {
        '<leader>at',
        '<cmd>ClaudeCodeTreeAdd<cr>',
        desc = 'Add file',
        ft = { 'NvimTree', 'neo-tree', 'oil' },
      },
      { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
      { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
    },
  },
}, {
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})

local augroup = vim.api.nvim_create_augroup('NinjaConfig', {})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup,
  pattern = '*',
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 1 and line <= vim.fn.line("$") then
      vim.api.nvim_win_set_cursor(0, {line, 0})
    end
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = augroup,
  pattern = '*',
  command = '%s/\\s\\+$//e',
})

vim.api.nvim_create_autocmd('FileType', {
  group = augroup,
  pattern = 'python',
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})
