return {
  {
    "vim-test/vim-test",
    config = function()
      -- Optional: set a default test runner for your language
      vim.g["test#strategy"] = "toggleterm" -- or "vimux", "dispatch", "toggleterm", etc.

      --       -- Treat Groovy files as Java
      vim.g["test#filetypes"] = {
        groovy = "java",
      }

      -- Set the Java runner to Maven
      vim.g["test#java#runner"] = "maventest"

      -- Set the Maven executable (default: mvn)
      vim.g["test#java#maventest#executable"] = "mvn"

      -- Optional: run only tests (skipping build)
      -- vim.g["test#java#maventest#options"] = "-Dtest=%s test"
      -- vim.g["test#java#maventest#options"] = "test"
    end,
    keys = {
      { "<leader>tn", ":TestNearest<CR>", desc = "Run nearest test" },
      { "<leader>tf", ":TestFile<CR>", desc = "Run test file" },
      { "<leader>ts", ":TestSuite<CR>", desc = "Run test suite" },
      { "<leader>tl", ":TestLast<CR>", desc = "Run last test" },
      { "<leader>tv", ":TestVisit<CR>", desc = "Visit test file" },
    },
  },
}
