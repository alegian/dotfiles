return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    "bullets-vim/bullets.nvim",
    ft = { "markdown", "text" },
    ---@type bullets.Config
    opts = {
      enabled_file_types = { "markdown", "text" },
      set_mappings = false,
      custom_mappings = {
        { "n", "<leader>bc", "<Plug>(bullets-toggle-checkbox)" },
      },
    },
  },
}
