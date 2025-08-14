return {
  'akinsho/toggleterm.nvim',
  version = '*',
  lazy=false,
  keys = {
    { '<C-\\>', '<cmd>ToggleTerm<cr>', desc = 'Toggle terminal' },
    { '<leader>tt', '<cmd>1ToggleTerm direction=float<cr>', desc = 'Toggle terminal' },
    { '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', desc = 'Float terminal' },
    { '<leader>th', '<cmd>ToggleTerm direction=horizontal<cr>', desc = 'Horizontal terminal' },
    { '<leader>tv', '<cmd>ToggleTerm direction=vertical<cr>', desc = 'Vertical terminal' },
    { '<leader>t1', '<cmd>1ToggleTerm<cr>', desc = 'Terminal 1' },
    { '<leader>t2', '<cmd>2ToggleTerm<cr>', desc = 'Terminal 2' },
    { '<leader>t3', '<cmd>3ToggleTerm<cr>', desc = 'Terminal 3' },
    { '<leader>t4', '<cmd>4ToggleTerm<cr>', desc = 'Terminal 4' },
    { '<leader>t5', '<cmd>5ToggleTerm<cr>', desc = 'Terminal 5' },
    { '<leader>t6', '<cmd>6ToggleTerm<cr>', desc = 'Terminal 6' },
    { '<leader>t7', '<cmd>7ToggleTerm<cr>', desc = 'Terminal 7' },
    { '<leader>t8', '<cmd>8ToggleTerm<cr>', desc = 'Terminal 8' },
    { '<leader>t9', '<cmd>9ToggleTerm<cr>', desc = 'Terminal 9' },
    { '<leader>tz', '<cmd>1ToggleTerm direction=tab<cr>', desc = 'Terminal 1 maximized' },
  },
  config = function()
    require('toggleterm').setup({
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<C-\>]],
      hide_numbers = true,
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      direction = 'float',
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = 'curved',
        winblend = 0,
      },
      winbar = {
        enabled = false,
      },
    })

    function _G.set_terminal_keymaps()
      local opts = {buffer = 0}
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
    end

    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
  end,
}
