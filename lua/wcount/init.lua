---@class wcount
---@type table<string, function>
local M = {}
---@class WcountConfig
---@type table<string, any>
local config = {}

---Setup plugin with user config
---@param opts WcountConfig?
M.setup = function(opts)
	local conf = opts or {}
	print("We are setting up with " .. vim.inspect(opts))
end

---Print the word count
M.print_count = function()
	local c = require("wcount.count").get_count()
	vim.notify(c, vim.log.levels.INFO)
end

return M
