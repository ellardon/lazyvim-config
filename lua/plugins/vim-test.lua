return {
  {
    "vim-test/vim-test",
    config = function()
      -- Custom strategy for running tests in a new Zellij pane at the bottom
      vim.cmd([[
      function! TestStrategyZellij(cmd) abort
      " Escape double-quotes for safety
      let l:escaped = substitute(a:cmd, '"', '\\"', "g")

      " For maximum compatibility, run a shell inside the pane
      let l:zcmd = 'zellij run -d down -- ' . l:escaped . ' ' 

      call system(l:zcmd)
      endfunction

      let g:test#custom_strategies = {'zellij': function('TestStrategyZellij')}
      let g:test#strategy = 'zellij'
]])

      -- Treat Groovy files as Java
      vim.g["test#filetypes"] = {
        groovy = "java",
      }
      -- Set the Java runner to Maven
      vim.g["test#java#runner"] = "maventest"
      -- -- Set the Maven executable (default: mvn)
      -- vim.g["test#java#maventest#executable"] = "mvn"
      -- -- Optional: run only tests (skipping build)
      -- vim.g["test#java#maventest#options"] = "-Dtest=%s test"
      -- vim.g["test#java#maventest#options"] = "test"
    end,
    keys = {
      { "<leader>tm", desc = "Run Tests Maven" },
      { "<leader>tmr", ":TestNearest<CR>", desc = "Run nearest test" },
      { "<leader>tmf", ":TestFile<CR>", desc = "Run test file" },
      { "<leader>tms", ":TestSuite<CR>", desc = "Run test suite" },
      { "<leader>tml", ":TestLast<CR>", desc = "Run last test" },
      { "<leader>tmv", ":TestVisit<CR>", desc = "Visit test file" },
    },
  },
}
