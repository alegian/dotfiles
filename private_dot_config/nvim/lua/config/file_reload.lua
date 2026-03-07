vim.o.autoread = true
local new_buffers = {}
vim.api.nvim_create_autocmd("BufNew", {
  callback = function(ev)
    new_buffers[ev.buf] = true
  end,
  pattern = "*",
})
vim.api.nvim_create_autocmd("BufDelete", {
  callback = function(ev)
    new_buffers[ev.buf] = nil
  end,
  pattern = "*",
})
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  callback = function(ev)
    if vim.fn.mode() == "c" then
      return
    end
    if ev.event == "BufEnter" and new_buffers[ev.buf] then
      new_buffers[ev.buf] = nil
      return
    end
    vim.cmd("checktime")
  end,
  pattern = "*",
})