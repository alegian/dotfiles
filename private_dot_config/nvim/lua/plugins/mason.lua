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
        "tailwindcss-language-server",
        "gradle-language-server",
        "json-lsp",
        "html-lsp",
        "prisma-language-server",
        "haskell-language-server",
        "markdown-oxide",
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
