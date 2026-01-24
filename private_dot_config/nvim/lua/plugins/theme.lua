return {
  "projekt0n/github-nvim-theme",
  cond = function()
    return not vim.g.vscode
  end,
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    vim.cmd("colorscheme github_dark_high_contrast")
  end,
}
