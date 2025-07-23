-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("v", "<leader>y", '"*y')
vim.keymap.set("n", "<leader>p", '"*p')
vim.keymap.set("n", "<A-Left>", "<cmd>bprevious<cr>")
vim.keymap.set("n", "<A-Right>", "<cmd>bnext<cr>")
-- Forward <A-Up>/<A-Down> to <A-k>/<A-j>
vim.keymap.set("n", "<A-Up>", "<A-k>", { remap = true, desc = "Move Up" })
vim.keymap.set("n", "<A-Down>", "<A-j>", { remap = true, desc = "Move Down" })
vim.keymap.set("i", "<A-Up>", "<A-k>", { remap = true, desc = "Move Up" })
vim.keymap.set("i", "<A-Down>", "<A-j>", { remap = true, desc = "Move Down" })
vim.keymap.set("v", "<A-Up>", "<A-k>", { remap = true, desc = "Move Up" })
vim.keymap.set("v", "<A-Down>", "<A-j>", { remap = true, desc = "Move Down" })

-- Default ToggleTerm
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle Terminal" })
-- Press ESC twice to leave Terminal insert mode
vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], { noremap = true, silent = true, desc = "Exit terminal mode" })
-- Optional: Map <C-q> to leave terminal mode (or your preferred key)
vim.keymap.set("t", "<C-q>", [[<C-\><C-n>]], { noremap = true, silent = true, desc = "Exit terminal mode" })
