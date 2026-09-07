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

vim.api.nvim_create_user_command("Bullet", function(opts)
  local start_line = opts.line1 - 1
  local lines = vim.api.nvim_buf_get_lines(0, start_line, opts.line2, false)
  for i, line in ipairs(lines) do
    lines[i] = line:gsub("%- %[[ x]%]", "-")
  end
  vim.api.nvim_buf_set_lines(0, start_line, opts.line2, false, lines)
end, { range = true, desc = "Convert checkboxes to bullets" })
