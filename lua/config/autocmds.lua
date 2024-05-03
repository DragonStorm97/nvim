-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- TEMP: this fixes blade.php files changing ft to html when switching between them

vim.api.nvim_create_autocmd({
	"BufEnter",
	--"BufWinEnter",
}, {
	pattern = { "*blade.php" },
	desc = "make sure blade files stay blade!",
	group = vim.api.nvim_create_augroup("BladeStayBlade", { clear = false }),
	callback = function(opts)
		vim.bo[opts.buf].filetype = "blade"
		-- vim.api.nvim_del_augroup_by_name("BladeStayBlade")
		-- to LspRestart to detach damn ltex, etc...
		-- vim.cmd("LspStop ltex")
		vim.cmd("LspRestart")
		-- vim.schedule(function()
		-- 	vim.cmd("LspStop ltex")
		-- end)
	end,
})
