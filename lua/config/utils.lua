local M = {}

---Register a global internal keymap that wraps `rhs` to be repeatable.
-- requires tpope/vim-repeat
--[[ Example: If you want to make a keymap <leader>tc mapped to a lua function (or any keymap sequence string) repeatable:
    vim.keymap.set('n', '<leader>tc', make_repeatable_keymap('n', '<Plug>(ToggleComment)', function()
      -- the actual body (rhs) goes here: some complex logic that you want to repeat
    end, { remap = true })
    This will:
    Create an internal keymap <Plug>(ToggleComment) that does the job to make the internal keymap repeatable.
    Map <leader>tc to <Plug>(ToggleComment), which will execute the desired body (rhs).
    Note: Make sure you use { remap = true }.
--]]
---@param mode string|table keymap mode, see vim.keymap.set()
---@param lhs string lhs of the internal keymap to be created, should be in the form `<Plug>(...)`
---@param rhs string|function rhs of the keymap, see vim.keymap.set()
---@return string The name of a registered internal `<Plug>(name)` keymap. Make sure you use { remap = true }.
local make_repeatable_keymap = function(mode, lhs, rhs)
	vim.validate({
		mode = { mode, { "string", "table" } },
		rhs = { rhs, { "string", "function" }, lhs = { name = "string" } },
	})
	if not vim.startswith(lhs, "<Plug>") then
		error("`lhs` should start with `<Plug>`, given: " .. lhs)
	end
	vim.keymap.set(mode, lhs, function()
		rhs()
		vim.fn["repeat#set"](vim.api.nvim_replace_termcodes(lhs, true, true, true))
	end)
	return lhs
end

M.make_repeatable_keymap = make_repeatable_keymap

return M
