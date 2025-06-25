-- =============================================================================
-- Neovim Configuration File (init.lua)
-- =============================================================================

-- Essential Settings
-- =============================================================================
vim.opt.compatible = false              -- Disable vi compatibility
vim.cmd('syntax enable')                -- Enable syntax highlighting
vim.cmd('filetype plugin indent on')   -- Enable file type detection and plugins

-- Display and Interface
-- =============================================================================
vim.opt.number = true                   -- Show line numbers
vim.opt.relativenumber = true          -- Show relative line numbers
vim.opt.ruler = true                    -- Show cursor position
vim.opt.showcmd = true                  -- Show command in status line
vim.opt.showmatch = true                -- Highlight matching brackets
vim.opt.cursorline = true               -- Highlight current line
vim.opt.wildmenu = true                 -- Enhanced command completion
vim.opt.wildmode = {'longest:full', 'full'} -- Command completion behavior
vim.opt.laststatus = 2                  -- Always show status line
vim.opt.title = true                    -- Set terminal title

-- Colors and Theme
-- =============================================================================
vim.opt.background = 'dark'             -- Use dark background
vim.opt.termguicolors = true            -- Enable 24-bit RGB colors

-- Search Settings
-- =============================================================================
vim.opt.hlsearch = true                 -- Highlight search results
vim.opt.incsearch = true                -- Incremental search
vim.opt.ignorecase = true               -- Case insensitive search
vim.opt.smartcase = true                -- Case sensitive if uppercase used

-- Indentation and Formatting
-- =============================================================================
vim.opt.autoindent = true               -- Auto indent new lines
vim.opt.smartindent = true              -- Smart indentation
vim.opt.expandtab = true                -- Use spaces instead of tabs
vim.opt.tabstop = 4                     -- Tab width
vim.opt.shiftwidth = 4                  -- Indent width
vim.opt.softtabstop = 4                 -- Soft tab width
vim.opt.textwidth = 80                  -- Line width
vim.opt.wrap = true                     -- Wrap long lines

-- File Handling
-- =============================================================================
vim.opt.autoread = true                 -- Auto reload changed files
vim.opt.hidden = true                   -- Allow hidden buffers
vim.opt.encoding = 'utf-8'              -- Use UTF-8 encoding
vim.opt.fileencoding = 'utf-8'          -- File encoding
vim.opt.backspace = {'indent', 'eol', 'start'} -- Better backspace behavior

-- Auto reload files when changed on disk
local reload_group = vim.api.nvim_create_augroup('AutoReload', { clear = true })
vim.api.nvim_create_autocmd({'FocusGained', 'BufEnter'}, {
  group = reload_group,
  pattern = '*',
  command = 'silent! checktime'
})

-- Backup and Undo
-- =============================================================================
vim.opt.backup = true                   -- Enable backups
vim.opt.backupdir = vim.fn.expand('~/.config/nvim/backup//')
vim.opt.directory = vim.fn.expand('~/.config/nvim/swap//')
vim.opt.undofile = true                 -- Persistent undo
vim.opt.undodir = vim.fn.expand('~/.config/nvim/undo//')

-- Create directories if they don't exist
local function ensure_dir(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, 'p')
  end
end

ensure_dir(vim.fn.expand('~/.config/nvim/backup'))
ensure_dir(vim.fn.expand('~/.config/nvim/swap'))
ensure_dir(vim.fn.expand('~/.config/nvim/undo'))

-- Performance
-- =============================================================================
vim.opt.lazyredraw = true               -- Don't redraw during macros
vim.opt.synmaxcol = 200                 -- Limit syntax highlighting for long lines
vim.opt.updatetime = 300                -- Faster completion

-- Mouse and Clipboard
-- =============================================================================
vim.opt.mouse = 'a'                     -- Enable mouse in all modes
vim.opt.clipboard = 'unnamedplus'       -- Use system clipboard (Linux)

-- Key Mappings and Leader
-- =============================================================================
vim.g.mapleader = ','                   -- Set leader key to comma

-- Quick save and quit
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Quit' })
vim.keymap.set('n', '<leader>x', ':x<CR>', { desc = 'Save and quit' })
vim.keymap.set('n', '<leader>Q', ':q!<CR>', { desc = 'Force quit' })

