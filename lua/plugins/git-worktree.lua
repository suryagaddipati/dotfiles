return {
  'ThePrimeagen/git-worktree.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('git-worktree').setup({
      change_directory_command = 'cd',
      update_on_change = true,
      update_on_change_command = 'e .',
      clearjumps_on_change = true,
      confirm_telescope_deletions = true,
      worktree_path = function()
        local git_root = vim.fn.system('git rev-parse --show-toplevel'):gsub('\n', '')
        local repo_name = vim.fn.fnamemodify(git_root, ':t')
        return vim.fn.expand('~/code/worktrees/' .. repo_name)
      end,
    })

    -- Load telescope extension
    require('telescope').load_extension('git_worktree')
  end,
  keys = {
    {
      '<leader>gwc',
      function()
        require('telescope').extensions.git_worktree.create_git_worktree()
      end,
    },
    {
      '<leader>gws',
      function()
        require('telescope').extensions.git_worktree.git_worktrees()
      end,
      desc = 'Switch Git Worktree',
    },
  },
}
