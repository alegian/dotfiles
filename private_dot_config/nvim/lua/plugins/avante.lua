return {
  "yetone/avante.nvim",
  cond = function()
    return not vim.g.vscode
  end,
  build = "make",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  opts = {
    instructions_file = "avante.md",
    provider = "copilot",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
    "zbirenbaum/copilot.lua",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
