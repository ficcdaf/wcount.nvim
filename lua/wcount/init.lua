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
	print("We are setting up with " .. vim.inspect(conf))
end

---Print the word count
M.print_count = function()
	local count = require("wcount.count")
	local c = count.get_count_cache()
	local out = "Normal: " .. tostring(c.normal) .. "\nVisual: " .. tostring(c.visual)
	vim.notify(out, vim.log.levels.INFO)
end

return M
