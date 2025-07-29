return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false,                    -- neo-tree will lazily load itself
    keys = {
      { '<leader>p', '<cmd>Neotree toggle<cr>', desc = 'Toggle neo-tree' },
    },
    config = function()
      require('neo-tree').setup({
        follow_current_file = {
          enabled = true,
        },
        filesystem = {
          use_libuv_file_watcher = true,
          follow_current_file = {
            enabled = true,
          },
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = true,
          },
        },
      })
    end,
  }
}
