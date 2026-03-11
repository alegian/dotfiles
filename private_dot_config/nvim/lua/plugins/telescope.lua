return {
  "nvim-telescope/telescope.nvim",
  cond = function()
    return not vim.g.vscode
  end,
  tag = "0.1.8",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    pickers = {
      buffers = {
        sort_lastused = true,
        mappings = {
          n = {
            ["dd"] = "delete_buffer",
          },
        },
      },
      live_grep = {
        additional_args = function(opts)
          return { "--glob", "!*lock.json", "--glob", "!*.lock" }
        end,
      },
    },
  },
  keys = function()
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files)
    vim.keymap.set("n", "<leader>fg", builtin.live_grep)
    vim.keymap.set("n", "<leader>fb", builtin.buffers)
    vim.keymap.set("n", "<leader>fh", builtin.help_tags)
    vim.keymap.set("n", "<leader>fr", builtin.resume)
    vim.keymap.set("v", "<leader>fg", "\"zy<cmd>exec 'Telescope live_grep default_text=' . escape(@z, ' ')<cr>")
  end,
}
