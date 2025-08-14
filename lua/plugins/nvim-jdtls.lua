return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      opts.settings.java.configuration = {
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
      }

      return opts
    end,
  },
}
