return {
  "pwntester/octo.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "folke/snacks.nvim",
  },
  opts = {
    picker = "snacks",
    enable_debug_logging = true,
    suppress_missing_scope = {
      projects_v2 = true,
    },
  },
  keys = {
    -- Disable defaul first level mappings
    { "<leader>gi", false },
    { "<leader>gI", false },
    { "<leader>gp", false },
    { "<leader>gP", false },
    { "<leader>gr", false },
    { "<leader>gS", false },

    -- Redefine first levels mappings with new keys
    { "<leader>o", desc = "+github" },
    { "<leader>oi", "<cmd>Octo issue list<CR>", desc = "List Issues (Octo)" },
    { "<leader>oI", "<cmd>Octo issue search<CR>", desc = "Search Issues (Octo)" },
    { "<leader>op", "<cmd>Octo pr list<CR>", desc = "List PRs (Octo)" },
    { "<leader>oP", "<cmd>Octo pr search<CR>", desc = "Search PRs (Octo)" },
    {
      "<leader>or",
      "<cmd>Octo search is:open is:pr review-requested:cosqojote archived:false<CR>",
      desc = "List PRs Awaiting Review (Octo)",
    },
    {
      "<leader>oa",
      "<cmd>Octo search is:open is:pr assignee:cosqojote archived:false<CR>",
      desc = "List PRs Assigned (Octo)",
    },
  },
}
