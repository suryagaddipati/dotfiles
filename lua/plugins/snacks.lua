return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  keys = {
    -- Zen/Focus functionality (replaces maximizer + focus)
    { '<leader>z', function() Snacks.zen.zoom() end, desc = 'Toggle maximize split' },
    -- Git browse - copy GitHub/GHE link for current line
    { '<leader>gB', function() 
        -- Auto-detect GitHub Enterprise or regular GitHub from remote URL
        Snacks.gitbrowse({ 
          notify = true,
          -- This will work with both github.com and ghe.spotify.net
        }) 
      end, 
      desc = 'Copy GitHub/GHE link', 
      mode = { 'n', 'v' } 
    },
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
    gitbrowse = { 
      enabled = true,
      -- Support for GitHub Enterprise (ghe.spotify.net) and regular GitHub
      -- Snacks will auto-detect from git remote URL
      remote_patterns = {
        { "^git@(.+):(.+)/(.+)%.git$", "https://%1/%2/%3" },
        { "^https?://(.+)/(.+)/(.+)%.git$", "https://%1/%2/%3" },
        { "^git@(.+):(.+)/(.+)$", "https://%1/%2/%3" },
        { "^https?://(.+)/(.+)/(.+)$", "https://%1/%2/%3" },
      },
    },
  },
}