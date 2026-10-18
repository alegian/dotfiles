vim.api.nvim_create_autocmd("TextChangedI", {
  callback = function(args)
    local col = vim.api.nvim_win_get_cursor(0)[2]
    if col == 0 then
      return
    end

    local line = vim.api.nvim_get_current_line()
    local char = line:sub(col, col)

    for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
      local provider = client.server_capabilities.signatureHelpProvider

      if provider and vim.tbl_contains(provider.triggerCharacters or {}, char) then
        vim.lsp.buf.signature_help({
          border = "rounded",
          silent = true,
          focusable = false,
        })
        return
      end
    end
  end,
})

require("config.intellij")
