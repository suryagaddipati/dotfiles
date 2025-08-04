return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  keys = {
    -- Zen/Focus functionality (replaces maximizer + focus)
    { '<leader>z', function() Snacks.zen.zoom() end, desc = 'Toggle maximize split' },
  },
  opts = {
    -- Zen mode configuration
    zen = {
      toggles = {
        git_signs = true,
        mini_diff_signs = true,
        diagnostics = true,
        inlay_hints = true,
      },
      zoom = {
        toggles = {
          git_signs = false,
          mini_diff_signs = false,
          diagnostics = false,
          inlay_hints = false,
        },
      },
    },
    
    -- Enable additional snacks modules
    bigfile = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    terminal = { enabled = true },
    words = { enabled = true },
  },
}