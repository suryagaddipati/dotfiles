return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { '<leader>p', '<cmd>NvimTreeToggle<cr>', desc = 'Toggle nvim-tree' },
  },
  config = function()
    require("nvim-tree").setup({
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      view = {
        width = 30,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
        git_ignored = true,
        custom = { "^.git$" },
      },
    })
  end,
}
