return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")
      treesitter.setup({})
      local initial_install =
        treesitter.install({ "javascript", "typescript", "java", "kotlin", "lua", "css", "html", "tsx", "json" })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
        callback = function(event)
          local buf = event.buf
          local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
          if not lang then
            return
          end

          -- Only install languages supported by nvim-treesitter.
          if not vim.tbl_contains(treesitter.get_available(), lang) then
            return
          end

          initial_install:await(function()
            treesitter.install({ lang }):await(function(err)
              if err then
                return
              end
              vim.schedule(function()
                if not vim.api.nvim_buf_is_valid(buf)
                  or vim.treesitter.language.get_lang(vim.bo[buf].filetype) ~= lang
                then
                  return
                end

                local stats = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
                if not stats or stats.size <= 100 * 1024 then
                  pcall(vim.treesitter.start, buf, lang)
                end
                vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
              end)
            end)
          end)
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      enable = false,
      multiline_threshold = 10,
      trim_scope = "inner",
    },
    event = "VimEnter",
    keys = {
      {
        "<leader>gc",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        mode = "n",
      },
      {
        "<leader>cc",
        "<cmd>TSContext toggle<CR>",
        mode = "n",
      },
    },
  },
}
