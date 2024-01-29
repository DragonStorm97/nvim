local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		-- add LazyVim and import its plugins
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
		{ import = "lazyvim.plugins.extras.formatting.prettier" },
		{ import = "lazyvim.plugins.extras.lang.clangd" },
		{ import = "lazyvim.plugins.extras.lang.cmake" },
		{ import = "lazyvim.plugins.extras.lang.go" },
		{ import = "lazyvim.plugins.extras.lang.json" },
		{ import = "lazyvim.plugins.extras.lang.rust" },
		{ import = "lazyvim.plugins.extras.coding.yanky" },
		{ import = "lazyvim.plugins.extras.test.core" },
		{ import = "lazyvim.plugins.extras.lang.docker" },
		{ import = "lazyvim.plugins.extras.lang.typescript" },
		{ import = "lazyvim.plugins.extras.lsp.none-ls" },
		-- { import = "lazyvim.plugins.extras.ui.mini-animate" },

		{
			"folke/noice.nvim",
			event = "VeryLazy",
			opts = {
				-- add any options here
			},
			dependencies = {
				-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
				"MunifTanjim/nui.nvim",
				-- OPTIONAL:
				--   `nvim-notify` is only needed, if you want to use the notification view.
				--   If not available, we use `mini` as the fallback
				-- "rcarriga/nvim-notify",
			},
		},
		{ import = "plugins" },
		{
			"folke/tokyonight.nvim",
			lazy = true,
			-- opts = { style = "moon" },
			opts = { style = "night" },
		},
		{
			"catppuccin/nvim",
			dependencies = {
				"folke/noice.nvim",
			},
			-- lazy = true,
			lazy = false,
			name = "catppuccin",
			priority = 1000,
			opts = {
				integrations = {
					alpha = true,
					cmp = true,
					flash = true,
					gitsigns = true,
					illuminate = true,
					indent_blankline = { enabled = true },
					lsp_trouble = true,
					mason = true,
					mini = true,
					native_lsp = {
						enabled = true,
						underlines = {
							errors = { "undercurl" },
							hints = { "undercurl" },
							warnings = { "undercurl" },
							information = { "undercurl" },
						},
					},
					dap = {
						enabled = true,
						enable_ui = true, -- enable nvim-dap-ui
					},
					navic = { enabled = true, custom_bg = "lualine" },
					neotest = true,
					noice = true,
					notify = true,
					neotree = true,
					semantic_tokens = true,
					telescope = true,
					treesitter = true,
					hop = true,
					harpoon = true,
					lsp_saga = true,
					-- lualine = true,
					treesitter_context = true,
					ufo = true,
				},
			},
		},
		-- import/override with your plugins
		-- { import = "plugins" },
	},
	defaults = {
		-- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
		-- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
		lazy = false,
		-- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
		-- have outdated releases, which may break your Neovim install.
		version = false, -- always use the latest git commit
		-- version = "*", -- try installing the latest stable version for plugins that support semver
	},
	install = { colorscheme = { "catppuccin", "tokyonight", "habamax" } },
	checker = { enabled = true }, -- automatically check for plugin updates
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				-- "gzip",
				-- "matchit",
				-- "matchparen",
				-- "netrwPlugin",
				-- "tarPlugin",
				-- "tohtml",
				"tutor",
				-- "zipPlugin",
				"which_key",
			},
		},
	},
})

-- set colorscheme:
-- vim.cmd.colorscheme("tokyonight-moon")
vim.cmd.colorscheme("catppuccin-mocha")

vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- set the default shell:
-- NOTE: using powershell as the shell breaks rust run stuff :(
-- vim.opt.shell = "powershell"

require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all"
	ensure_installed = {
		"bash",
		"c",
		"cmake",
		"cpp",
		"css",
		"dockerfile",
		"git_config",
		"git_rebase",
		"gitattributes",
		"gitcommit",
		"gitignore",
		"go",
		"gomod",
		"gosum",
		"gowork",
		"graphql",
		"html",
		"http",
		"ini",
		"java",
		"javascript",
		"json",
		"json",
		"json5",
		"jsonc",
		"llvm",
		"lua",
		"make",
		"markdown",
		"markdown_inline",
		"ocaml",
		"python",
		"query",
		"regex",
		"ron",
		"rust",
		"scala",
		"toml",
		"typescript",
		"vim",
		"vimdoc",
		"xml",
		"yaml",
		"zig",
	},
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	autotag = {
		enable = true,
	},
})

-- WHY? this is needed for gopls, but rust, etc. works fine
-- require("lspconfig").gopls.setup({
-- 	cmd = { "gopls", "serve" },
-- 	filetypes = { "go", "gomod" },
-- 	root_dir = require("lspconfig/util").root_pattern("go.work", "go.mod", ".git"),
-- 	settings = {
-- 		gopls = {
-- 			analyses = {
-- 				unusedparams = true,
-- 			},
-- 			staticcheck = true,
-- 		},
-- 	},
-- })

-- require("lspconfig").clangd.setup({
-- 	cmd = { "gopls", "serve" },
-- 	filetypes = { "go", "gomod" },
-- 	root_dir = require("lspconfig/util").root_pattern("*.cpp", "*.h", ".git"),
-- 	settings = {
-- 		gopls = {
-- 			analyses = {
-- 				unusedparams = true,
-- 			},
-- 			staticcheck = true,
-- 		},
-- 	},
-- })
