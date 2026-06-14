vim.lsp.config("jdtls", {
  settings = {
    java = {
      maven = { downloadSources = true },
      import = {
        gradle = {
          enabled = true,
          wrapper = { enabled = true },
        },
      },
    },
  },
  init_options = {
    extendedClientCapabilities = {
      actionableRuntimeNotificationSupport = true,
      advancedExtractRefactoringSupport = true,
      advancedGenerateAccessorsSupport = true,
      advancedIntroduceParameterRefactoringSupport = true,
      advancedOrganizeImportsSupport = true,
      advancedUpgradeGradleSupport = true,
      classFileContentsSupport = true,
      clientDocumentSymbolProvider = false,
      clientHoverProvider = false,
      executeClientCommandSupport = true,
      extractInterfaceSupport = true,
      generateConstructorsPromptSupport = true,
      generateDelegateMethodsPromptSupport = true,
      generateToStringPromptSupport = true,
      gradleChecksumWrapperPromptSupport = true,
      hashCodeEqualsPromptSupport = true,
      inferSelectionSupport = {
        "extractConstant",
        "extractField",
        "extractInterface",
        "extractMethod",
        "extractVariableAllOccurrence",
        "extractVariable",
      },
      moveRefactoringSupport = true,
      onCompletionItemSelectedCommand = "editor.action.triggerParameterHints",
      overrideMethodsPromptSupport = true,
    },
  },
})

vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = { "jdt://*", "jar://*" },
  callback = function(ev)
    local clients = vim.lsp.get_clients({ name = "jdtls" })
    if #clients == 0 then
      vim.notify("jdtls not attached", vim.log.levels.ERROR)
      return
    end

    local client = clients[1]
    local buf = ev.buf
    local uri = ev.file

    local resp = client:request_sync("workspace/executeCommand", {
      command = "java.decompile",
      arguments = { uri },
    }, 10000, buf)

    if not resp or resp.err then
      vim.notify("decompile failed: " .. (resp and vim.inspect(resp.err) or "no response"), vim.log.levels.ERROR)
      return
    end

    local text = resp.result
    if type(text) ~= "string" then
      vim.notify("unexpected decompile response", vim.log.levels.ERROR)
      return
    end

    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, vim.split(text, "\n", { plain = true }))
    vim.bo[buf].swapfile = false
    vim.bo[buf].buftype = "acwrite"
    vim.bo[buf].filetype = "java"
    vim.bo[buf].readonly = true
    vim.bo[buf].modifiable = false

    if not vim.lsp.buf_is_attached(buf, client.id) then
      vim.lsp.buf_attach_client(buf, client.id)
    end
  end,
})
