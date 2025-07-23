return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
    opts = {
      direction = "float",
      shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell", -- use PowerShell
    },
  },
}
