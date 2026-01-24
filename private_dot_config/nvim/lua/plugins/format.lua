return {
  "stevearc/conform.nvim",
  dependencies = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<localleader>f",
      function()
        require("conform").format()
        vim.cmd("w")
      end,
      mode = "n",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      kotlin = { "ktfmt" },
      json = { "prettierd" },
      typescript = { "prettierd" },
      javascript = { "prettierd" },
      typescriptreact = { "prettierd" },
      javascriptreact = { "prettierd" },
      html = { "prettierd" },
      markdown = { "prettierd" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
  },
}
