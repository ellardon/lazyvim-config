return {
  {
    "stevearc/conform.nvim",
    opts = {
      -- These options are merged into the table LazyVim passes to
      -- require("conform").format(...). `range = "diff"` tells Conform
      -- to only apply edits for modified hunks.
      format = {
        timeout_ms = 500,
        lsp_fallback = true,
        range = "diff", -- <--- important: only format modified hunks
      },

      -- you can still keep per-ft formatters here if you want:
      -- formatters_by_ft = {
      --   lua = { "stylua" },
      --   js = { "prettier" },
      -- },
    },
  },
}
