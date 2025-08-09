return {
  'rmagatti/auto-session',
  opts = {
    auto_save = true,
    auto_restore = true,
    auto_save_enabled = true,
    auto_restore_enabled = true,
    suppressed_dirs = { '~/', '~/Downloads', '/', '/tmp' },
    bypass_save_filetypes = { 'neo-tree', 'undotree', 'diffview', 'qf', 'help' },
    log_level = 'error',
    
    use_git_branch = false,
    
    session_lens = {
      load_on_setup = false,
      previewer = false,
    },
    
    pre_save_cmds = {
      function()
        vim.g.neo_tree_was_open = false
        for _, win in pairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
          if ft == 'neo-tree' then
            vim.g.neo_tree_was_open = true
            vim.cmd('Neotree close')
            break
          end
        end
      end
    },
    
    post_restore_cmds = {
      function()
        if vim.g.neo_tree_was_open then
          vim.cmd('Neotree show')
        end
      end
    },
  },
  
  config = function(_, opts)
    vim.o.sessionoptions = 'buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions,globals'
    
    require('auto-session').setup(opts)
    
    vim.keymap.set('n', '<leader>ss', '<cmd>SessionSave<cr>', { desc = 'Save session' })
    vim.keymap.set('n', '<leader>sr', '<cmd>SessionRestore<cr>', { desc = 'Restore session' })
    vim.keymap.set('n', '<leader>sd', '<cmd>SessionDelete<cr>', { desc = 'Delete session' })
    vim.keymap.set('n', '<leader>sf', '<cmd>Autosession search<cr>', { desc = 'Find session' })
  end,
}