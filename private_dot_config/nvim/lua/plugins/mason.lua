return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "mason-org/mason.nvim",
    },
    opts = {
      auto_update = true,
      run_on_start = true,
      ensure_installed = {
        -- LSPs
        "lua-language-server",
        "typescript-language-server",
        "kotlin-lsp",
        "tailwindcss-language-server",
        "java-language-server",
        "gradle-language-server",
        "json-lsp",
        "html-lsp",
        "prisma-language-server",
        "haskell-language-server",
        -- Formatters
        "stylua",
        "prettierd",
        "ktfmt",
        -- Linters
        "eslint_d",
        "ktlint",
      },
    },
  },
}
