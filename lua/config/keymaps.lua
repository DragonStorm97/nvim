-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

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
--  open a quick git dif for current file
-- exists: <leader>ghd

-- Open spectre
vim.keymap.set("", "<leader>H", "<cmd>Spectre<cr>", { desc = "Open Spectre (Find and Replace)" })

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
vim.keymap.set("n", "<S-h>", "<C-Left>", { desc = "Move Cursor to start of Previous Word" })
--vim.keymap.set("i", "<C-h>", "<C-Left>", { desc = "Move Cursor to start of Previous Word" })
vim.keymap.set("n", "<S-l>", "<C-Right>", { desc = "Move Cursor to start of Next Word" })
--vim.keymap.set("i", "<C-l>", "<C-Right>", { desc = "Move Cursor to start of Next Word" })

vim.keymap.set("n", "<c-a>", "ggVG", { desc = "Select All" })

-- some ThePrimeagen maps:
-- move selected lines in Visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Lines Down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Lines Up" })
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
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to System Clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank to System Clipbaord" })
-- don't replace the paste register when deleting selected text
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete - Keep Register" })
-- <leader>F formats buffer
vim.keymap.set("n", "<leader>F", vim.lsp.buf.format, { desc = "Format Buffer" })
-- cycle through errors
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Go to Next Error" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Go To Previous Error" })
--vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
--vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
-- <leader>S will enter find and replace for the word you're over
vim.keymap.set("n", "<leader>S", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]], { desc = "Replace Word Under Cursor" })

-- list workspace symbols:
vim.keymap.set("n", "gs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Open Document [S]ymbols" })

-- harpoon keymaps:
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
vim.keymap.set("n", "<leader>ha", function()
	mark.add_file()
end, { desc = "[H]arpoon [A]dd" })
vim.keymap.set("n", "<leader>hr", function()
	mark.rm_file(vim.api.nvim_buf_get_name(0))
end, { desc = "[H]arpoon [R]emove" })
vim.keymap.set("n", "<leader>hp", function()
	ui.toggle_quick_menu()
end, { desc = "[P]review Menu" })
vim.keymap.set("n", "<leader>hh", "<CMD>Telescope harpoon marks<CR>", { desc = "h... Telescope Preview Menu" })
vim.keymap.set("n", "<leader>ht", "<CMD>Telescope harpoon marks<CR>", { desc = "[T]elescope Preview Menu" })
vim.keymap.set("n", "<leader>h1", function()
	ui.nav_file(1)
end, { desc = "[H]arpoon File 1" })
vim.keymap.set("n", "<leader>h2", function()
	ui.nav_file(2)
end, { desc = "[H]arpoon File 2" })
vim.keymap.set("n", "<leader>h3", function()
	ui.nav_file(3)
end, { desc = "[H]arpoon File 3" })
vim.keymap.set("n", "<leader>h4", function()
	ui.nav_file(4)
end, { desc = "[H]arpoon File 4" })
vim.keymap.set("n", "<leader>h5", function()
	ui.nav_file(5)
end, { desc = "[H]arpoon File 5" })
vim.keymap.set("n", "<leader>hn", function()
	ui.nav_prev()
end, { desc = "[H]arpoon: Previous File" })
vim.keymap.set("n", "<leader>hN", function()
	ui.nav_next()
end, { desc = "[H]arpoon: Next File" })

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
