return { -- Autocompletion
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
  enabled = true,
  -- nvim-cmp setup
  autostart = true,
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local types = require("cmp.types")
    -- luasnip.config()
    -- Using protected call

    cmp.setup({
      preselect = cmp.PreselectMode.None,
      view = {
        entries = { name = "custom" },
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      formatting = {

        expandable_indicator = true,
        fields = { "menu", "abbr", "kind" },
        format = function(entry, item)
          local menu_icon = {
            nvim_lsp = " ",
            nvim_lua = " ",
            luasnip = "⋗ ",
            buffer = " ",
            path = " ",
          }
          item.menu = menu_icon[entry.source.name]
          return item
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        ["<CR>"] = cmp.config.disable,
        ["<C-y>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
        ["<C-j>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            fallback()
          elseif luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<C-k>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
            fallback()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sorting = {
        priority_weight = 2,
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          function(entry1, entry2)
            local kind1 = entry1:get_kind()
            kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
            local kind2 = entry2:get_kind()
            kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
            if kind1 ~= kind2 then
              if kind1 == types.lsp.CompletionItemKind.Snippet then
                return false
              end
              if kind2 == types.lsp.CompletionItemKind.Snippet then
                return true
              end
              local diff = kind1 - kind2
              if diff < 0 then
                return true
              elseif diff > 0 then
                return false
              end
            end
          end,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }),
    })
  end,
}
