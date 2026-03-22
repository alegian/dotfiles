local autopairs = {
  ["{"] = "}",
  ["["] = "]",
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
