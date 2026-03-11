vim.keymap.set("n", "<leader>ai", function()
  local file_path, line, col

  if vim.bo.buftype == "quickfix" then
    local qf_list = vim.fn.getqflist()
    local entry = qf_list[vim.fn.line(".")]

    if entry and entry.bufnr > 0 then
      file_path = vim.api.nvim_buf_get_name(entry.bufnr)
      line = entry.lnum
      col = entry.col
    end
  else
    file_path = vim.fn.expand("%:p")
    local cursor = vim.api.nvim_win_get_cursor(0)
    line = cursor[1]
    col = cursor[2] + 1 -- Neovim columns are 0-indexed
  end

  if file_path and file_path ~= "" then
    local root = vim.fn.getcwd()
    local cmd = string.format("cursor %s -g %s:%d:%d", root, file_path, line, col)

    vim.fn.jobstart({ "swaymsg", "workspace", "6" }, { detach = true })
    vim.fn.jobstart(cmd, { detach = true })
  end
end, { desc = "Open in Cursor" })

vim.api.nvim_create_user_command("CursorQFL", function()
  local qf_list = vim.fn.getqflist()
  if not qf_list or vim.tbl_isempty(qf_list) then
    return
  end

  local files = {}

  for _, entry in ipairs(qf_list) do
    if entry.bufnr and entry.bufnr > 0 then
      local file_path = vim.api.nvim_buf_get_name(entry.bufnr)
      if file_path ~= "" then
        files[file_path] = true
      end
    end
  end

  local root = vim.fn.getcwd()
  local cmd = { "cursor", root }
  for file, _ in pairs(files) do
    table.insert(cmd, file)
  end

  vim.fn.jobstart({ "swaymsg", "workspace", "6" }, { detach = true })
  vim.fn.jobstart(cmd, { detach = true })
end, { desc = "Open all Quickfix entries in Cursor" })
