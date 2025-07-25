return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',
  config = function()
    local function search_count()
      if vim.v.hlsearch == 0 then
        return ''
      end
      local ok, search = pcall(vim.fn.searchcount)
      if not ok or next(search) == nil then
        return ''
      end
      if search.incomplete == 1 then
        return '?/?'
      end
      if search.incomplete == 2 then
        if search.total > search.maxcount and search.current > search.maxcount then
          return string.format('>%d/>%d', search.current, search.total)
        elseif search.total > search.maxcount then
          return string.format('%d/>%d', search.current, search.total)
        end
      end
      return string.format('%d/%d', search.current, search.total)
    end

    local function macro_recording()
      local recording = vim.fn.reg_recording()
      if recording ~= '' then
        return 'Recording @' .. recording
      end
      return ''
    end

    require('lualine').setup({
      options = {
        theme = 'gruvbox',
        globalstatus = true,
        disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'starter' } },
        section_separators = { left = '', right = '' },
        component_separators = { left = '|', right = '|' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 
          'branch',
          'diff',
          {
            'diagnostics',
            sources = { 'nvim_lsp' },
            symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
          }
        },
        lualine_c = {
          {
            'filename',
            file_status = true,
            newfile_status = false,
            path = 1, -- 0: filename, 1: relative path, 2: absolute path
            shorting_target = 40,
            symbols = {
              modified = '[+]',
              readonly = '[RO]',
              unnamed = '[No Name]',
              newfile = '[New]',
            }
          }
        },
        lualine_x = {
          {
            macro_recording,
            color = { fg = '#ff9e64' },
          },
          {
            search_count,
            color = { fg = '#7aa2f7' },
          },
          'encoding',
          'fileformat',
          'filetype',
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = { 'nvim-tree', 'toggleterm' }
    })
  end,
}