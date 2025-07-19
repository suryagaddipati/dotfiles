local augroup = vim.api.nvim_create_augroup('NinjaConfig', {})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup,
  pattern = '*',
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 1 and line <= vim.fn.line("$") then
      vim.api.nvim_win_set_cursor(0, {line, 0})
    end
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = augroup,
  pattern = '*',
  command = '%s/\\s\\+$//e',
})

vim.api.nvim_create_autocmd('FileType', {
  group = augroup,
  pattern = 'python',
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})

