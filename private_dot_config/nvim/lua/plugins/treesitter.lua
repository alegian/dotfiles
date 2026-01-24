return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "javascript", "typescript", "java", "kotlin", "lua", "css", "html", "tsx", "json" },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
        },
        indent = { enable = true },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      multiline_threshold = 10,
      trim_scope = "inner",
    },
    event = "VimEnter",
    keys = {
      {
        "<leader>gc",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        mode = "n",
      },
      {
        "<leader>cc",
        "<cmd>TSContext toggle<CR>",
        mode = "n",
      },
    },
  },
}
