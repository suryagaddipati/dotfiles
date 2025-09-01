return {
  "scalameta/nvim-metals",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  ft = { "scala", "sbt", "java" },
  opts = function()
    local metals_config = require("metals").bare_config()
    
    -- Reuse the same on_attach from lsp.lua for consistency
    metals_config.on_attach = function(client, bufnr)
      local opts = { buffer = bufnr, silent = true }
      vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition(); vim.cmd('normal! zz') end, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', '<leader>ld', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', '<leader>lr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', '<leader>lh', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', '<leader>ln', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', '<leader>ls', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('n', '<leader>lf', function() vim.lsp.buf.format({ async = true }) end, opts)
      vim.keymap.set('n', '<leader>li', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', '<leader>lw', vim.lsp.buf.workspace_symbol, opts)
      vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, opts)
      vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, opts)
      vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', '<leader>ll', vim.diagnostic.setloclist, opts)
      
      -- Single essential metals command
      vim.keymap.set('n', '<leader>mc', require('metals').commands, opts)
    end
    
    -- Add capabilities from nvim-cmp
    local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if has_cmp then
      metals_config.capabilities = cmp_nvim_lsp.default_capabilities()
    end
    
    return metals_config
  end,
  config = function(self, metals_config)
    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = self.ft,
      callback = function()
        require("metals").initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
  end
}