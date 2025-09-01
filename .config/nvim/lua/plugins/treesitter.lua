return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = { 'BufReadPost', 'BufNewFile', 'BufWinEnter' },
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = { 'lua', 'python', 'javascript', 'typescript', 'bash', 'json', 'yaml' },
      auto_install = true,
      modules = {},
      sync_install = false,
      ignore_install = {},
      highlight = { 
        enable = true,
        additional_vim_regex_highlighting = false,
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      indent = { enable = true },
    })
  end,
}