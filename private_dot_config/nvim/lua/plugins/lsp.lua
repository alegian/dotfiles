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
      fuzzy = {
        sorts = {
          function(a, b)
            local function is_low_priority(item)
              return item.client_name == "tailwindcss"
            end

            local a_low = is_low_priority(a)
            local b_low = is_low_priority(b)

            if a_low ~= b_low then
              return not a_low
            end
          end,

          "score",
          "sort_text",
        },
      },
    },
    opts_extend = { "sources.default" },
  },
}
