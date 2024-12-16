local M = {}
local function i(s)
	vim.notify(vim.inspect(s))
end
local ts_utils = require("nvim-treesitter.utils")

local queries = {
	generic_word = [[
  (text
      (word) @generic_word)
  ]],
	generic_command = [[
(generic_command
    command: (command_name) @command_name
    arg: (curly_group
        (text
            (word) @command_word)))
  ]],
	generic_environment = [[
(generic_environment
    begin: (begin
        name: (curly_group_text
            (text
                (word) @env_name)))
    (text
        (word) @env_word))
  ]],
}

---This function actually counts words with treesitter.
M.count = function()
	local opts = require("wcount").config
	local bufnr = vim.api.nvim_get_current_buf()
	-- Get the language tree for the current buffer
	local parser = vim.treesitter.get_parser(bufnr)
	if not parser then
		vim.notify("no parser found")
		return nil
	end
	local ast = parser:parse()
	local root = ast[1]:root()
	--TODO: figure out how to exclude "irrelevant" nodes...
	--Might need a list of command names to exclude?
	--hmmm...
	local query = vim.treesitter.query.parse(
		"latex",
		[[
  (text
      (word) @generic_word)

  ;; Words in commands
  (generic_command
      command: (command_name) @command_name
      arg: (curly_group
          (text
              (word) @command_word)))

  ;; Words in environments
  (generic_environment
      begin: (begin
          name: (curly_group_text
              (text
                  (word) @env_name)))
      (text
          (word) @env_word))
  ]]
	)
	local words = {
		generic = {},
		command = {},
		environment = {},
		comment = {},
	}
	for id, node, metadata in query:iter_captures(root, bufnr) do
		local capture_name = query.captures[id]
		local word_text = vim.treesitter.get_node_text(node, bufnr)
		if capture_name == "generic_word" then
			table.insert(words.generic, word_text)
		elseif capture_name == "command_word" then
			table.insert(words.command, word_text)
		elseif capture_name == "env_word" or capture_name == "env_name" then
			table.insert(words.environment, word_text)
		elseif capture_name == "comment_word" then
			table.insert(words.comment, word_text)
		end
	end
	print(vim.inspect(words))
end

return M
