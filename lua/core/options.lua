vim.g.mapleader = ' '

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = true

-- Enhanced search visual feedback
vim.opt.shortmess:append('c')  -- Don't show completion messages
vim.opt.showmatch = true       -- Show matching brackets
vim.opt.matchtime = 2          -- Blink time for matching brackets

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.lazyredraw = true
vim.opt.synmaxcol = 200

vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wrap = false

-- Enhanced cursor styling and visual feedback
vim.opt.cursorline = false
vim.opt.cursorcolumn = false
vim.opt.guicursor = {
  'n-v-c:block',
  'i-ci-ve:ver25',
  'r-cr:hor20',
  'o:hor50',
  'a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor',
  'sm:block-blinkwait175-blinkoff150-blinkon175',
}

-- Better visual feedback
vim.opt.laststatus = 2  -- Always show status line
vim.opt.showcmd = true
vim.opt.showmode = false  -- Status line will show mode

-- Custom statusline with file path
vim.opt.statusline = '%f %m%r%h%w%=%l,%c %p%%'

vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.autoread = true
vim.opt.hidden = true

vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.syntax = 'on'
vim.opt.filetype = 'on'

