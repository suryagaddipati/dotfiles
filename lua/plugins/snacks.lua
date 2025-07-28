return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  keys = {
    -- Picker functionality (replaces telescope)
    { '<leader>e', function() Snacks.picker.grep() end, desc = 'Live grep' },
    { '<leader>f', function() Snacks.picker.files() end, desc = 'Find files' },
    { '<leader>b', function() Snacks.picker.buffers() end, desc = 'Buffers' },
    { '<leader>hr', function() Snacks.picker.recent() end, desc = 'Recent files' },
    { '<leader>r', function() Snacks.picker.registers() end, desc = 'Registers' },
    { '<leader>:', function() Snacks.picker.command_history() end, desc = 'Command history' },
    { '<leader>;', function() Snacks.picker.commands() end, desc = 'Commands' },
    
    -- Zen/Focus functionality (replaces maximizer + focus)
    { '<leader>z', function() Snacks.zen.zoom() end, desc = 'Toggle maximize split' },
  },
  opts = {
    -- Picker configuration
    picker = {
      sources = {
        files = { hidden = true },
        grep = { hidden = true },
      },
      win = {
        input = {
          keys = {
            ['<C-u>'] = { 'scroll_up', mode = { 'i', 'n' } },
            ['<C-d>'] = { 'scroll_down', mode = { 'i', 'n' } },
          },
        },
      },
    },
    
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