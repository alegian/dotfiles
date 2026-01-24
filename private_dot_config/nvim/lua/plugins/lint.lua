return {
  "mfussenegger/nvim-lint",
  dependencies = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  keys = {
    {
      "<localleader>l",
      function()
        vim.cmd("w")
        local eslint = require("lint").linters.eslint_d.args
        table.remove(eslint, #eslint - 1)
        table.remove(eslint, #eslint - 1)
        table.insert(eslint, "--fix")
        require("lint").try_lint()
        table.remove(eslint)
        table.insert(eslint, #eslint, "--stdin")
        table.insert(eslint, #eslint, "--stdin-filename")
        vim.defer_fn(function()
          vim.cmd("checktime")
        end, 1000)
      end,
      mode = "n",
    },
  },
  event = "VimEnter",
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      kotlin = { "ktlint" },
    }

    local eslint = lint.linters.eslint_d.args
    table.insert(eslint, 1, "--flag")
    table.insert(eslint, 2, "v10_config_lookup_from_file")

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
