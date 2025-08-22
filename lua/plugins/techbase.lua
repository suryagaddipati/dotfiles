return {
  'mcauley-penney/techbase.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('techbase').setup({
      -- Available options:
      -- style = 'dark' or 'light' 
      -- transparent = true or false
      -- To use the theme, uncomment the following line:
      -- vim.cmd.colorscheme('techbase')
    })
  end,
}