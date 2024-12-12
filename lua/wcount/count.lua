local M = {}

---@type table<string, boolean>
M.ft = {
	markdown = true,
	txt = true,
	tex = true,
}

---@type string
M.wc_cache = ""

---@param filter boolean?
function M.update_word_count(filter)
	local go = true
	if filter then
		go = M.ft[vim.bo.filetype]
	end
	local wc = vim.api.nvim_eval("wordcount()")
	if go then
		if wc["visual_words"] then
			M.wc_cache = "vw:" .. wc["visual_words"]
		else
			M.wc_cache = "w:" .. wc["words"]
		end
	else
		M.wc_cache = ""
	end
end

---Get current word count
---@return string
M.get_count = function()
	M.update_word_count()
	return M.wc_cache
end

return M
