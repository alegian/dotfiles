return {
  "stevearc/oil.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
  keys = {
    {
      "-",
      function()
        require("oil").open()
      end,
      mode = "n",
    },
  },
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    watch_for_changes = false,
    keymaps = {
      ["<leader>o"] = { "actions.open_external", mode = "n" },
      ["<bs>"] = { "actions.parent", mode = "n" },
    },
    view_options = {
      show_hidden = true,
    },
    git = {
      mv = function(src_path, dest_path)
        return true
      end,
    },
  },
}
