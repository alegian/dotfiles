return {
  "dmmulroy/tsc.nvim",
  cond = function()
    return not vim.g.vscode
  end,
  opts = {},
}
