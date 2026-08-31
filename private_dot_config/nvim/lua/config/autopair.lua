local autopairs = {
  ["{"] = "}",
  ["("] = ")",
  ['"'] = '"',
  ["'"] = "'",
  ["`"] = "`",
}

for open, close in pairs(autopairs) do
  vim.keymap.set("i", open, function()
    return open .. close .. "<Left>"
  end, { expr = true, noremap = true })
end

vim.keymap.set("i", "[", function()
  if vim.bo.filetype == "markdown" and vim.api.nvim_get_current_line() == "" then
    return "- [ ] "
  end
  return "[" .. "]" .. "<Left>"
end, { expr = true, noremap = true })
