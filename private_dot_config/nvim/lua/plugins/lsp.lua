return {
  {
    -- default LSP configurations
    "neovim/nvim-lspconfig",
  },
  {
    -- automatically enable mason LSPs
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "L3MON4D3/LuaSnip",
    },
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = { preset = "luasnip" },
      keymap = {
        preset = "none",

        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<Tab>"] = { "select_and_accept", "fallback" },

        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
      },
    },
    opts_extend = { "sources.default" },
  },
}
