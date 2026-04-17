return {
  "zbirenbaum/copilot.lua",
  opts = {
    filetypes = {
      lua = false, -- disables Copilot in LazyVim config
      help = false,
      dashboard = false,
      ["*"] = true, -- keep it globally enabled
    },
    auth_provider_url = "https://vector.ghe.com",
  },
}
