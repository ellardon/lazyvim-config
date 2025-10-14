-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.relativenumber = false

vim.g.maplocalleader = "," -- Change localleader
vim.opt.expandtab = false -- Use spaces instead of tabs
vim.opt.shiftwidth = 4 -- Number of spaces tabs count for
vim.opt.tabstop = 4 -- Number of spaces tabs count for
vim.opt.wrap = true -- Wrap lines by default

vim.g.clipboard = {
  name = "xclip",
  copy = {
    ["+"] = { "xclip", "-selection", "clipboard" },
    ["*"] = { "xclip", "-selection", "primary" },
  },
  paste = {
    ["+"] = { "xclip", "-selection", "clipboard", "-o" },
    ["*"] = { "xclip", "-selection", "primary", "-o" },
  },
  cache_enabled = 1,
}
