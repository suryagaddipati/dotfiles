return {
  "OXY2DEV/markview.nvim",
  lazy = true,
  -- ft = "markdown",  -- Commented out so it doesn't auto-load on markdown files
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons"
  },
  keys = {
    { "<leader>mv", "<cmd>Markview toggle<cr>", desc = "Toggle markview" },
    { "<leader>me", "<cmd>Markview enable<cr>", desc = "Enable markview" },
    { "<leader>md", "<cmd>Markview disable<cr>", desc = "Disable markview" },
  },
  config = function()
    require("markview").setup({
      initial_state = false,  -- Don't enable automatically
      preview = {
        modes = { "n", "no", "c" },
        hybrid_modes = { "n" },
        
        callbacks = {
          on_enable = function (_, win)
            vim.wo[win].conceallevel = 2;
            vim.wo[win].concealcursor = "c";
          end
        }
      }
    })
  end,
}