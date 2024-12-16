-- local function test()
-- 	vim.cmd("source ~/dev/plugins/wcount.nvim/lua/wcount/init.lua")
-- 	vim.cmd("WcountTS")
-- end
-- vim.api.nvim_create_user_command("Wcount", test, {})
vim.api.nvim_create_user_command("WcountTS", require("wcount.count").count_latex, {})
