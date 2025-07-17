return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = { 'BufReadPost', 'BufNewFile', 'BufWinEnter' },
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = { 'lua', 'python', 'javascript', 'typescript', 'bash', 'json', 'yaml' },
      auto_install = true,
      highlight = { 
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    })
  end,
}