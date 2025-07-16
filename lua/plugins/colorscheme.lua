return {
  'morhetz/gruvbox',
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.gruvbox_contrast_dark = 'hard'
    vim.g.gruvbox_bold = 1
    vim.cmd.colorscheme('gruvbox')
  end,
}