---@class wcount
local M = {}

---Default settings.
---@class WcountConfig
M.config = {
	file_types = {
		tex = true,
		markdown = true,
		other = false,
	},
	latex = {
		counter = "pandoc", -- "pandoc" | "texcount"
	},
}

---Setup plugin with user config
---@param opts WcountConfig?
M.setup = function(opts)
	M.config = vim.tbl_extend("force", M.config, opts or {})
end

---Print the word count
M.print_count = function()
	local count = require("wcount.count")
	local c = count.get_count_cache()
	local out = "Normal: " .. tostring(c.normal) .. "\nVisual: " .. tostring(c.visual)
	vim.notify(out, vim.log.levels.INFO)
end

return M
