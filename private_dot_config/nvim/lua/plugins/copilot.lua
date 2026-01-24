return {
  "zbirenbaum/copilot.lua",
  cond = function()
    return not vim.g.vscode
  end,
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    suggestion = {
      keymap = {
        accept = "<Insert>",
        accept_word = "<C-Right>",
        dismiss = "<Esc>",
      },
    },
  },
}
