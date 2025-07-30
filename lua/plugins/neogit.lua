return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'sindrets/diffview.nvim',
    'nvim-telescope/telescope.nvim',
    'lewis6991/gitsigns.nvim',
  },
  cmd = 'Neogit',
  keys = {
    { '<leader>gG', '<cmd>Neogit<cr>', desc = 'Open Neogit' },
  },
  config = function()
    require('neogit').setup({
      integrations = {
        telescope = true,
        diffview = true,
      },
      -- Use diffview for diffs instead of built-in
      use_default_keymaps = true,
      disable_hint = false,
      auto_refresh = true,
      sort_branches = '-committerdate',
      kind = 'tab',
    })
  end,
}