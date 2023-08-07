return {
	{
		"tpope/vim-fugitive",
		cmd = "Git",
	},
	{
		"ThePrimeagen/harpoon",
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
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
						["D"] = "show_diff",
						-- TODO:
						-- ["G"] = "toggle_git_stage",
					},
				},
				filesystem = {
					components = {
						harpoon_index = function(config, node, state)
							local Marked = require("harpoon.mark")
							local abs_path = node.path
							-- fix for m$ paths:
							local path = string.gsub(abs_path, "\\", "/")
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
							{ "harpoon_index" }, --> This is what actually adds the component in where you want it
							{ "diagnostics" },
							{ "git_status", highlight = "NeoTreeDimText" },
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
						-- TODO:
						-- toggle_git_stage = function(state)
						--          -- if the file is not staged (and can be) stage it:
						-- 	-- require("vim-fugitive").init_options
						--          -- otherwise, if the file is staged, unstage it
						--        end,
					},
				},
			})
		end,
	},
	{
		"simrat39/symbols-outline.nvim",
		cmd = "SymbolsOutline",
		keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
		config = true,
	},
	{
		"nvim-lualine/lualine.nvim",
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
              color = Util.fg("Statement"),
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = Util.fg("Constant"),
            },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = Util.fg("Debug"),
            },
						{
							require("lazy.status").updates,
							cond = require("lazy.status").has_updates,
							color = Util.fg("Special"),
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
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, {
					"vimdoc",
					"javascript",
					"typescript",
					"c",
					"lua",
					"ron",
					"rust",
					"toml",
					"cpp",
					"go",
					"gomod",
					"gowork",
					"gosum",
					"json",
					"json5",
					"jsonc",
					"bash",
					"html",
					"markdown",
					"markdown_inline",
					"python",
					"query",
					"regex",
					"vim",
					"yaml",
				})
				opts.auto_install = true
				opts.highlight.enable = true
				opts.highlight.additional_vim_regex_highlighting = false
			end
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{
				"Saecki/crates.nvim",
				event = { "BufRead Cargo.toml" },
				config = true,
			},
		},
		---@param opts cmp.ConfigSchema
		opts = function(_, opts)
			local cmp = require("cmp")
			opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
				{ name = "crates" },
			}))
		end,
	},
	{
		"Saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		config = true,
	},
	{
		"simrat39/rust-tools.nvim",
		-- lazy = true,
		opts = function()
			local ok, mason_registry = pcall(require, "mason-registry")
			local adapter ---@type any
			if ok then
				-- rust tools configuration for debugging support
				local codelldb = mason_registry.get_package("codelldb")
				local extension_path = codelldb:get_install_path() .. "/extension/"
				local codelldb_path = extension_path .. "adapter/codelldb"
				local liblldb_path = vim.fn.has("mac") == 1 and extension_path .. "lldb/lib/liblldb.dylib"
					or vim.fn.has("windows") == 1 and extension_path .. "codelldb.dll"
					or extension_path .. "lldb/lib/liblldb.so"
				adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
			end
			adapter["port"] = 13000
			if vim.fn.has("windows") == 1 then
				adapter["executable"]["args"] = { "--port", "13000" }
			end

			return {
				server = {
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
				},
				dap = {
					adapter = adapter,
				},
				tools = {
					hover_actions = {
						auto_focus = true,
					},
					on_initialized = function()
						vim.cmd([[
                augroup RustLSP
                  autocmd CursorHold                      *.rs silent! lua vim.lsp.buf.document_highlight()
                  autocmd CursorMoved,InsertEnter         *.rs silent! lua vim.lsp.buf.clear_references()
                  autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
                augroup END
              ]])
					end,
				},
			}
		end,
		config = function() end,
	},
	{
		"p00f/clangd_extensions.nvim",
		lazy = true,
		config = function() end,
		opts = {
			extensions = {
				inlay_hints = {
					inline = false,
				},
				ast = {
					--These require codicons (https://github.com/microsoft/vscode-codicons)
					role_icons = {
						type = "",
						declaration = "",
						expression = "",
						specifier = "",
						statement = "",
						["template argument"] = "",
					},
					kind_icons = {
						Compound = "",
						Recovery = "",
						TranslationUnit = "",
						PackExpansion = "",
						TemplateTypeParm = "",
						TemplateTemplateParm = "",
						TemplateParamObject = "",
					},
				},
			},
		},
	},
	{
		"b0o/SchemaStore.nvim",
		version = false, -- last release is way too old
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"jose-elias-alvarez/typescript.nvim",
				init = function()
					require("lazyvim.util").on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
						vim.keymap.set(
							"n",
							"<leader>cR",
							"TypescriptRenameFile",
							{ desc = "Rename File", buffer = buffer }
						)
					end)
				end,
			},
		},
		opts = {
			servers = {
				tsserver = {},
				-- Ensure mason installs the server
				rust_analyzer = {
					keys = {
						{ "K", "<cmd>RustHoverActions<cr>", desc = "Hover Actions (Rust)" },
						{ "<leader>cRa", "<cmd>RustCodeAction<cr>", desc = "Code Action (Rust)" },
						{ "<leader>Dr", "<cmd>RustDebuggables<cr>", desc = "Run Debuggables (Rust)" },
						{
							"<leader>cRhs",
							"<cmd>RustSetInlayHints<Cr>",
							desc = "Set Inlay Hints (Rust)",
						},
						{
							"<leader>cRhd",
							"<cmd>RustDisableInlayHints<Cr>",
							desc = "Disable Inlay Hints (Rust)",
						},
						{
							"<leader>cRht",
							"<cmd>RustToggleInlayHints<Cr>",
							desc = "Toggle Inylay Hints (Rust)",
						},
						{
							"<leader>cRr",
							"<cmd>RustRunnables<Cr>",
							desc = "Runnables (Rust)",
						},
						{
							"<leader>cRem",
							"<cmd>RustExpandMacro<Cr>",
							desc = "Expand Macro (Rust)",
						},
						{
							"<leader>cRoc",
							"<cmd>RustOpenCargo<Cr>",
							desc = "Open Cargo (Rust)",
						},
						{
							"<leader>cRpm",
							"<cmd>RustParentModule<Cr>",
							desc = "Open Parent Module (Rust)",
						},
						{
							"<leader>cRJ",
							"<cmd>RustJoinLines<Cr>",
							desc = "Join Lines (Rust)",
						},
						{
							"<leader>cRha",
							"<cmd>RustHoverActions<Cr>",
							desc = "Hover Action (Rust)",
						},
						{
							"<leader>cRhr",
							"<cmd>RustHoverRange<Cr>",
							desc = "Hover Range (Rust)",
						},
						{
							"<leader>cRmd",
							"<cmd>RustMoveItemDown<Cr>",
							desc = "Move Item Down (Rust)",
						},
						{
							"<leader>cRmu",
							"<cmd>RustMoveItemUp<Cr>",
							desc = "Move Item Up (Rust)",
						},
						{
							"<leader>cRsb",
							"<cmd>RustStartStandaloneServerForBuffer<Cr>",
							desc = "Start Standalone Server For Buffer (Rust)",
						},
						{ "<leader>cRd", "<cmd>RustDebuggables<Cr>", desc = "Run Debuggables (Rust)" },
						{ "<leader>cRv", "<cmd>RustViewCrateGraph<Cr>", desc = "View Crate Graph (Rust)" },
						{ "<leader>cRw", "<cmd>RustReloadWorkspace<Cr>", desc = "Reload Workspace (Rust)" },
						{ "<leader>cRss", "<cmd>RustSSR<Cr>", desc = "SSR (Rust)" },
						{
							"<leader>cRxd",
							"<cmd>RustOpenExternalDocs<Cr>",
							desc = "Open External Docs (Rust)",
						},
					},
					settings = {
						["rust-analyzer"] = {
							lens = {
								enable = true,
							},
							cargo = {
								allFeatures = true,
								loadOutDirsFromCheck = true,
								runBuildScripts = true,
								buildScripts = {
									enable = true,
								},
							},
							-- Add clippy lints for Rust.
							checkOnSave = {
								allFeatures = true,
								command = "clippy",
								extraArgs = { "--no-deps" },
							},
							procMacro = {
								enable = true,
								ignored = {
									["async-trait"] = { "async_trait" },
									["napi-derive"] = { "napi" },
									["async-recursion"] = { "async_recursion" },
								},
							},
						},
					},
				},
				taplo = {
					keys = {
						{
							"K",
							function()
								if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
									require("crates").show_popup()
								else
									vim.lsp.buf.hover()
								end
							end,
							desc = "Show Crate Documentation",
						},
					},
				},
				jsonls = {
					-- lazy-load schemastore when needed
					on_new_config = function(new_config)
						new_config.settings.json.schemas = new_config.settings.json.schemas or {}
						vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
					end,
					settings = {
						json = {
							format = {
								enable = true,
							},
							validate = { enable = true },
						},
					},
				},
				gopls = {
					keys = {
						-- Workaround for the lack of a DAP strategy in neotest-go: https://github.com/nvim-neotest/neotest-go/issues/12
						{
							"<leader>td",
							"<cmd>lua require('dap-go').debug_test()<CR>",
							desc = "Debug Nearest (Go)",
						},
					},
					settings = {
						gopls = {
							gofumpt = true,
							codelenses = {
								gc_details = false,
								generate = true,
								regenerate_cgo = true,
								run_govulncheck = true,
								test = true,
								tidy = true,
								upgrade_dependency = true,
								vendor = true,
							},
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							analyses = {
								fieldalignment = true,
								nilness = true,
								unusedparams = true,
								unusedwrite = true,
								useany = true,
							},
							usePlaceholders = true,
							completeUnimported = true,
							staticcheck = true,
							directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
							semanticTokens = true,
						},
					},
				},
				-- Ensure mason installs the server
				clangd = {
					keys = {
						{
							"<leader>cR",
							"<cmd>ClangdSwitchSourceHeader<cr>",
							desc = "Switch Source/Header (C/C++)",
						},
					},
					root_dir = function(fname)
						return require("lspconfig.util").root_pattern(
							"Makefile",
							"configure.ac",
							"configure.in",
							"config.h.in",
							"meson.build",
							"meson_options.txt",
							"build.ninja"
						)(fname) or require("lspconfig.util").root_pattern(
							"compile_commands.json",
							"compile_flags.txt"
						)(fname) or require("lspconfig.util").find_git_ancestor(fname)
					end,
					capabilities = {
						offsetEncoding = { "utf-16" },
					},
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--header-insertion=iwyu",
						"--completion-style=detailed",
						"--function-arg-placeholders",
						"--fallback-style=llvm",
					},
					init_options = {
						usePlaceholders = true,
						completeUnimported = true,
						clangdFileStatus = true,
					},
				},
			},
			setup = {
				tsserver = function(_, opts)
					require("typescript").setup({ server = opts })
					return true
				end,
				rust_analyzer = function(_, opts)
					local rust_tools_opts = require("lazyvim.util").opts("rust-tools.nvim")
					require("rust-tools").setup(vim.tbl_deep_extend("force", rust_tools_opts or {}, { server = opts }))
					return true
				end,
				gopls = function(_, opts)
					-- workaround for gopls not supporting semanticTokensProvider
					-- https://github.com/golang/go/issues/54531#issuecomment-1464982242
					require("lazyvim.util").on_attach(function(client, _)
						if client.name == "gopls" then
							if not client.server_capabilities.semanticTokensProvider then
								local semantic = client.config.capabilities.textDocument.semanticTokens
								client.server_capabilities.semanticTokensProvider = {
									full = true,
									legend = {
										tokenTypes = semantic.tokenTypes,
										tokenModifiers = semantic.tokenModifiers,
									},
									range = true,
								}
							end
						end
					end)
					-- end workaround
				end,
				clangd = function(_, opts)
					local clangd_ext_opts = require("lazyvim.util").opts("clangd_extensions.nvim")
					require("clangd_extensions").setup(
						vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts })
					)
					return true
				end,
			},
		},
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		opts = function(_, opts)
			local nls = require("null-ls")
			table.insert(opts.sources, nls.builtins.formatting.prettierd)
			if type(opts.sources) == "table" then
				vim.list_extend(opts.sources, {
					nls.builtins.code_actions.gomodifytags,
					nls.builtins.code_actions.impl,
					nls.builtins.formatting.gofumpt,
					nls.builtins.formatting.goimports_reviser,
				})
			end
		end,
	},
	{ "nvimdev/lspsaga.nvim" },
	--{ "kkharji/sqlite.lua", module = "sqlite" },
	{
		"s1n7ax/nvim-window-picker",
		name = "window-picker",
		event = "VeryLazy",
		version = "2.*",
		config = function()
			require("window-picker").setup({
				hint = "floating-big-letter",
				-- hint = 'statusline-winbar',
				--
				-- following filters are only applied when you are using the default filter
				-- defined by this plugin. If you pass in a function to "filter_func"
				-- property, you are on your own
				filter_rules = {
					-- when there is only one window available to pick from, use that window
					-- without prompting the user to select
					autoselect_one = true,

					-- whether you want to include the window you are currently on to window
					-- selection or not
					include_current_win = true,

					-- filter using buffer options
					bo = {
						-- if the file type is one of following, the window will be ignored
						-- filetype = { 'NvimTree', 'neo-tree', 'notify' },

						filetype = { "notify" },
						-- if the file type is one of following, the window will be ignored
						-- buftype = { 'terminal' },
					},
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.2",
		lazy = false,
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "debugloop/telescope-undo.nvim" },
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
        "<leader>fp",
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
			})
			require("telescope").load_extension("undo")
		end,
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
	{
		"wintermute-cell/gitignore.nvim",
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
		"kevinhwang91/nvim-ufo",
		event = { "User FileOpened" },
		cmd = { "UfoDetach" },
		enabled = true,
		dependencies = "kevinhwang91/promise-async",
		config = function()
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
						chunkWidth = vim.fn.strdisplaywidth(chunkTeyt)
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

			local ftMap = {
				vim = "indent",
				python = { "indent" },
				git = "",
			}

			local opts = { noremap = false, silent = true }
			local keymap = vim.keymap.set
			--Folds
			-- TODO: use whichkey / add descriptions
			keymap("n", "zR", require("ufo").openAllFolds, opts)
			keymap("n", "zM", require("ufo").closeAllFolds, opts)
			keymap("n", "zr", require("ufo").openFoldsExceptKinds, opts)
			keymap("n", "zm", require("ufo").closeFoldsWith, opts)
			keymap("n", "zk", function()
				local winid = require("ufo").peekFoldedLinesUnderCursor()
				if not winid then
					vim.lsp.buf.hover()
				end
			end, { desc = "Peak Folded Lines Under Cursor" })

			require("ufo").setup({
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

				provider_selector = function(bufnr, filetype, buftype)
					return ftMap[filetype] or { "treesitter", "indent" }
				end,
			})
		end,
	},
	{
		"phaazon/hop.nvim",
		branch = "v2", -- optional but strongly recommended
		config = function()
			-- you can configure Hop the way you like here; see :h hop-config
			require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
		end,
	},
	{
		"nvim-treesitter/playground",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"epwalsh/obsidian.nvim",
		lazy = true,
		--event = { "BufReadPre path/to/my-vault/**.md" },
		-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand':
		-- TODO: add ObsidianMasterVault as environment var
		event = { "BufReadPre " .. vim.fn.expand("~") .. "/OneDrive/ObsidianMasterVault" },
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("obsidian").setup({
				dir = "~/OneDrive/ObsidianMasterVault", -- no need to call 'vim.fn.expand' here
				-- Optional, key mappings.
				mappings = {
					-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
					["gf"] = require("obsidian.mapping").mapping.gf_passthrough(),
				},
				finder = "telescope.nvim",
			})
		end,
	},
	{
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
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"stylua",
				"shellcheck",
				"shfmt",
				"flake8",
				"gomodifytags",
				"impl",
				"gofumpt",
				"goimports-reviser",
				"delve",
				"codelldb",
				"glow",
			},
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
}
