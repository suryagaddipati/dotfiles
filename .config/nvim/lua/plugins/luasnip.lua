return {
  'L3MON4D3/LuaSnip',
  version = 'v2.*',
  build = 'make install_jsregexp',
  dependencies = {
    'rafamadriz/friendly-snippets',
  },
  keys = {
    {
      '<Tab>',
      function()
        local luasnip = require('luasnip')
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          return '<Tab>'
        end
      end,
      mode = { 'i', 's' },
      expr = true,
      desc = 'Expand or jump snippet'
    },
    {
      '<S-Tab>',
      function()
        local luasnip = require('luasnip')
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          return '<S-Tab>'
        end
      end,
      mode = { 'i', 's' },
      expr = true,
      desc = 'Jump back in snippet'
    },
    {
      '<C-l>',
      function()
        local luasnip = require('luasnip')
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        end
      end,
      mode = { 'i', 's' },
      desc = 'Change snippet choice'
    },
  },
  config = function()
    local luasnip = require('luasnip')

    luasnip.setup({
      history = true,
      delete_check_events = 'TextChanged',
      region_check_events = 'CursorMoved,CursorHold,InsertEnter',
      enable_autosnippets = true,
      store_selection_keys = '<Tab>',
    })

    -- Load friendly-snippets
    require('luasnip.loaders.from_vscode').lazy_load()

    -- Load custom snippets
    require('luasnip.loaders.from_lua').load({ paths = { './lua/snippets' } })

    -- Custom snippets
    local s = luasnip.snippet
    local t = luasnip.text_node
    local i = luasnip.insert_node
    local f = luasnip.function_node
    local fmt = require('luasnip.extras.fmt').fmt

    luasnip.add_snippets('lua', {
      s('req', fmt("local {} = require('{}')", { i(1), i(2) })),
      s('func', fmt([[
        function {}({})
          {}
        end
      ]], { i(1), i(2), i(3) })),
    })

    luasnip.add_snippets('javascript', {
      s('cl', fmt("console.log({})", { i(1) })),
      s('fn', fmt("const {} = ({}) => {{\n  {}\n}}", { i(1), i(2), i(3) })),
      s('imp', fmt("import {} from '{}'", { i(1), i(2) })),
    })

    luasnip.add_snippets('python', {
      s('def', fmt([[
        def {}({}):
            {}
      ]], { i(1), i(2), i(3) })),
      s('class', fmt([[
        class {}:
            def __init__(self{}):
                {}
      ]], { i(1), i(2), i(3) })),
      s('if', fmt([[
        if {}:
            {}
      ]], { i(1), i(2) })),
    })

    -- Set up keybindings for snippet navigation
    vim.keymap.set({ 'i', 's' }, '<C-k>', function()
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      end
    end, { silent = true })

    vim.keymap.set({ 'i', 's' }, '<C-j>', function()
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      end
    end, { silent = true })
  end,
}

