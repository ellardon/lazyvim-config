return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      -- Disable jdtls.dap test keymaps so neotest owns <leader>tt, <leader>tr, <leader>tT
      opts.test = false

      opts.settings.java = {
        configuration = {
          runtimes = {
            {
              name = "JavaSE-11",
              path = "/usr/lib/jvm/java-1.11.0-openjdk-amd64",
              default = true,
            },
            {
              name = "JavaSE-17",
              path = "/usr/lib/jvm/java-1.17.0-openjdk-amd64",
            },
            {
              name = "JavaSE-21",
              path = "/usr/lib/jvm/java-1.21.0-openjdk-amd64",
            },
          },
        },
        format = {
          settings = {
            url = "/home/cosqojote/intellij-java-style.xml",
            profile = "intellij",
          },
        },
      }

      return opts
    end,
  },
}
