return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lemminx = {
          settings = {
            xml = {
              format = {
                splitAttributes = false,
              },
            },
          },
        },
      },
    },
  },
}
