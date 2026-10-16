return {
  "JetBrains/intellij-lsp.nvim",
  opts = {
    accept_eula = true,
    server_path = "~/.local/share/intellij-server/bin/intellij-server",
    -- Completion --------------------------------------------------------------
    autotrigger = false, -- open the completion menu on "."
    completeopt = false, -- add menuone,fuzzy,noinsert to 'completeopt'; false keeps yours
    word_triggers = false, -- also request completion while typing identifiers
    completion_delay = 100, -- ms after the first letter of a word before asking the server
    enter_accepts_completion = false, -- <CR> accepts the selected completion

    -- Editor ------------------------------------------------------------------
    references = false, -- grr opens a live-previewing reference list
    inlay_hints = false, -- parameter and type hints
    inlay_hint_settings = nil, -- merged over the built-in hint defaults
    folding = true, -- fold with the server's folding ranges
    document_highlight = false, -- highlight the identifier under the cursor after 'updatetime'
    signature_help = true, -- parameter popup when typing ( or , inside a call
    keymaps = false, -- <leader> maps for type/call hierarchy and symbol search
    format_on_save = false, -- run IntelliJ's formatter on every write (:IntellijLspFormat by hand)
    file_templates = false, -- offer IntelliJ file templates for a new, empty .java/.kt file
    intellij_extensions = true, -- opt into the intellij/ protocol extensions: lazy quick fixes, variants, conflicts
    decompiler = true, -- open jar:/jrt: URIs as decompiled source
    rename_files = false, -- register :IntellijLspRename {path}
    colorscheme = false, -- apply the bundled islands-dark scheme unless you set your own (needs termguicolors)
    nowrap = false, -- set 'nowrap' like IntelliJ's default

    -- Messages ----------------------------------------------------------------
    progress = true, -- import and indexing progress on one line in the message area
    build_output = "on_failure", -- open the output panel during import: 'always' | 'on_failure' | 'never'
    single_key_select = true, -- answer numbered prompts with a bare digit

    -- Git, run, debug ---------------------------------------------------------
    git = false, -- :IntellijGitStatus, :IntellijGitDiff, :IntellijGitLog, :IntellijGitBranches
    run = false, -- run the main class at the cursor (needs nvim-dap)
    build_before_run = true, -- compile with the build tool before each run or debug launch
    debug = false, -- breakpoints, stepping, debug panel (needs run and nvim-dap)
  },
}
