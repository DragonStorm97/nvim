-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "i", "x", "v" }, "<S-down>", "<down>", { desc = "ONLY DOWN" })
vim.keymap.set({ "i", "x", "v" }, "<S-up>", "<up>", { desc = "ONLY UP" })

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
-- vim.keymap.set("n", "zR", require("ufo").openAllFolds, {
-- 	desc = "Open all Folds",
-- })
-- vim.keymap.set("n", "zM", require("ufo").closeAllFolds, {
-- 	desc = "Close all Folds",
-- })

-- Open Window Picker with ALT-W or <leader>wp
-- vim.keymap.set({ "i", "n", "v" }, "<M-w>", function()
-- 	local idx = require("window-picker").pick_window()
-- 	if idx ~= nil then
-- 		vim.api.nvim_set_current_win(idx)
-- 	end
-- end, { desc = "Pick Window" })
-- vim.keymap.set({ "n", "v" }, "<leader>wp", function()
-- 	local idx = require("window-picker").pick_window()
-- 	if idx ~= nil then
-- 		vim.api.nvim_set_current_win(idx)
-- 	end
-- end, { desc = "Pick Window" })

vim.keymap.set("", "<M-f>", "<Cmd>HopPattern<CR>", { desc = "Hop for Pattern" })

vim.keymap.set("", "<C-p>", function()
	require("telescope.builtin").find_files()
end, { desc = "Open File Picker" })

-- TODO?
-- macroscope is actually from neoclip, oh well
-- vim.keymap.set("n", "<leader>@", function()
-- 	require("telescope").extensions.macroscope.default()
-- end, { desc = "Open macroscope" })

-- telescope-undo:
vim.keymap.set("", "<leader>r", "<cmd>Telescope undo<cr>", { desc = "Open Undo History" })

-- telescope show notifies (nvim-notify):
vim.keymap.set("", "<leader>wn", "<cmd>Telescope notify<cr>", { desc = "Open Notifications" })
-- undotree
vim.keymap.set("", "<leader>Ru", "<CMD>UndotreeToggle<CR>", { desc = "Open Undotree" })

-- Glow Markdown
vim.keymap.set("", "<leader>md", "<cmd>Glow<cr>", { desc = "Open Glow Markdown Preview" })

-- open git fugitive
vim.keymap.set("", "<leader>gv", "<cmd>Git<cr>", { desc = "Open vim-fuGITive" })
vim.keymap.set("", "<leader>gD", "<cmd>DiffviewFileHistory<cr>", { desc = "[D]iffview" })
vim.keymap.set("", "<leader>gd", "<cmd>Gvdiffsplit<cr>", { desc = "[D]iff This" })
vim.keymap.set("", "<leader>ga", function()
	local curFile = vim.fn.expand("%:p")
	local cmd = "Git add " .. curFile
	vim.cmd(cmd)
	print("Staged: " .. curFile)
end, { desc = "[A]dd This File" })
vim.keymap.set("", "<leader>gu", function()
	local curFile = vim.fn.expand("%:p")
	local cmd = "Git restore --staged " .. curFile
	vim.cmd(cmd)
	print("Unstaged: " .. curFile)
end, { desc = "[U]nstage This File" })
vim.keymap.set("", "<leader>gr", function()
	local curFile = vim.fn.expand("%:p")
	vim.ui.input({
		prompt = "Confirm (y/n) revert " .. curFile,
	}, function(choice)
		if choice == "y" then
			local cmd = "Git restore " .. curFile
			vim.cmd(cmd)
			print("Reverted: " .. curFile)
		end
	end)
end, { desc = "[R]evert This File" })
vim.keymap.set("", "<leader>gC", function()
	vim.ui.input({ prompt = "Git Commit Message: " }, function(msg)
		if not msg then
			return
		end
		local results = vim.system({ "git", "commit", "-m", msg }, { text = true }):wait()

		if results.code ~= 0 then
			vim.notify(
				"Commit failed with the message: \n" .. vim.trim(results.stdout .. "\n" .. results.stderr),
				vim.log.levels.ERROR,
				{ title = "Commit" }
			)
		else
			vim.notify(results.stdout, vim.log.levels.INFO, { title = "Commit" })
		end
	end)
end, { desc = "[C]ommit" })
vim.keymap.set("", "<leader>gP", "<cmd>Git push<cr>", { desc = "[P]ush" })
vim.keymap.set("", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "[B]ranches" })
vim.keymap.set("", "<leader>gS", "<cmd>Git status<cr>", { desc = "[S]tatus" })

