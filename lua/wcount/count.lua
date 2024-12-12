local M = {}

---@type table<string, boolean>
M.ft = {
	markdown = true,
	txt = true,
	tex = true,
}

---@type string
M.wc_str_cache = ""

---@class CountCache
---@type table<CountType, integer?>
M.cache = {
	visual = nil,
	normal = nil,
}

---Check whether this file should be processed
---@return boolean
M.is_counted_file = function()
	return M.ft[vim.bo.filetype]
end

---@param filter boolean?
---@deprecated
function M.update_str_word_count(filter)
	local go = true
	if filter then
		go = M.ft[vim.bo.filetype]
	end
	local wc = vim.api.nvim_eval("wordcount()")
	if go then
		if wc["visual_words"] then
			M.wc_str_cache = "vw:" .. wc["visual_words"]
		else
			M.wc_str_cache = "w:" .. wc["words"]
		end
	else
		M.wc_str_cache = ""
	end
end

---@param filter boolean?
function M.update_cache(filter)
	if not filter or M.is_counted_file() then
		-- vim.notify("Counting...", vim.log.levels.DEBUG)
		local wc = vim.api.nvim_eval("wordcount()")
		if wc["visual_words"] then
			M.cache.visual = wc["visual_words"]
		end
		M.cache.normal = wc["words"]
	else
		M.cache.normal = nil
		M.cache.visual = nil
	end
end

---@alias CountType
---| 'visual'
---| 'normal'

---Return cache
---@return table<'normal'|'visual', integer?>
M.get_count_cache = function()
	M.update_cache()
	return M.cache
end

---Get current word count
---@param opt CountType
---@return integer?
M.get_word_count = function(opt)
	M.update_cache()
	if opt == "normal" then
		return M.cache.normal
	elseif opt == "visual" then
		return M.cache.visual
	end
end

return M
