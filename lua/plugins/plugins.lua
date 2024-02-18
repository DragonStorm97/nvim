return {
	{
		"tpope/vim-repeat",
	},
	{
		-- shows colours for colour codes in code
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({ "*" }, {})
		end,
	},
	{
		"tpope/vim-fugitive",
	},
	{
		"ThePrimeagen/harpoon",
	},
	{
		-- changes colours depending on mode and motion
		-- TODO: customise the colours to my preferences (mostly just want to change visual mode colour)
		"rasulomaroff/reactive.nvim",
		opts = {
			builtin = {
				cursorline = true,
				cursor = true,
				modemsg = true,
			},
		},
	},
	{
		-- filetree with some nice shortcuts, and views
		"nvim-neo-tree/neo-tree.nvim",
		-- branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			"tpope/vim-fugitive",
			"ThePrimeagen/harpoon",
		},
		config = function()
			require("neo-tree").setup({
				window = {
					mappings = {
						["gd"] = "show_diff",
						["gA"] = "git_add_all",
						["gu"] = "git_unstage_file",
						["ga"] = "git_add_file",
						["gr"] = "git_revert_file",
						["gc"] = "git_commit",
						["gp"] = "git_push",
						["gg"] = "git_commit_and_push",
						[";"] = "harpoon_toggle",
					},
				},
				filesystem = {
					components = {
						harpoon_index = function(config, node, state)
							local Marked = require("harpoon.mark")
							local utils = require("harpoon.utils")
							local abs_path = node.path
							local norm_path = utils.normalize_path(abs_path)
							-- fix for m$ paths:
							-- local rel_path = vim.fn.fnamemodify(abs_path, ":~:.")
							-- local path = string.gsub(rel_path, "\\", "/")
							local path = norm_path
							local succuss, index = pcall(Marked.get_index_of, path)
							if succuss and index and index > 0 then
								return {
									text = string.format(" ⥤ %d", index), -- <-- Add your favorite harpoon like arrow here
									highlight = config.highlight or "NeoTreeDirectoryIcon",
								}
							else
								return {}
							end
						end,
					},
					renderers = {
						file = {
							{ "icon" },
							{ "name", use_git_status_colors = true },
							{ "harpoon_index", align = "left" }, --> This is what actually adds the component in where you want it
							{ "modified", zindex = 20, align = "right" },
							{ "diagnostics", zindex = 20, align = "right" },
							{ "git_status", zindex = 20, align = "right" },
						},
					},
					commands = {
						show_diff = function(state)
							-- some variables. use any if you want
							local node = state.tree:get_node()
							-- local abs_path = node.path
							-- local rel_path = vim.fn.fnamemodify(abs_path, ":~:.")
							-- local file_name = node.name
							local is_file = node.type == "file"
							if not is_file then
								vim.notify("Diff only for files", vim.log.levels.ERROR)
								return
							end
							-- open file
							local cc = require("neo-tree.sources.common.commands")
							cc.open(state, function()
								-- do nothing for dirs
							end)

							-- I recommend using one of below to show the diffs
							-- Raw vim
							-- git show ...: change arg as you want
							-- @: current file vs git head
							-- @^: current file vs previous commit
							-- @^^^^: current file vs 4 commits before head and so on...
							-- 		vim.cmd([[
							-- !git show @^:% > /tmp/%
							-- vert diffs /tmp/%
							-- ]])
							-- Fugitive
							-- vim.cmd([[Gdiffsplit]]) -- or
							-- vim.cmd([[Ghdiffsplit]]) -- or
							vim.cmd([[Gvdiffsplit]])
						end,
						harpoon_toggle = function(state)
							local node = state.tree:get_node()
							local mark = require("harpoon.mark")
							local utils = require("harpoon.utils")
							local abs_path = node.path
							local norm_path = utils.normalize_path(abs_path)

							-- fix for m$ paths:
							-- local rel_path = vim.fn.fnamemodify(abs_path, ":~:.")

							-- local path = string.gsub(rel_path, "\\", "/")
							mark.toggle_file(norm_path)
						end,
					},
				},
				git_status = {
					window = {
						position = "float",
						mappings = {
							["A"] = "git_add_all",
							["gu"] = "git_unstage_file",
							["ga"] = "git_add_file",
							["gr"] = "git_revert_file",
							["gc"] = "git_commit",
							["gp"] = "git_push",
							["gg"] = "git_commit_and_push",
						},
					},
				},
			})
		end,
	},
	{
		"hedyhli/outline.nvim",
		lazy = true,
		cmd = { "Outline", "OutlineOpen" },
		keys = { { "<leader>cs", "<cmd>Outline<cr>", desc = "Symbols Outline" } },
		config = true,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"folke/noice.nvim",
		},
		event = "VeryLazy",
		opts = function()
			local icons = require("lazyvim.config").icons
			local Util = require("lazyvim.util")

			return {
				options = {
					theme = "auto",
					globalstatus = true,
					disabled_filetypes = { statusline = { "dashboard", "alpha" } },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },
					lualine_c = {
						{
							"diagnostics",
							symbols = {
								error = icons.diagnostics.Error,
								warn = icons.diagnostics.Warn,
								info = icons.diagnostics.Info,
								hint = icons.diagnostics.Hint,
							},
						},
						{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
						{ "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
            -- stylua: ignore
            {
              function() return require("nvim-navic").get_location() end,
              cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
            },
					},
					lualine_x = {
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = Util.ui.fg("Statement"),
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = Util.ui.fg("Constant"),
            },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = Util.ui.fg("Debug"),
            },
						{
							require("lazy.status").updates,
							cond = require("lazy.status").has_updates,
							color = Util.ui.fg("Special"),
						},
						{
							"diff",
							symbols = {
								added = icons.git.added,
								modified = icons.git.modified,
								removed = icons.git.removed,
							},
						},
					},
					lualine_y = {
						{ "progress", separator = " ", padding = { left = 1, right = 0 } },
						{ "location", padding = { left = 0, right = 1 } },
					},
					lualine_z = {
						function()
							return " " .. os.date("%R")
						end,
					},
				},
				extensions = { "neo-tree", "lazy" },
			}
		end,
	},
	{
		--  provides better comments, and motion-enabled comments (as well as block vs. line style comments)
		"numToStr/Comment.nvim",
		opts = {
			-- add any options here
			toggler = {
				line = "gcc",
				block = "gcb",
			},
		},
		lazy = false,
		config = function(_, opts)
			require("Comment").setup(opts)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, {
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
				})
				opts.auto_install = true
				opts.highlight.enable = true
				opts.highlight.additional_vim_regex_highlighting = false
				opts.indent.enable = true
				opts.incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "\\",
						node_incremental = "\\",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				}
			end
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		-- version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		-- build = "make install_jsregexp",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	-- {
	-- 	"nvimtools/none-ls.nvim",
	-- 	opts = function(_, opts)
	-- 		local nls = require("none-ls.nvim")
	-- 		table.insert(opts.sources, nls.builtins.formatting.prettierd)
	-- 		if type(opts.sources) == "table" then
	-- 			vim.list_extend(opts.sources, {
	-- 				nls.builtins.code_actions.gomodifytags,
	-- 				nls.builtins.code_actions.impl,
	-- 				nls.builtins.formatting.gofumpt,
	-- 				nls.builtins.formatting.goimports_reviser,
	-- 				nls.builtins.diagnostics.cmake_lint,
	-- 				-- nls.builtins.code_actions.ltrs,
	-- 				-- nls.builtins.formatting.stylua,
	-- 				-- nls.builtins.code_actions.gitsigns,
	-- 				-- nls.builtins.code_actions.proselint, --TODO:
	-- 				nls.builtins.completion.luasnip,
	-- 				-- nls.builtins.completion.spell,
	-- 				-- nls.builtins.completion.tags,
	-- 				-- nls.builtins.diagnostics.buf,
	-- 				-- nls.builtins.diagnostics.codespell, -- TODO:
	-- 			})
	-- 		end
	-- 	end,
	-- },
	{
		"Civitasv/cmake-tools.nvim",
		-- opts = {},
		config = function()
			require("cmake-tools").setup({
				cmake_command = "cmake", -- this is used to specify cmake command path
				cmake_regenerate_on_save = true, -- auto generate when save CMakeLists.txt
				cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" }, -- this will be passed when invoke `CMakeGenerate`
				cmake_build_options = {}, -- this will be passed when invoke `CMakeBuild`
				-- support macro expansion:
				--       ${kit}
				--       ${kitGenerator}
				--       ${variant:xx}
				cmake_build_directory = "out/${variant:buildType}", -- this is used to specify generate directory for cmake, allows macro expansion
				cmake_soft_link_compile_commands = true, -- this will automatically make a soft link from compile commands file to project root dir
				cmake_compile_commands_from_lsp = false, -- this will automatically set compile commands file location using lsp, to use it, please set `cmake_soft_link_compile_commands` to false
				cmake_kits_path = nil, -- this is used to specify global cmake kits path, see CMakeKits for detailed usage
				cmake_variants_message = {
					short = { show = true }, -- whether to show short message
					long = { show = true, max_length = 40 }, -- whether to show long message
				},
				cmake_dap_configuration = { -- debug settings for cmake
					name = "cpp",
					type = "codelldb",
					request = "launch",
					stopOnEntry = false,
					runInTerminal = true,
					console = "integratedTerminal",
				},
				-- TODO: use a different executor than quickfix
				cmake_executor = { -- executor to use
					name = "quickfix", -- name of the executor
					opts = {}, -- the options the executor will get, possible values depend on the executor type. See `default_opts` for possible values.
					default_opts = { -- a list of default and possible values for executors
						quickfix = {
							show = "always", -- "always", "only_on_error"
							position = "belowright", -- "bottom", "top"
							size = 10,
						},
						overseer = {
							new_task_opts = {}, -- options to pass into the `overseer.new_task` command
							on_new_task = function(task) end, -- a function that gets overseer.Task when it is created, before calling `task:start`
						},
						terminal = {}, -- terminal executor uses the values in cmake_terminal
					},
				},
				cmake_terminal = {
					name = "terminal",
					opts = {
						name = "Main Terminal",
						prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
						split_direction = "horizontal", -- "horizontal", "vertical"
						split_size = 11,

						-- Window handling
						single_terminal_per_instance = true, -- Single viewport, multiple windows
						single_terminal_per_tab = true, -- Single viewport per tab
						keep_terminal_static_location = true, -- Static location of the viewport if avialable

						-- Running Tasks
						start_insert_in_launch_task = false, -- If you want to enter terminal with :startinsert upon using :CMakeRun
						start_insert_in_other_tasks = false, -- If you want to enter terminal with :startinsert upon launching all other cmake tasks in the terminal. Generally set as false
						focus_on_main_terminal = false, -- Focus on cmake terminal when cmake task is launched. Only used if executor is terminal.
						focus_on_launch_terminal = false, -- Focus on cmake launch terminal when executable target in launched.
					},
				},
				cmake_notifications = {
					enabled = true, -- show cmake execution progress in nvim-notify
					spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }, -- icons used for progress display
					refresh_rate_ms = 100, -- how often to iterate icons
				},
			})
		end,
		-- event = "BufRead",
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{
				"Saecki/crates.nvim",
				-- event = { "BufRead Cargo.toml" },
				-- config = true,
			},
			{ "neovim/nvim-lspconfig" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lsp-document-symbol" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "hrsh7th/cmp-buffer" },
			-- { "FelipeLema/cmp-async-path" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "f3fora/cmp-spell" },
			{ "uga-rosa/cmp-dictionary" },
		},
		config = function()
			local cmp = require("cmp")

			local types = require("cmp.types")
			local LSP_TYPES = {
				types.lsp.CompletionItemKind.Method,
				types.lsp.CompletionItemKind.Field,
				types.lsp.CompletionItemKind.Property,
				types.lsp.CompletionItemKind.Function,
			}

			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			local luasnip = require("luasnip")

			local function tab(fallback)
				if cmp.visible() then
					if #cmp.get_entries() == 1 then
						cmp.confirm({ select = true })
					else
						cmp.select_next_item()
					end
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				elseif has_words_before() then
					cmp.complete()
				else
					-- F("<Tab>")
					fallback()
				end
			end

			local function shtab(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					-- F('<S-Tab>')
					fallback()
				end
			end

			local function enterit(fallback)
				if cmp.visible() and cmp.get_selected_entry() then
					cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
				elseif cmp.visible() then
					cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
				elseif has_words_before() then
					cmp.complete()
				else
					-- F("<CR>")
					fallback()
				end
			end
			vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
			cmp.setup({
				-- enabled = true,
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				preselect = cmp.PreselectMode.Item,
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				formatting = {
					--- @type cmp.ItemField[]
					fields = {
						"kind",
						"abbr",
						"menu",
					},
					format = function(entry, vim_item)
						local icons = require("lazyvim.config").icons.kinds
						if icons[vim_item.kind] then
							vim_item.kind = icons[vim_item.kind] .. vim_item.kind
						end
						vim_item.menu = ({
							nvim_lsp = "[LSP]",
							nvim_lsp_signature_help = "[LSP-Sig]",
							nvim_lua = "[nvim]",
							emoji = "[emoji]",
							path = "[path]",
							Crates = "[Crates]",
							calc = "[calc]",
							cmp_git = "[git]",
							cmp_tabnine = "[tab9]",
							vsnip = "[snip]",
							luasnip = "[snip]",
							buffer = "[buf]",
							fzy_buffer = "[fzbuf]",
							fuzzy_path = "[fzpath]",
							dictionary = "[dict]",
							spell = "[spell]",
							cmdline = "[cmd]",
							cmdline_history = "[cmd-hist]",
						})[entry.source.name]
						vim_item.dup = ({
							buffer = 1,
							path = 1,
							nvim_lsp = 0,
						})[entry.source.name] or 0
						return vim_item
					end,
				},
				mapping = {
					["<C-f>"] = cmp.mapping.scroll_docs(-4),
					["<C-b>"] = cmp.mapping.scroll_docs(4),
					["<CR>"] = cmp.mapping({
						i = function(fallback)
							if cmp.visible() and cmp.get_active_entry() then
								cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
							else
								fallback()
							end
						end,
						s = cmp.mapping.confirm({ select = true }),
						-- c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
					}),
					["<C-Space>"] = cmp.mapping(enterit, { "i", "s" }),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(tab, { "i", "s", "c" }),
					["<S-Tab>"] = cmp.mapping(shtab, { "i", "s", "c" }),
					["<Down>"] = cmp.mapping.select_next_item(), --cmp.mapping(tab, { "i", "s", "c" }),
					["<Up>"] = cmp.mapping(shtab, { "i", "s" }),
				},
				sources = cmp.config.sources({
					{ name = "nvim_lua" },
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "crates" },
					{ name = "path" },
					{ name = "luasnip" },
					{ name = "buffer", keyword_length = 3 },
					-- { name = "vsnip" }, -- For vsnip users.
				}, {
					-- { name = "buffer", keyword_length = 3 },
					-- { name = "buffer" },
				}),
				experimental = {
					ghost_text = {
						hl_group = "CmpGhostText",
					},
				},
				sorting = {
					comparators = {
						--- Always rank snippets below methods and fields.
						--- @param e1 cmp.Entry
						--- @param e2 cmp.Entry
						--- @return boolean|nil
						function(e1, e2)
							local e1_kind = e1:get_kind()
							local e2_kind = e2:get_kind()
							if e1_kind == e2_kind then
								return nil
							end
							if
								e1_kind ~= types.lsp.CompletionItemKind.Snippet
								and e2_kind ~= types.lsp.CompletionItemKind.Snippet
							then
								return nil
							end
							if vim.tbl_contains(LSP_TYPES, e1_kind) then
								return true
							elseif vim.tbl_contains(LSP_TYPES, e2_kind) then
								return false
							end
							return nil
						end,
						require("clangd_extensions.cmp_scores"),
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						cmp.config.compare.score,
						cmp.config.compare.recently_used,
						cmp.config.compare.locality,
						cmp.config.compare.kind,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},
			})

			-- cmp plugin
			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "cmp_git" },
					{ name = "nvim_lsp" },
					{ name = "nvim_lua" },
					{ name = "nvim_lsp_document_symbol" },
					{ name = "buffer" },
					{ name = "dictionary" },
					{ name = "spell" },
					{ name = "path" },
				}),
			})

			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_document_symbol" },
					{ name = "dictionary" },
					{ name = "buffer" },
				},
			})

			---@type cmp.ConfigSchema
			cmp.setup.cmdline(":", {
				completion = {
					autocomplete = { "InsertEnter" },
				},
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "cmdline" },
					{ name = "path", options = { trailing_slash = true, label_trailing_slash = true } },
					{ name = "dictionary" },
					{ name = "buffer" },
				}),
			})
		end,
		---@param opts cmp.ConfigSchema
		opts = function(_, opts)
			local cmp = require("cmp")
			-- opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {}))
		end,
	},
	-- provides some usefull textobjects like gC for comments
	-- TODO: remove this as mini.ai should do so already?
	{
		"chrisgrieser/nvim-various-textobjs",
		lazy = false,
		keys = {
			{
				"gC",
				"<cmd>lua require('various-textobjs').multiCommentedLines()<CR>",
				mode = { "o", "x" },
				desc = "text-object multiCommentedLines",
			},
		},
		opts = { useDefaultKeymaps = true, disabledKeymaps = { "gc" } },
	},
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {},
		config = function()
			vim.keymap.set(
				{ "n", "x", "v" },
				"<leader>Rs",
				function()
					require("telescope").extensions.refactoring.refactors()
				end,
				-- function() require('refactoring').select_refactor() end,
				{ desc = "Select Refactoring" }
			)
			vim.keymap.set({ "n", "x", "v" }, "<leader>R", "<leader>R", { desc = "+Refactoring" })
			require("refactoring").setup({
				-- prompt for return type
				prompt_func_return_type = {
					go = true,
					java = true,

					cpp = true,
					c = true,
					h = true,
					hpp = true,
					cxx = true,
				},
				-- prompt for function parameters
				prompt_func_param_type = {
					go = true,
					java = true,

					cpp = true,
					c = true,
					h = true,
					hpp = true,
					cxx = true,
				},
			})
		end,
	},
	--{ "kkharji/sqlite.lua", module = "sqlite" },
	-- {
	-- 	"s1n7ax/nvim-window-picker",
	-- 	name = "window-picker",
	-- 	event = "VeryLazy",
	-- 	version = "2.*",
	-- 	config = function()
	-- 		require("window-picker").setup({
	-- 			hint = "floating-big-letter",
	-- 			-- hint = "statusline-winbar",
	-- 			--
	-- 			-- following filters are only applied when you are using the default filter
	-- 			-- defined by this plugin. If you pass in a function to "filter_func"
	-- 			-- property, you are on your own
	-- 			filter_rules = {
	-- 				-- when there is only one window available to pick from, use that window
	-- 				-- without prompting the user to select
	-- 				autoselect_one = true,
	--
	-- 				-- whether you want to include the window you are currently on to window
	-- 				-- selection or not
	-- 				include_current_win = true,
	--
	-- 				-- filter using buffer options
	-- 				bo = {
	-- 					-- if the file type is one of following, the window will be ignored
	-- 					-- filetype = { 'NvimTree', 'neo-tree', 'notify' },
	--
	-- 					filetype = { "notify", "edgy" },
	-- 					-- if the file type is one of following, the window will be ignored
	-- 					-- buftype = { 'terminal' },
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.2",
		lazy = false,
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "debugloop/telescope-undo.nvim" },
			{ "ThePrimeagen/refactoring.nvim" },
			-- TODO: install fzf to do this
			-- {
			-- 	"nvim-telescope/telescope-fzf-native.nvim",
			-- 	build = "make",
			-- 	config = function()
			-- 		require("telescope").load_extension("fzf")
			-- 	end,
			-- },
		},
		keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fP",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
		},

		config = function()
			require("telescope").setup({
				extensions = {
					undo = {
						-- add undo config
						side_by_side = true,
						layout_strategy = "vertical",
						layout_config = {
							preview_height = 0.7,
						},
					},
				},
				defaults = {
					file_ignore_patterns = {
						"^.cache/*",
						"^.git/*",
						"node_modules/*",
					},
				},
			})
			require("telescope").load_extension("undo")
			require("telescope").load_extension("refactoring")
		end,
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
	{
		"wintermute-cell/gitignore.nvim",
		enabled = true,
		lazy = false,
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			local gitignore = require("gitignore")
			vim.keymap.set("n", "<leader>gi", function()
				gitignore.generate(vim.fn.getcwd())
			end, { desc = "Update git [I]gnore" })
		end,
	},
	{
		-- folding! TODO: comment folding?
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = "VimEnter",
		opts = {
			filetype_exclude = {
				"help",
				"alpha",
				"dashboard",
				"neo-tree",
				"Trouble",
				"lazy",
				"mason",
				"lualine",
				"statusline",
			},
		},
		config = function(_, opts)
			-- make-pretty function
			local handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = (" 󰁃 %d "):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end

			-- auto-detach from buggers we don't want to handle!
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("local_detach_ufo", { clear = true }),
				pattern = opts.filetype_exclude,
				callback = function()
					-- print("exiting ufo because in one of these" .. vim.inspect(opts.filetype_exclude))
					require("ufo").detach()
					vim.opt_local.foldenable = false
					-- vim.wo.foldcolun = "0"
				end,
			})

			vim.opt.foldlevelstart = 99

			local ftMap = {
				vim = "indent",
				python = { "indent" },
				git = "",
			}
			-- local opts = function(str)
			-- 	return { desc = str, noremap = false, silent = true }
			-- end
			-- local keymap = vim.keymap.set
			--Folds
			-- TODO: use whichkey / add descriptions
			-- keymap("n", "zR", require("ufo").openAllFolds, opts("Open All Folds"))
			-- keymap("n", "zM", require("ufo").closeAllFolds, opts("Close All Folds"))
			-- keymap("n", "zr", require("ufo").openFoldsExceptKinds, opts("Open FOlds Except Kinds"))
			-- keymap("n", "zm", require("ufo").closeFoldsWith, opts("Close Folds With"))
			-- keymap("n", "zk", function()
			-- 	local winid = require("ufo").peekFoldedLinesUnderCursor()
			-- 	if not winid then
			-- 		vim.lsp.buf.hover()
			-- 	end
			-- end, { desc = "Peak Folded Lines Under Cursor" })

			require("ufo").setup({
				enable_get_fold_virt_text = true,
				fold_virt_text_handler = handler,
				open_fold_hl_timeout = 150,
				close_fold_kinds = { "imports", "comment" },

				preview = {
					win_config = {
						border = { "", "─", "", "", "", "─", "", "" },
						winhighlight = "Normal:Folded",
						winblend = 0,
					},
					mappings = {
						scrollU = "<C-u>",
						scrollD = "<C-d>",
					},
				},
				-- TODO: try and setup lsp capabilities for folding instead
				-- provider_selector = function(bufnr, filetype, buftype)
				-- 	return ftMap[filetype] or { "treesitter", "indent" }
				-- end,
			})
		end,
	},
	-- TODO: do I want hop?
	{
		"phaazon/hop.nvim",
		branch = "v2", -- optional but strongly recommended
		config = function()
			-- you can configure Hop the way you like here; see :h hop-config
			require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		enabled = true,
		lazy = false,
		cmd = "TSContextToggle",
		-- config = function()
		-- 	require("nvim-treesitter-context").setup({})
		-- end,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		-- shows the AST for the file
		"nvim-treesitter/playground",
		cmd = "TSPlayground",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"epwalsh/obsidian.nvim",
		-- lazy = true,
		--event = { "BufReadPre path/to/my-vault/**.md" },
		-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand':
		-- TODO: add ObsidianMasterVault as environment var
		-- event = { "BufReadPre " .. vim.fn.expand("~") .. "/OneDrive/ObsidianMasterVault" },
		event = { "BufReadPre *.md" },
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{
				"<leader>mf",
				"<cmd>ObsidianFollowLink<cr>",
				desc = "Obsidian Go To file",
			},
			{
				"<leader>mr",
				"<cmd>ObsidianBacklinks<cr>",
				desc = "Obsidian List References",
			},
			{
				"<leader>mq",
				"<cmd>ObsidianQuickSwitch<cr>",
				desc = "Obsidian List Notes",
			},
			{
				"<leader>ms",
				"<cmd>ObsidianSearch<cr>",
				desc = "Obsidian Search Notes",
			},
		},
		config = function()
			require("obsidian").setup({
				-- dir = "~/OneDrive/ObsidianMasterVault", -- no need to call 'vim.fn.expand' here
				-- Optional, key mappings.
				mappings = {
					-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
					-- ["mf"] = require("obsidian.mapping").gf_passthrough(),
				},
				finder = "telescope.nvim",
			})
		end,
	},
	{
		-- a markdown previewer
		"ellisonleao/glow.nvim",
		config = function()
			local ok, mason_registry = pcall(require, "mason-registry")
			if ok then
				local glow_pkg = mason_registry.get_package("glow")
				local glow_path = glow_pkg:get_install_path()
				require("glow").setup({
					-- NOTE: rather ensure glow is in path
					-- install_path = "C:/ProgramData/chocolatey/lib/glow/tools",
					install_path = glow_path,
				})
			end
		end,
		cmd = "Glow",
	},
	{
		-- TODO: undotree isn't working (also, give it a keybind)
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		enabled = true,
	},
	{
		"ray-x/go.nvim",
		dependencies = { -- optional packages
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup()
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	},
	{ "rouge8/neotest-rust" },
	{ "nvim-neotest/neotest-go" },
	{
		"nvim-neotest/neotest",
		optional = true,
		dependencies = {
			"nvim-neotest/neotest-go",
			"rouge8/neotest-rust",
		},
		opts = {
			adapters = {
				["neotest-go"] = {
					-- Here we can set options for neotest-go, e.g.
					-- args = { "-tags=integration" }
				},
				["neotest-rust"] = {},
			},
			status = { virtual_text = true },
			output = { open_on_run = true },
			quickfix = {
				open = function()
					if require("lazyvim.util").has("trouble.nvim") then
						vim.cmd("Trouble quickfix")
					else
						vim.cmd("copen")
					end
				end,
			},
		},
		config = function(_, opts)
			local neotest_ns = vim.api.nvim_create_namespace("neotest")
			vim.diagnostic.config({
				virtual_text = {
					format = function(diagnostic)
						-- Replace newline and tab characters with space for more compact diagnostics
						local message =
							diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
						return message
					end,
				},
			}, neotest_ns)

			if opts.adapters then
				local adapters = {}
				for name, config in pairs(opts.adapters or {}) do
					if type(name) == "number" then
						if type(config) == "string" then
							config = require(config)
						end
						adapters[#adapters + 1] = config
					elseif config ~= false then
						local adapter = require(name)
						if type(config) == "table" and not vim.tbl_isempty(config) then
							local meta = getmetatable(adapter)
							if adapter.setup then
								adapter.setup(config)
							elseif meta and meta.__call then
								adapter(config)
							else
								error("Adapter " .. name .. " does not support setup")
							end
						end
						adapters[#adapters + 1] = adapter
					end
				end
				opts.adapters = adapters
			end

			require("neotest").setup(opts)
		end,
    -- stylua: ignore
    keys = {
      {
        "<leader>tt",
        function() require("neotest").run.run(vim.fn.expand("%")) end,
        desc = "Run File"
      },
      {
        "<leader>tT",
        function() require("neotest").run.run(vim.loop.cwd()) end,
        desc = "Run All Test Files"
      },
      {
        "<leader>tr",
        function() require("neotest").run.run() end,
        desc = "Run Nearest"
      },
      {
        "<leader>ts",
        function() require("neotest").summary.toggle() end,
        desc = "Toggle Summary"
      },
      {
        "<leader>to",
        function() require("neotest").output.open({ enter = true, auto_close = true }) end,
        desc = "Show Output"
      },
      {
        "<leader>tO",
        function() require("neotest").output_panel.toggle() end,
        desc = "Toggle Output Panel"
      },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
    },
	},
	{
		"mfussenegger/nvim-dap",
		optional = false,
		dependencies = {
			{
				-- Ensure C/C++ debugger is installed
				"williamboman/mason.nvim",
				optional = true,
				opts = function(_, opts)
					opts.ensure_installed = opts.ensure_installed or {}
					vim.list_extend(
						opts.ensure_installed,
						{ "gomodifytags", "impl", "gofumpt", "goimports-reviser", "delve", "codelldb" }
					)
				end,
			},
			{
				"leoluz/nvim-dap-go",
				config = true,
			},
			-- fancy UI for the debugger
			{
				"rcarriga/nvim-dap-ui",
        -- stylua: ignore
        keys = {
          { "<leader>Du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
          { "<leader>De", function() require("dapui").eval() end,     desc = "Eval",  mode = { "n", "v" } },
        },
				opts = {},
				config = function(_, opts)
					local dap = require("dap")
					local dapui = require("dapui")
					dapui.setup(opts)
					dap.listeners.after.event_initialized["dapui_config"] = function()
						dapui.open({})
					end
					dap.listeners.before.event_terminated["dapui_config"] = function()
						dapui.close({})
					end
					dap.listeners.before.event_exited["dapui_config"] = function()
						dapui.close({})
					end
				end,
			},

			-- virtual text for the debugger
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {},
			},

			-- which key integration
			-- TODO: switch these to mini.clue
			-- {
			-- 	"folke/which-key.nvim",
			-- 	optional = true,
			-- 	opts = {
			-- 		defaults = {
			-- 			["<leader>D"] = { name = "+debug" },
			-- 			["<leader>Da"] = { name = "+adapters" },
			-- 			["<leader>t"] = { name = "+test" },
			-- 		},
			-- 	},
			-- },

			-- mason.nvim integration
			{
				"jay-babu/mason-nvim-dap.nvim",
				dependencies = "mason.nvim",
				cmd = { "DapInstall", "DapUninstall" },
				opts = {
					-- Makes a best effort to setup the various debuggers with
					-- reasonable debug configurations
					automatic_installation = true,

					-- You can provide additional configuration to the handlers,
					-- see mason-nvim-dap README for more information
					handlers = {},

					-- You'll need to chec
					-- online, please don't ask me how to install them :)
					ensure_installed = {
						-- Update this to ensure that you have the debuggers for the langs you want
					},
				},
			},
		},
    -- stylua: ignore
    keys = {
      {
        "<leader>DB",
        function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
        desc = "Breakpoint Condition"
      },
      {
        "<leader>Db",
        function() require("dap").toggle_breakpoint() end,
        desc = "Toggle Breakpoint"
      },
      {
        "<leader>Dc",
        function() require("dap").continue() end,
        desc = "Continue"
      },
      {
        "<leader>DC",
        function() require("dap").run_to_cursor() end,
        desc = "Run to Cursor"
      },
      {
        "<leader>Dg",
        function() require("dap").goto_() end,
        desc = "Go to line (no execute)"
      },
      {
        "<leader>Di",
        function() require("dap").step_into() end,
        desc = "Step Into"
      },
      {
        "<leader>Dj",
        function() require("dap").down() end,
        desc = "Down"
      },
      {
        "<leader>Dk",
        function() require("dap").up() end,
        desc = "Up"
      },
      {
        "<leader>Dl",
        function() require("dap").run_last() end,
        desc = "Run Last"
      },
      {
        "<leader>Do",
        function() require("dap").step_out() end,
        desc = "Step Out"
      },
      {
        "<leader>DO",
        function() require("dap").step_over() end,
        desc = "Step Over"
      },
      {
        "<leader>Dp",
        function() require("dap").pause() end,
        desc = "Pause"
      },
      {
        "<leader>Dr",
        function() require("dap").repl.toggle() end,
        desc = "Toggle REPL"
      },
      {
        "<leader>Ds",
        function() require("dap").session() end,
        desc = "Session"
      },
      {
        "<leader>Dt",
        function() require("dap").terminate() end,
        desc = "Terminate"
      },
      {
        "<leader>Dw",
        function() require("dap.ui.widgets").hover() end,
        desc = "Widgets"
      },
    },
		opts = function()
			local dap = require("dap")
			if not dap.adapters["codelldb"] then
				require("dap").adapters["codelldb"] = {
					type = "server",
					host = "localhost",
					-- port = "${port}",
					port = "13000",
					executable = {
						command = "codelldb",
						args = {
							"--port",
							-- "${port}",
							"13000",
						},
					},
				}
			end
			for _, lang in ipairs({ "c", "cpp", "rust" }) do
				dap.configurations[lang] = {
					{
						type = "codelldb",
						request = "launch",
						name = "Launch file",
						program = function()
							return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
							--program = '${fileDirname}/${fileBasenameNoExtension}',
						end,
						cwd = "${workspaceFolder}",
						-- terminal = "console",
						terminal = "console",
					},
					{
						type = "codelldb",
						request = "attach",
						name = "Attach to process",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
						terminal = "console",
					},
				}
			end
		end,
		config = function()
			local Config = require("lazyvim.config")
			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

			for name, sign in pairs(Config.icons.dap) do
				sign = type(sign) == "table" and sign or { sign }
				vim.fn.sign_define(
					"Dap" .. name,
					{ text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
				)
			end
		end,
	},
	-- leetcode.nvim:
	{
		"kawre/leetcode.nvim",
		build = ":TSUpdate html",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim", -- required by telescope
			"MunifTanjim/nui.nvim",

			-- optional
			"nvim-treesitter/nvim-treesitter",
			"rcarriga/nvim-notify",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			-- configuration goes here
		},
	},
	-- diffview
	{
		"sindrets/diffview.nvim",
		config = true,
	},
}