--  open a quick git dif for current file
-- exists: <leader>ghd

-- Open spectre
vim.keymap.set("", "<leader>rH", "<cmd>Spectre<cr>", { desc = "Open Spectre (Find and Replace)" })

-- ALT-Backspace or ALT-d for shortcut to delete previous word (can't use ctrl-BS as it maps to c-h in the terminal)
vim.keymap.set("i", "<M-BS>", "<Esc>dbi", { desc = "Delete Word Before Word Under Cursor" })
vim.keymap.set("n", "<M-BS>", "db", { desc = "Delete Word Before Word Under Cursor" })
vim.keymap.set("i", "<M-d>", "<Esc>dbi", { desc = "Delete Word Before Word Under Cursor" })
vim.keymap.set("n", "<M-d>", "db", { desc = "Delete Word Before Word Under Cursor" })

-- CTRL/ALT-delete for shortcut to delete word under cursor
vim.keymap.set("i", "<C-Del>", "<Esc>dwi", { desc = "Delete Word Under Cursor" })
vim.keymap.set("n", "<C-Del>", "dw", { desc = "Delete Word Under Cursor" })
vim.keymap.set("i", "<M-Del>", "<Esc>dwi", { desc = "Delete Word Under Cursor" })
vim.keymap.set("n", "<M-Del>", "dw", { desc = "Delete Word Under Cursor" })

-- CTRL-Enter to enter a new line without going into insert mode:
-- vim.keymap.set("n", "<CR>", "o<Esc>", { desc = "Add newline At EOL" })
-- can't do C-CR, it inserts <C-w>j; so rather not map it
-- vim.keymap.set("n", "<CR>j", "O<Esc>", { desc = "Add newline At EOL" })

-- add Shift-H/L for w/b shortcuts
-- vim.keymap.set("n", "<S-h>", "<C-Left>", { desc = "Move Cursor to start of Previous Word" })
--vim.keymap.set("i", "<C-h>", "<C-Left>", { desc = "Move Cursor to start of Previous Word" })
-- vim.keymap.set("n", "<S-l>", "<C-Right>", { desc = "Move Cursor to start of Next Word" })
--vim.keymap.set("i", "<C-l>", "<C-Right>", { desc = "Move Cursor to start of Next Word" })

-- vim.keymap.set("n", "<c-a>", "ggVG", { desc = "Select All" })

-- some ThePrimeagen maps:
-- move selected lines in Visual mode
-- removed because alt-j/k does this already! <M-j/k>
-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Lines Down" })
-- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Lines Up" })

-- return cursor back when usign line joining
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines, move cursor back" })
-- keep cursor in the middle when doing page jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll Up by Half a page, center screen" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll Down by Half a page, center screen" })
-- keep search-terms in the middle
vim.keymap.set("n", "n", "nzzzv", { desc = "Go to Next Match, Center Screen" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Go to Previous Match, Center Screen" })
-- when pasting over visually selected text, don't overwrite the paste register
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste - Keep register" })
-- next greatest remap ever : asbjornHaland
-- <leader>y yanks to system clipboard
-- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to System Clipboard" })
-- vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank to System Clipbaord" })

-- don't replace the paste register when deleting selected text
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete - Keep Register" })
-- <leader>F formats buffer
-- vim.keymap.set("n", "<leader>F", function()
-- 	vim.lsp.buf.format({ timeout_ms = 60000 })
-- end, { desc = "Format Buffer" })
-- cycle through errors
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Go to Next Error" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Go To Previous Error" })
--vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
--vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
-- <leader>S will enter find and replace for the word you're over
vim.keymap.set("n", "<leader>S", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]], { desc = "Replace Word Under Cursor" })
-- vim.keymap.set("x", "<leader>S", [[ry<cmd>%s/\<<C-r>r\>//gI<Left><Left><Left>]], { desc = "Replace Word Under Cursor" })

-- list workspace symbols:
vim.keymap.set("n", "gS", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Open Document [S]ymbols" })

-- harpoon2 telescope:
-- TODO: not sure if this should still be used?
vim.keymap.set("n", "<leader>0", "<cmd>Telescope harpoon marks<cr>", { desc = "Telescope Harpoon" })
-- TODO: this does mostly the same as the above but is from the harpoon2 docs... (pick one)
-- basic telescope configuration
local harpoon = require("harpoon")
local function toggle_telescope(harpoon_files)
	local conf = require("telescope.config").values
	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Harpoon",
			finder = require("telescope.finders").new_table({
				results = file_paths,
			}),
			previewer = conf.file_previewer({}),
			sorter = conf.generic_sorter({}),
		})
		:find()
end

vim.keymap.set("n", "<C-e>", function()
	toggle_telescope(harpoon:list())
end, { desc = "Open harpoon window" })

-- Toggle TreesitterContext
vim.keymap.set("n", "<leader>cC", "<cmd>TSContextToggle<cr>", { desc = "Toggle TS Context" })

-- refactoring: (ThePrimagen/refactoring.nvim)
-- TODO: maybe prefix all these with "e" (extract) so its <leader>Re$?
-- vim.keymap.set("x", "<leader>Rf", function() require('refactoring').refactor('Extract Function') end, {desc = "Extract Function"})
-- vim.keymap.set("x", "<leader>RF", function() require('refactoring').refactor('Extract Function To File') end,{desc = "Extract Function To File"})
vim.keymap.set("x", "<leader>Rf", ":Refactor extract ", { desc = "Extract Function" })
vim.keymap.set("x", "<leader>RF", ":Refactor extract_to_file ", { desc = "Extract Function To File" })
-- Extract function supports only visual mode
-- vim.keymap.set("x", "<leader>Rv", function() require('refactoring').refactor('Extract Variable') end, {desc = "Extract Variable"})
vim.keymap.set("x", "<leader>Rv", ":Refactor extract_var ", { desc = "Extract Variable" })
-- Extract variable supports only visual mode
-- vim.keymap.set({ "n", "x" }, "<leader>Ri", function() require('refactoring').refactor('Inline Variable') end, {desc = "Inline Variable"})
vim.keymap.set({ "n", "x" }, "<leader>Ri", ":Refactor inline_var", { desc = "Inline Variable" })
-- Inline var supports both normal and visual mode
-- vim.keymap.set("n", "<leader>Rb", function() require('refactoring').refactor('Extract Block') end, {desc = "Extract Block"})
-- vim.keymap.set("n", "<leader>RB", function() require('refactoring').refactor('Extract Block To File') end, {desc = "Extract Block To File"})
vim.keymap.set("n", "<leader>Rb", ":Refactor extract_block", { desc = "Extract Block" })
vim.keymap.set("n", "<leader>RB", ":Refactor extract_block_to_file", { desc = "Extract Block To File" })
-- Extract block supports only normal mode

-- alternative blockwise visual mode (replace C-v with M-v):
vim.keymap.set({ "n", "v" }, "<M-v>", "<C-v>", { desc = "Blockwise Visual Mode" })

-- Trouble prev/next bindings TODO: move somewhere else
vim.keymap.set({ "n", "v" }, "]T", function()
	require("trouble").next({ skip_groups = true, jump = true })
end, { desc = "[t]rouble Next" })
vim.keymap.set({ "n", "v" }, "[T", function()
	require("trouble").previous({ skip_groups = true, jump = true })
end, { desc = "[t]rouble Previous" })

-- general telescope binding:
vim.keymap.set({ "n", "v" }, "<leader>T", "<cmd>Telescope<cr>", { desc = "Open [Telesecope]" })

-- diagnostic mappings:
vim.keymap.set({ "n", "v" }, "<leader>C", vim.diagnostic.open_float, { desc = "Open Diagnostic Float" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to Previous Diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to Next Diagnostic" })

vim.keymap.set("v", "<c-C>", "y", { desc = "CTRL+C yanks in visual mode" })