-- Clear search highlighting
vim.keymap.set('n', '<leader>/', ':nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Toggle features
vim.keymap.set('n', '<leader>n', ':set number!<CR>', { desc = 'Toggle line numbers' })
vim.keymap.set('n', '<leader>r', ':set relativenumber!<CR>', { desc = 'Toggle relative numbers' })
vim.keymap.set('n', '<leader>p', ':set paste!<CR>', { desc = 'Toggle paste mode' })

-- Better window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to bottom window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to top window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Resize windows
vim.keymap.set('n', '<leader>+', ':resize +5<CR>', { desc = 'Increase height' })
vim.keymap.set('n', '<leader>-', ':resize -5<CR>', { desc = 'Decrease height' })
vim.keymap.set('n', '<leader>>', ':vertical resize +5<CR>', { desc = 'Increase width' })
vim.keymap.set('n', '<leader><', ':vertical resize -5<CR>', { desc = 'Decrease width' })

-- Buffer navigation
vim.keymap.set('n', '<leader>b', ':buffers<CR>', { desc = 'List buffers' })
vim.keymap.set('n', '<leader>bn', ':bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bp', ':bprev<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = 'Delete buffer' })

-- Quick editing of init.lua
vim.keymap.set('n', '<leader>ev', ':edit ~/.config/nvim/init.lua<CR>', { desc = 'Edit nvim config' })
vim.keymap.set('n', '<leader>sv', ':source ~/.config/nvim/init.lua<CR>', { desc = 'Source nvim config' })

-- Better line movement
vim.keymap.set('n', 'j', 'gj', { desc = 'Move down visual line' })
vim.keymap.set('n', 'k', 'gk', { desc = 'Move up visual line' })

-- Easier indentation
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and reselect' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- Center search results
vim.keymap.set('n', 'n', 'nzz', { desc = 'Next search result (centered)' })
vim.keymap.set('n', 'N', 'Nzz', { desc = 'Previous search result (centered)' })

-- File explorer (using netrw as fallback)
vim.keymap.set('n', '<leader>e', ':Explore<CR>', { desc = 'File explorer' })

-- Developer Features
-- =============================================================================

-- Auto-pairs for brackets and quotes
vim.keymap.set('i', '"', '""<left>', { desc = 'Auto-close double quotes' })
vim.keymap.set('i', "'", "''<left>", { desc = 'Auto-close single quotes' })
vim.keymap.set('i', '(', '()<left>', { desc = 'Auto-close parentheses' })
vim.keymap.set('i', '[', '[]<left>', { desc = 'Auto-close brackets' })
vim.keymap.set('i', '{', '{}<left>', { desc = 'Auto-close braces' })
vim.keymap.set('i', '{<CR>', '{<CR>}<ESC>O', { desc = 'Auto-close braces with newline' })

-- Show whitespace characters
vim.opt.list = true
vim.opt.listchars = {
  tab = '▸ ',
  trail = '·',
  extends = '❯',
  precedes = '❮',
  nbsp = '×'
}

-- Auto commands
local nvim_group = vim.api.nvim_create_augroup('NvimConfig', { clear = true })

-- Return to last cursor position when opening files
vim.api.nvim_create_autocmd('BufReadPost', {
  group = nvim_group,
  pattern = '*',
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 1 and line <= vim.fn.line("$") then
      vim.api.nvim_win_set_cursor(0, {line, 0})
    end
  end
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  group = nvim_group,
  pattern = '*',
  command = '%s/\\s\\+$//e'
})

-- Auto-reload init.lua when saved
vim.api.nvim_create_autocmd('BufWritePost', {
  group = nvim_group,
  pattern = 'init.lua',
  command = 'source %'
})

-- Programming language specific settings
local prog_group = vim.api.nvim_create_augroup('ProgLang', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  group = prog_group,
  pattern = 'python',
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end
})

vim.api.nvim_create_autocmd('FileType', {
  group = prog_group,
  pattern = {'javascript', 'typescript', 'json'},
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end
})

vim.api.nvim_create_autocmd('FileType', {
  group = prog_group,
  pattern = {'html', 'css', 'scss'},
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end
})

vim.api.nvim_create_autocmd('FileType', {
  group = prog_group,
  pattern = 'go',
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = false
  end
})

vim.api.nvim_create_autocmd('FileType', {
  group = prog_group,
  pattern = 'yaml',
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end
})

-- Folding
vim.opt.foldmethod = 'indent'
vim.opt.foldlevel = 99
vim.keymap.set('n', '<space>', 'za', { desc = 'Toggle fold' })

-- Quick fix and location list
vim.keymap.set('n', '<leader>co', ':copen<CR>', { desc = 'Open quickfix' })
vim.keymap.set('n', '<leader>cc', ':cclose<CR>', { desc = 'Close quickfix' })
vim.keymap.set('n', '<leader>cn', ':cnext<CR>', { desc = 'Next quickfix' })
vim.keymap.set('n', '<leader>cp', ':cprev<CR>', { desc = 'Previous quickfix' })

-- Plugin Management with lazy.nvim
-- =============================================================================

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specifications
local plugins = {
  -- Essential plugins
  'tpope/vim-sensible',
  'tpope/vim-surround',
  'tpope/vim-commentary',
  'tpope/vim-fugitive',

  -- File management and fuzzy finding
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require('telescope')
      local builtin = require('telescope.builtin')
      
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ['<C-h>'] = 'which_key'
            }
          }
        },
        pickers = {
          find_files = {
            theme = 'dropdown'
          }
        }
      })
      
      -- Telescope key mappings
      vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>F', builtin.git_files, { desc = 'Find git files' })
      vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>l', builtin.current_buffer_fuzzy_find, { desc = 'Search current buffer' })
      vim.keymap.set('n', '<leader>h', builtin.oldfiles, { desc = 'Recent files' })
      vim.keymap.set('n', '<leader>hf', builtin.command_history, { desc = 'Command history' })
      vim.keymap.set('n', '<leader>hs', builtin.search_history, { desc = 'Search history' })
      vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Find buffers' })
    end
  },

  -- File tree explorer
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup({
        sort_by = 'case_sensitive',
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
          icons = {
            git_placement = 'after',
          },
        },
        filters = {
          dotfiles = false,
        },
        git = {
          enable = true,
          ignore = false,
        },
        actions = {
          open_file = {
            quit_on_open = false,
          },
        },
      })
      
      -- NvimTree key mappings
      vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<CR>', { desc = 'Toggle file tree' })
      vim.keymap.set('n', '<leader>nf', ':NvimTreeFindFile<CR>', { desc = 'Find current file in tree' })
    end
  },

  -- Language support and syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { 'lua', 'python', 'javascript', 'typescript', 'html', 'css', 'json', 'yaml', 'bash' },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true
        },
      })
    end
  },

  -- LSP and completion
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      -- Setup completion
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        })
      })
      
      -- Setup LSP
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      
      -- Python
      lspconfig.pylsp.setup({
        capabilities = capabilities,
      })
      
      -- JavaScript/TypeScript
      lspconfig.tsserver.setup({
        capabilities = capabilities,
      })
      
      -- Lua
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = {'vim'}
            }
          }
        }
      })
    end
  },

  -- Appearance and themes
  {
    'morhetz/gruvbox',
    config = function()
      vim.cmd('colorscheme gruvbox')
    end
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'gruvbox'
        }
      })
    end
  },

  -- Auto-pairs and productivity
  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({})
    end
  },

  -- Git integration
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  },

  -- Dashboard
  {
    'goolord/alpha-nvim',
    config = function()
      local alpha = require('alpha')
      local dashboard = require('alpha.themes.dashboard')
      
      dashboard.section.header.val = {
        '                                   ',
        '   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ',
        '    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ',
        '          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ',
        '           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ',
        '          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ',
        '   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ',
        '  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ',
        ' ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ',
        ' ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ',
        '      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ',
        '       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ',
        '                                   ',
      }
      
      dashboard.section.buttons.val = {
        dashboard.button('f', '  Find file', ':Telescope find_files <CR>'),
        dashboard.button('e', '  New file', ':ene <BAR> startinsert <CR>'),
        dashboard.button('r', '  Recently used files', ':Telescope oldfiles <CR>'),
        dashboard.button('t', '  Find text', ':Telescope live_grep <CR>'),
        dashboard.button('c', '  Configuration', ':e ~/.config/nvim/init.lua <CR>'),
        dashboard.button('q', '  Quit Neovim', ':qa<CR>'),
      }
      
      alpha.setup(dashboard.opts)
    end
  },
}

-- Setup lazy.nvim
require('lazy').setup(plugins)

-- Additional mappings and settings
-- =============================================================================

-- Quick file creation
vim.keymap.set('n', '<leader>nf', ':e <C-R>=expand("%:p:h") . "/" <CR>', { desc = 'New file in current dir' })

-- Tab management
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = 'New tab' })
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { desc = 'Close tab' })
vim.keymap.set('n', '<leader>to', ':tabonly<CR>', { desc = 'Close other tabs' })
vim.keymap.set('n', '<leader>tm', ':tabmove<Space>', { desc = 'Move tab' })

-- Quick buffer switching
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>', ':bprev<CR>', { desc = 'Previous buffer' })

-- Close buffer without closing window
vim.keymap.set('n', '<leader>bd', ':bp|bd #<CR>', { desc = 'Delete buffer (keep window)' })

-- Find and replace in project
vim.keymap.set('n', '<leader>S', ':%s/\\<<C-r><C-w>\\>/', { desc = 'Find and replace word under cursor' })