vim.lsp.config("tailwindcss", {
  settings = {
    tailwindCSS = {
      classFunctions = { "cva", "tw\\.[a-z-]+" },
      experimental = {
        configFile = "../../packages/reactlib/global.css",
        classRegex = {
          [=[=\s*["'`]([^"'`]*)["'`]]=],
          [=[:\s*["'`]([^"'`]*)["'`]]=],
          [=[["'`]([^"'`]*)["'`]]=],
        },
      },
    },
  },
})
require("snippets.givelink")
