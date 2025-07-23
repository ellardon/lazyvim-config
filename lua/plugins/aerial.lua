return {
  {
    "stevearc/aerial.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
    config = function()
      require("aerial").setup()
      vim.keymap.set("n", "<leader>ss", "<cmd>AerialToggle<CR>", { desc = "Toggle Aerial Sidebar" })
    end,
  },
}
