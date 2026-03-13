return {
  "nickaris1/tsc.nvim",
  cond = function()
    return not vim.g.vscode
  end,
  opts = {},
}
