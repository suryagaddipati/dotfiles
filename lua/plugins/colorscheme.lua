return {
  'morhetz/gruvbox',
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.gruvbox_contrast_dark = 'hard'
    vim.g.gruvbox_bold = 1
    vim.cmd.colorscheme('gruvbox')
    
    -- Configure window focus highlighting
    vim.api.nvim_set_hl(0, 'NormalNC', { bg = '#1d2021', fg = '#928374' })
    vim.api.nvim_set_hl(0, 'Normal', { bg = '#282828', fg = '#ebdbb2' })
    vim.api.nvim_set_hl(0, 'VertSplit', { fg = '#504945', bg = '#1d2021' })
    vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#83a598', bg = 'NONE' })
    
    -- Make focused window border more prominent
    vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#83a598', bg = 'NONE' })
  end,
}