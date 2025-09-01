return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    require('nvim-autopairs').setup({
      check_ts = true,  -- Enable treesitter integration
      ts_config = {
        lua = {'string', 'source'},
        javascript = {'string', 'template_string'},
        typescript = {'string', 'template_string'},
        python = {'string'},
      },
      disable_filetype = { 'TelescopePrompt', 'spectre_panel' },
      disable_in_macro = false,
      disable_in_visualblock = false,
      disable_in_replace_mode = true,
      ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
      enable_moveright = true,
      enable_afterquote = true,
      enable_check_bracket_line = false,
      enable_bracket_in_quote = true,
      enable_abbr = false,
      break_undo = true,
      check_comma = true,
      map_char = {
        all = '(',
        tex = '{'
      },
      -- Smart deletion
      map_bs = true,
      map_c_h = false,
      map_c_w = false,
    })

    -- Integration with nvim-cmp
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

    -- Custom rules for better behavior
    local Rule = require('nvim-autopairs.rule')
    local npairs = require('nvim-autopairs')

    -- Add spaces inside parentheses
    npairs.add_rule(Rule(' ', ' ')
      :with_pair(function(opts)
        local pair = opts.line:sub(opts.col - 1, opts.col)
        return vim.tbl_contains({ '()', '[]', '{}' }, pair)
      end))

    -- Add rule for arrow functions
    npairs.add_rule(Rule('%(.*%)%s*%=>$', ' {  }', {'typescript', 'javascript', 'typescriptreact', 'javascriptreact'})
      :use_regex(true)
      :set_end_pair_length(2))
  end,
}