-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = false
vim.g.maplocalleader = "," -- Change localleader
-- Copilot proxy and URL configuration
vim.g.copilot_proxy = "http://gateway.zscloud.net:9480"
vim.g.copilot_proxy_strict_ssl = true
vim.g.copilot_enterprise_url = "https://vector.ghe.com"
-- Activate auto-wrp
vim.opt.wrap = true
