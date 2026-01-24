local window = function()
  return vim.api.nvim_win_get_number(0)
end

return {
  "nvim-lualine/lualine.nvim",
  cond = function()
    return not vim.g.vscode
  end,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    sections = {
      lualine_a = { "mode" },
      lualine_b = { window, "location" },
      lualine_c = { "filename" },
      lualine_x = {
        "encoding",
        {
          "fileformat",
          symbols = {
            unix = "LF",
            dos = "CRLF",
            mac = "CR",
          },
        },
        "filetype",
      },
      lualine_y = { "searchcount" },
      lualine_z = { "lsp_status" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = { window },
      lualine_c = { "filename" },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  },
}
