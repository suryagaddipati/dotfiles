return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'b0o/schemastore.nvim',
  },
  config = function()
    local cmp = require('cmp')
    cmp.setup({
      sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
      }),
    })

    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = 'rounded',
        source = 'if_many',
        header = '',
        prefix = '',
      },
    })

    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
          [vim.diagnostic.severity.INFO] = ' ',
        }
      }
    })

    local on_attach = function(_, bufnr)
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
    end

    local servers = { 'lua_ls', 'pyright', 'rust_analyzer', 'gopls', 'bashls', 'jsonls', 'yamlls' }

    if vim.fn.executable('tsc') == 1 or vim.fn.executable('typescript') == 1 then
      table.insert(servers, 'ts_ls')
    end

    for _, lsp in ipairs(servers) do
      local config = {
        on_attach = on_attach,
        capabilities = capabilities,
      }

      if lsp == 'lua_ls' then
        config.settings = {
          Lua = {
            diagnostics = {
              globals = {'vim'},
              disable = {'trailing-space', 'empty-block'}
            },
            format = {
              enable = false
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          }
        }
      elseif lsp == 'jsonls' then
        config.cmd = { 'vscode-json-languageserver', '--stdio' }
        config.settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          }
        }
      elseif lsp == 'yamlls' then
        config.settings = {
          yaml = {
            schemaStore = {
              enable = false,
              url = '',
            },
            schemas = require('schemastore').yaml.schemas(),
          }
        }
      end

      require('lspconfig')[lsp].setup(config)
    end
  end,
}