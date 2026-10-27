return {
  "kylechui/nvim-surround",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  version = "^4.0.0",
  event = "VeryLazy",
  init = function()
    vim.g.nvim_surround_no_visual_mappings = true
  end,
  keys = {
    { "s", "<Plug>(nvim-surround-visual)", mode = "x", desc = "Add a surrounding pair" },
  },
}
