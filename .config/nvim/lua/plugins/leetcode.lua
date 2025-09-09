return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",

    -- optional
    "nvim-treesitter/nvim-treesitter",
    "rcarriga/nvim-notify",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    lang = "python3",
    plugins = {
      non_standalone = true,
    },
    console = {
      open_on_runcode = true,
      size = {
        width = "95%",
        height = "80%",
      },
    },
    description = {
      position = "left",
      width = "45%",
      show_stats = true,
    },
    keys = {
      toggle = { "q", "<Esc>" },
      confirm = { "<CR>", "<Space>" },
      reset_testcases = "r",
      use_testcase = "u",
      focus_testcases = "h",
      focus_result = "l",
    },
  },
  config = function(_, opts)
    require("leetcode").setup(opts)
    
    local map = vim.keymap.set
    
    -- Main workflow
    map("n", "<leader>lm", "<cmd>Leet<CR>", { desc = "LeetCode Menu" })
    map("n", "<leader>ll", "<cmd>Leet list<CR>", { desc = "Problem List" })
    map("n", "<leader>ld", "<cmd>Leet daily<CR>", { desc = "Daily Problem" })
    map("n", "<leader>lr", "<cmd>Leet random<CR>", { desc = "Random Problem" })
    map("n", "<leader>lrm", "<cmd>Leet random difficulty=medium<CR>", { desc = "Random Medium Problem" })
    
    -- Testing and submission
    map("n", "<leader>lt", "<cmd>Leet test<CR>", { desc = "Test Solution" })
    map("n", "<leader>ls", "<cmd>Leet submit<CR>", { desc = "Submit Solution" })
    map("n", "<leader>lc", "<cmd>Leet console<CR>", { desc = "Open Console" })
    
    -- Problem info and management
    map("n", "<leader>li", "<cmd>Leet info<CR>", { desc = "Problem Info" })
    map("n", "<leader>ly", "<cmd>Leet yank<CR>", { desc = "Yank Solution" })
    map("n", "<leader>lo", "<cmd>Leet open<CR>", { desc = "Open in Browser" })
    map("n", "<leader>lb", "<cmd>Leet tabs<CR>", { desc = "Problem Tabs" })
    
    -- Code operations
    map("n", "<leader>lz", "<cmd>Leet reset<CR>", { desc = "Reset Code" })
    map("n", "<leader>lf", "<cmd>Leet fold<CR>", { desc = "Fold Imports" })
    map("n", "<leader>lg", "<cmd>Leet lang<CR>", { desc = "Change Language" })
    
    -- UI toggles
    map("n", "<leader>lh", "<cmd>Leet desc toggle<CR>", { desc = "Toggle Description" })
    map("n", "<leader>lj", "<cmd>Leet desc stats<CR>", { desc = "Toggle Stats" })
    
    -- Session management
    map("n", "<leader>lx", "<cmd>Leet exit<CR>", { desc = "Exit LeetCode" })
  end,
}
