vim.keymap.set("n", "<Insert>", "<Nop>", { silent = true })
vim.keymap.set("i", "<Insert>", "<Nop>", { silent = true })
vim.keymap.set("v", "<Insert>", "<Nop>", { silent = true })
vim.keymap.set("x", "<Insert>", "<Nop>", { silent = true })
vim.keymap.set("s", "<Insert>", "<Nop>", { silent = true })

vim.opt.clipboard:append("unnamedplus")
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.colorcolumn = "80"
vim.opt.updatetime = 50
vim.opt.signcolumn = "yes"
vim.opt.winborder = "rounded"
vim.opt.completeopt = { "menu", "menuone", "noinsert", "popup" }
vim.opt.cursorline = true
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")
vim.opt.exrc = true
vim.o.autoread = true

vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { silent = true })
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { silent = true })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { silent = true })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { silent = true })
vim.keymap.set("x", "<leader>p", '"_dP', { silent = true })
vim.keymap.set("n", "<leader>d", '"_d', { silent = true })
vim.keymap.set("x", "<leader>d", '"_d', { silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true })
vim.keymap.set("n", "n", "nzzzv", { silent = true })
vim.keymap.set("n", "N", "Nzzzv", { silent = true })
vim.keymap.set("v", "<", "<gv", { silent = true })
vim.keymap.set("v", ">", ">gv", { silent = true })
vim.keymap.set("n", "g]", vim.diagnostic.goto_next, { silent = true })
vim.keymap.set("n", "g[", vim.diagnostic.goto_prev, { silent = true })
vim.keymap.set("n", "H", function()
  local _, winid = vim.diagnostic.open_float()
  if winid == nil then
    vim.lsp.buf.hover()
  end
end, { silent = true })
for i = 1, 4 do
  local lhs = "<leader>" .. i
  local rhs = i .. "<c-w>w"
  vim.keymap.set("n", lhs, rhs)
end

-- close current pane
vim.keymap.set("n", "<leader>x", "<cmd>close<CR>")

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
    numhl = {
      [vim.diagnostic.severity.WARN] = "WarningMsg",
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticHint",
    },
  },
})

-- hack to make ts_ls not cry
local old_notify = vim.notify
vim.notify = function(msg, level, opts)
  if type(msg) == "string" and msg:match("_typescript.applyCodeActionCommand") then
    return
  end
  old_notify(msg, level, opts)
end

require("config.autopair")
require("config.cursor")

require("config.lazy")
