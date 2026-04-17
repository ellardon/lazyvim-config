return {
  {
    "rcasia/neotest-java",
  },
  {
    "nvim-neotest/neotest",
    opts = { adapters = { "neotest-java" } },
    keys = {
      {
        "<leader>tT",
        function()
          require("nio").run(function()
            local neotest = require("neotest")
            local nio = require("nio")
            local file = nio.fn.expand("%:p")
            -- get_tree_from_args must be called in an async context
            local tree = neotest.run.get_tree_from_args({ file })
            if not tree then
              vim.notify("No tests found in current file", vim.log.levels.WARN)
              return
            end
            -- Collect all test-level nodes
            local tests = {}
            for _, node in tree:iter_nodes() do
              local data = node:data()
              if data.type == "test" then
                tests[#tests + 1] = data
              end
            end
            if #tests == 0 then
              vim.notify("No individual tests found in current file", vim.log.levels.WARN)
              return
            end
            -- nio.ui.select works correctly inside async context
            local choice = nio.ui.select(tests, {
              prompt = "Select test to run:",
              format_item = function(item)
                return item.name
              end,
            })
            if choice then
              neotest.run.run(choice.id)
            end
          end)
        end,
        desc = "Pick and Run Test (Neotest)",
      },
    },
  },
}
