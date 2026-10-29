local server_dir = vim.fn.expand("~/.local/share/intellij-server")
local version_fixes = {}

local function install_intellij_version_fix(client)
  local ledgers = {}
  local original_notify = client.notify
  local original_request = client.request

  local function translate(uri, version)
    if version == nil or version == vim.NIL then
      return vim.NIL
    end
    if type(version) ~= "number" or version <= 0 then
      return version
    end

    local ledger = ledgers[uri]
    if not ledger then
      return version
    end

    if ledger.ticks[version] then
      return ledger.ticks[version]
    end
    if ledger.sent[version] then
      return version
    end

    -- Unknown versions must not bypass stale-edit checks.
    return -1
  end

  local function fix_edit(edit)
    if not edit or not edit.documentChanges then
      return
    end

    for _, change in ipairs(edit.documentChanges) do
      local doc = change.textDocument
      if doc and doc.uri then
        doc.version = translate(doc.uri, doc.version)
      end
    end
  end

  client.notify = function(self, method, params, ...)
    local doc = params and params.textDocument

    if doc and doc.uri then
      local uri = doc.uri

      if method == "textDocument/didOpen" then
        local version = doc.version or 0
        ledgers[uri] = {
          counter = version,
          ticks = { [version] = version },
          sent = { [version] = true },
        }
      elseif method == "textDocument/didChange" then
        local ledger = ledgers[uri]
        if ledger and type(doc.version) == "number" then
          ledger.counter = ledger.counter + 1
          ledger.ticks[ledger.counter] = doc.version
          ledger.sent[doc.version] = true
        end
      elseif method == "textDocument/didClose" then
        ledgers[uri] = nil
      end
    end

    return original_notify(self, method, params, ...)
  end

  local methods = {
    ["textDocument/rename"] = true,
    ["workspace/willRenameFiles"] = true,
    ["textDocument/codeAction"] = true,
    ["codeAction/resolve"] = true,
  }

  client.request = function(self, method, params, handler, ...)
    if not methods[method] then
      return original_request(self, method, params, handler, ...)
    end

    local callback = handler or (self.handlers and self.handlers[method]) or vim.lsp.handlers[method]

    if not callback then
      return original_request(self, method, params, handler, ...)
    end

    return original_request(self, method, params, function(err, result, ...)
      if type(result) == "table" then
        if method == "textDocument/codeAction" then
          for _, action in ipairs(result) do
            if type(action) == "table" then
              fix_edit(action.edit)
            end
          end
        elseif method == "codeAction/resolve" then
          fix_edit(result.edit)
        else
          fix_edit(result)
        end
      end

      return callback(err, result, ...)
    end, ...)
  end

  return fix_edit
end

local eula_hash = vim.fn
  .system({
    "sha256sum",
    server_dir .. "/EULA.txt",
  })
  :sub(1, 16)

vim.lsp.config("intellij", {
  cmd = {
    server_dir .. "/bin/intellij-server",
    "--stdio",
    "--system-path",
    vim.fn.stdpath("cache") .. "/intellij-standalone",
    "--eula",
    eula_hash,
  },

  filetypes = { "java", "kotlin" },

  root_markers = {
    "pom.xml",
    "settings.gradle",
    "settings.gradle.kts",
    "build.gradle",
    "build.gradle.kts",
    "MODULE.bazel",
    ".git",
  },

  init_options = {
    intellijExtensions = false,
    lazyIntentions = false,
    runMainCodeLens = false,
  },

  on_init = function(client)
    version_fixes[client.id] = install_intellij_version_fix(client)
  end,

  handlers = {
    ["workspace/applyEdit"] = function(err, params, ctx, config)
      local fix = version_fixes[ctx.client_id]

      if fix and params then
        fix(params.edit)
      end

      return vim.lsp.handlers["workspace/applyEdit"](err, params, ctx, config)
    end,
  },

  on_exit = function(_, _, client_id)
    version_fixes[client_id] = nil
  end,
})

vim.lsp.enable("intellij")

local decompile_cache = {}

vim.api.nvim_create_autocmd("BufReadCmd", {
  group = vim.api.nvim_create_augroup("IntellijStandaloneDecompiler", { clear = true }),
  pattern = { "*/jar:*", "jar:/*", "jrt:/*" },

  callback = function(args)
    local bufnr = args.buf
    local uri = args.file

    local jar_start = uri:find("jar:", 1, true)
    if jar_start then
      uri = uri:sub(jar_start)
    end

    if not uri:match("^jar:") and not uri:match("^jrt:") then
      return
    end

    local client = vim.lsp.get_clients({
      name = "intellij",
    })[1]

    local function fill(code, language)
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end

      vim.bo[bufnr].readonly = false
      vim.bo[bufnr].modifiable = true

      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(code, "\n", { plain = true }))

      vim.bo[bufnr].buftype = "nofile"
      vim.bo[bufnr].swapfile = false
      vim.bo[bufnr].modified = false
      vim.bo[bufnr].modifiable = false
      vim.bo[bufnr].readonly = true

      if language then
        vim.bo[bufnr].filetype = language
      end
    end

    if not client then
      fill("// IntelliJ LSP is not running")
      return
    end

    vim.lsp.buf_attach_client(bufnr, client.id)

    if decompile_cache[uri] then
      local cached = decompile_cache[uri]
      fill(cached.code, cached.language)
      return
    end

    local done = false

    local sent = client:request("workspace/executeCommand", {
      command = "decompile",
      arguments = { uri },
    }, function(err, result)
      done = true

      if err or not result or not result.code then
        fill("// Failed to decompile: " .. uri)
        return
      end

      decompile_cache[uri] = result
      fill(result.code, result.language)
    end, bufnr)

    if not sent then
      fill("// Could not send decompile request")
      return
    end

    vim.wait(10000, function()
      return done
    end, 10)

    if not done then
      fill("// Decompiled source is loading...")
    end
  end,
})
