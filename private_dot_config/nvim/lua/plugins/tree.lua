return {
  "nvim-neo-tree/neo-tree.nvim",
  cond = function()
    return not vim.g.vscode
  end,
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
  opts = {
    popup_border_style = "",
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_hidden = false,
      },
      window = {
        mappings = {
          ["o"] = "system_open",
          ["H"] = {
            "toggle_preview",
            config = {
              use_float = false,
            },
          },
          ["<bs>"] = function(state)
            local node = state.tree:get_node()
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end,
        },
      },
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
    },
    commands = {
      system_open = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        vim.fn.jobstart({ "xdg-open", path }, { detach = true })
      end,
    },
  },
  keys = {
    {
      "|",
      "<cmd>Neotree toggle left reveal_force_cwd<CR>",
    },
  },
}
