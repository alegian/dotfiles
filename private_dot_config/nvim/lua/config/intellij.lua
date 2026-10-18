vim.lsp.config("intellij", {
  cmd = {
    vim.fn.expand("~/.local/share/intellij-server/bin/intellij-server"),
    "--stdio",
    "--system-path",
    vim.fn.stdpath("cache") .. "/intellij-standalone",
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
