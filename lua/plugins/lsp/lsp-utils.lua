local M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.foldingRange = {
	dynamicRegistration = true,
	lineFoldingOnly = true,
}

local AddKeymaps = function(buffnr, keys)
	for _, keymap in ipairs(keys) do
		local opts = keymap[3]
		opts.buffer = buffnr
		vim.keymap.set("n", keymap[1], keymap[2], opts)
	end
	-- Buffer local mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	-- local opts = { buffer = buffnr }
	-- TODO: add default lsp keymaps
	-- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
	-- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
	-- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
	-- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
	-- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
	-- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
	-- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
	-- vim.keymap.set('n', '<space>wl', function()
	--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	-- end, opts)
	-- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
	-- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
	-- vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
	-- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
end

M.AddKeymaps = AddKeymaps

M.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

M.setup = function()
	vim.diagnostic.config({
		virtual_text = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
		signs = true,
		underline = true,
		update_in_insert = true,
		severity_sort = false,
	})

	---- sign column
	-- local signs = { Error = "✖ ", Warn = "! ", Hint = "󰌶 ", Info = " " }

	local icons = require("lazyvim.config").icons
	local signs = {
		Error = icons.diagnostics.Error,
		Warn = icons.diagnostics.Warn,
		Hint = icons.diagnostics.Hint,
		Info = icons.diagnostics.Info,
	}

	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = function(desc)
		return { desc = desc, noremap = true, silent = true }
	end
	-- vim.keymap.set("n", "<leader>G", "<leader>G", {desc = "LSP"})
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts("Go to Decleration"))
	vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", bufopts("Go to Definition"))
	vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", bufopts("Find references"))
	vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", bufopts("Find Implemenations"))
	vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", bufopts("Find Type Definitions"))
	vim.keymap.set("n", "gK", vim.lsp.buf.hover, bufopts("Hover"))
	vim.keymap.set("n", "gk", vim.lsp.buf.signature_help, bufopts("Get Signature Help"))
	-- vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts("Add Workspace Folder"))
	-- vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts("Remove workspace Folder"))
	-- vim.keymap.set("n", "<leader>wl", function()
	-- 	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	-- end, bufopts("List Workspace Folders"))
	vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, bufopts("Rename"))
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts("Code Action"))
	-- show diagnostics in hover window
	-- 	vim.api.nvim_create_autocmd("CursorHold", {
	-- 		callback = function()
	-- 			local opts = {
	-- 				focusable = false,
	-- 				close_events = { "BufLeave", "CursorMoved", "InsertEnter" },
	-- 				border = "rounded",
	-- 				source = "always",
	-- 				prefix = " ",
	-- 				scope = "cursor",
	-- 			}
	-- 			vim.diagnostic.open_float(nil, opts)
	-- 		end,
	-- 	})
end

M.on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

return M
