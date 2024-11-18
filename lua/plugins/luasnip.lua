return {
  "L3MON4D3/LuaSnip",
  build = "make install_jsregexp",
  event = "InsertEnter",
  enabled = true,
  dependencies = "rafamadriz/friendly-snippets",
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()
  end,
}
