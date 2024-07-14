local AddKeymaps = require("plugins.lsp.lsp-utils").AddKeymaps

return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		opts = {
			pip = {
				upgrade_pip = true,
			},
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
			ensure_installed = {
				"stylua",
				"shellcheck",
				"shfmt",
				-- "flake8",
				"gomodifytags",
				"impl",
				"gofumpt",
				"goimports-reviser",
				"delve",
				"codelldb",
				"glow",
				-- "proselint",
				-- "buf",
				"prettierd",
				"ltex-ls",
				-- "codespell",
				"clangd",
				"clang-format",
				"cmake-language-server",
				"cmakelint",
				"cmakelang",
				"cpplint",
				"hadolint",
				"dockerfile-language-server",
				"rust-analyzer",
				"phpactor",
				-- "phpcs",
				"phpstan",
				"php-cs-fixer",
				"php-debug-adapter",
				-- "pint",
				"blade-formatter",
				"vue-language-server",
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			local packages = {
				"stylua",
				"bash-language-server",
				"black",
				"clang-format",
				"clangd",
				"cmake-language-server",
				"cmakelint",
				"cmakelang",
				"codelldb",
				"cspell",
				"css-lsp",
				"eslint-lsp",
				"graphql-language-service-cli",
				"html-lsp",
				"json-lsp",
				"lua-language-server",
				"markdownlint",
				"prettier",
				"pyright",
				"shfmt",
				"tailwindcss-language-server",
				"taplo",
				"typescript-language-server",
				"yaml-language-server",
				"gopls",
				"editorconfig-checker",
				"phpactor",
				-- "phpcs",
				"phpstan",
				"php-cs-fixer",
				"php-debug-adapter",
				-- "pint",
				"blade-formatter",
				"vue-language-server",
			}
			local function ensure_installed()
				for _, package in ipairs(packages) do
					local p = mr.get_package(package)
					if not p:is_installed() then
						p:install()
					end
				end
			end
			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},
	{
		"b0o/SchemaStore.nvim",
		version = false, -- last release is way too old
	},
	{
		"p00f/clangd_extensions.nvim",
		lazy = true,
		-- config = function() end,
		opts = {
			extensions = {
				inlay_hints = {
					inline = true,
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
		"Badhi/nvim-treesitter-cpp-tools",
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter" },
		},
		config = function()
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
				pattern = { "*.cpp", "*.hpp", "*.h", "*.hxx", "*.cxx", "*.c", "*/include/*" },
				desc = "Add cpp-tools keymaps",
				group = vim.api.nvim_create_augroup("CppToolsKeymaps", { clear = true }),
				callback = function(opts)
					local fpt = vim.bo[opts.buf].filetype
					if fpt == "" then
						vim.cmd([[set ft=cpp]])
						fpt = "cpp"
					end
					if
						fpt == "cpp"
						or fpt == "hpp"
						or fpt == "h"
						or fpt == "hxx"
						or fpt == "cxx"
						or fpt == "c"
						or fpt == ""
					then
						local kopts = function(desc)
							return { desc = desc, silent = true, buffer = opts.buf }
						end
						vim.keymap.set({ "n", "v", "x" }, "<leader>cc", "<leader>cc", { desc = "+ C++" })
						vim.keymap.set(
							{ "n", "v", "x" },
							"<leader>ccd",
							"<cmd>TSCppDefineClassFunc<cr>",
							kopts("Define Class Functions (C++)")
						)
						vim.keymap.set(
							{ "n", "v", "x" },
							"<leader>cci",
							"<cmd>TSCppMakeConcreteClass<cr>",
							kopts("Implement Class from Abstract Class (C++)")
						)
						vim.keymap.set(
							{ "n", "v", "x" },
							"<leader>cc3",
							"<cmd>TSCppRuleOf3<cr>",
							kopts("Add declerations for rule-of-3 (C++)")
						)
						vim.keymap.set(
							{ "n", "v", "x" },
							"<leader>cc5",
							"<cmd>TSCppRuleOf5<cr>",
							kopts("Add declerations for rule-of-5 (C++)")
						)
					end
				end,
			})

			require("nt-cpp-tools").setup({
				preview = {
					quit = "<c-e>", -- optional keymapping for quite preview
					accept = "<c-y>", -- optional keymapping for accept preview
				},
				header_extension = "hpp", -- optional
				source_extention = "cpp", -- optional
				custom_define_class_function_commands = { -- optional
					TSCppImplWrite = {
						output_handle = require("nt-cpp-tools.output_handlers").get_add_to_cpp(),
					},
					--[[
            <your impl function custom command name> = {
                output_handle = function (str, context)
                    -- string contains the class implementation
                    -- do whatever you want to do with it
                end
            }
          ]]
				},
			})
		end,
	},
	{
		"Saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },

		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
				pattern = { "Cargo.toml" },
				desc = "Add Cargo Crates keymaps",
				group = vim.api.nvim_create_augroup("RustCargoKeys", { clear = true }),
				callback = function(opts)
					if vim.bo[opts.buf].filetype == "toml" then
						local crates = require("crates")
						local kopts = function(desc)
							return { desc = desc, silent = true, buffer = opts.buf }
						end
						vim.keymap.set({ "n", "v" }, "<leader>cR", "<leader>cR", { desc = "Rust Crates" })

						vim.keymap.set("n", "<leader>cRt", crates.toggle, kopts("Toggle Crates"))
						vim.keymap.set("n", "<leader>cRr", crates.reload, kopts("Reload Crates"))
						vim.keymap.set("n", "<leader>cRv", crates.show_versions_popup, kopts("Show Versions"))
						vim.keymap.set("n", "<leader>cRf", crates.show_features_popup, kopts("Show Features"))
						vim.keymap.set("n", "<leader>cRd", crates.show_dependencies_popup, kopts("Show Dependencies"))
						vim.keymap.set("n", "<leader>cRu", crates.update_crate, kopts("Update Crate"))
						vim.keymap.set("v", "<leader>cRu", crates.update_crates, kopts("Update Crates"))
						vim.keymap.set("n", "<leader>cRa", crates.update_all_crates, kopts("Update All Crates"))
						-- vim.keymap.set('n', '<leader>cRU', crates.upgrade_crate, kopts("Update Crate"))
						-- vim.keymap.set('v', '<leader>cRU', crates.upgrade_crates, kopts("Update Crates"))
						-- vim.keymap.set('n', '<leader>cRA', crates.upgrade_all_crates, kopts("Update All Crates"))
						vim.keymap.set(
							"n",
							"<leader>cRe",
							crates.expand_plain_crate_to_inline_table,
							kopts("Expand Crate to Inline Table")
						)
						vim.keymap.set(
							"n",
							"<leader>cRE",
							crates.extract_crate_into_table,
							kopts("Extract Crate into Table")
						)
						vim.keymap.set("n", "<leader>cRH", crates.open_homepage, kopts("Open Homepage"))
						vim.keymap.set("n", "<leader>cRR", crates.open_repository, kopts("Open Repository"))
						vim.keymap.set("n", "<leader>cRD", crates.open_documentation, kopts("Open Documentation"))
						vim.keymap.set("n", "<leader>cRC", crates.open_crates_io, kopts("Open Crates.io"))
					end
				end,
			})

			require("crates").setup({
				null_ls = {
					enabled = true,
					name = "crates.nvim",
				},
			})
		end,
	},
	-- TODO: rust-tools okay?
	{
		"simrat39/rust-tools.nvim",
		-- lazy = true,
		config = function() end,
	},
	{
		"adalessa/laravel.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"tpope/vim-dotenv",
			"MunifTanjim/nui.nvim",
			"nvimtools/none-ls.nvim",
		},
		cmd = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
		keys = {
			{ "<leader>cl", "<leader>cl", desc = "Laravel" },
			{ "<leader>cla", ":Laravel artisan<cr>", desc = "Laravel Artisan" },
			{ "<leader>clr", ":Laravel routes<cr>", desc = "Laravel Routes" },
			{ "<leader>clm", ":Laravel related<cr>", desc = "Laravel Related" },
		},
		event = { "VeryLazy" },
		config = true,
	},
	{
		"ccaglak/namespace.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>cl", "<leader>cl", desc = "Laravel" },
			{ "<leader>clC", "<cmd>GetClasses<cr>", desc = "Get Classes" },
			{ "<leader>clc", "<cmd>GetClass<cr>", desc = "Get Class" },
			{ "<leader>cls", "<cmd>ClassAs<cr>", desc = "Class As" },
			{ "<leader>cln", "<cmd>Namespace<cr>", desc = "Namespace" },
		},
	},
	{
		"ccaglak/larago.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>clg", "<cmd>GoBlade<cr>", desc = "Go to Blade" },
		},
	},
	-- TODO: FIX: for some bloody reason going back to prev blade buffer after this autosets filetype to html...
	{
		"gbprod/phpactor.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required to update phpactor
			"neovim/nvim-lspconfig", -- required to automatically register lsp server
		},
		build = ':lua require("phpactor.handler.update")', -- To install/update phpactor when installing this plugin
		config = function()
			local lsp_utils = require("plugins.lsp.lsp-utils")
			-- lsp_utils.setup()

			require("phpactor").setup({
				install = {
					path = vim.fn.stdpath("data") .. "/mason/",
					branch = "master",
					bin = vim.fn.stdpath("data") .. "/mason/bin/phpactor",
					php_bin = "php",
					composer_bin = "composer",
					git_bin = "git",
					check_on_startup = "none",
				},
				lspconfig = {
					enabled = true,
					options = {
						on_attach = lsp_utils.on_attach,
						capabilities = lsp_utils.capabilities,
						filetypes = { "php", "blade", "blade.php" },
						-- highlight = { enable = true, additional_vim_regex_highlighting = true },
					},
				},
			})
			-- vim.filetype.add({
			-- 	pattern = { [".*%.blade%.php"] = "blade" },
			-- })
			-- vim.filetype.add({
			-- 	pattern = { [".*php"] = "php" },
			-- })
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{
				-- TODO: wtf is this?
				{
					"folke/neoconf.nvim",
					cmd = "Neoconf",
					config = false,
					dependencies = { "nvim-lspconfig" },
				},
				{ "mason.nvim" },
				{ "williamboman/mason-lspconfig.nvim" },
				{ "p00f/clangd_extensions.nvim" },
				{
					"hrsh7th/cmp-nvim-lsp",
					-- cond = function()
					--        return require("lazyvim.util").has("nvim-cmp")
					-- end,
				},
				{ "Saecki/crates.nvim" },
				{ "b0o/SchemaStore.nvim" },
				{ "adalessa/laravel.nvim" },
				"jose-elias-alvarez/typescript.nvim",
				init = function()
					require("lazyvim.util").on_attach(function(_, buffer)
            -- stylua: ignore
            AddKeymaps(buffer, {
              { "<leader>co",
                "TypescriptOrganizeImports",
                { buffer = buffer, desc = "Organize Imports" },
              },
              {
                "<leader>cR",
                "TypescriptRenameFile",
                { desc = "Rename File", buffer = buffer },
              },
            })
					end)
				end,
			},
		},
		opts = {
			servers = {
				dockerls = {},
				docker_compose_language_service = {},
				neocmake = {},
				ltex = {},
				tsserver = {},
				-- Ensure mason installs the server
				rust_analyzer = {},
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
				gopls = {},
				-- Ensure mason installs the server
				clangd = {},
				phpactor = {},
			},
			setup = {
				tsserver = function(_, opts)
					require("typescript").setup({ server = opts })
					return true
				end,
			},
			ensure_installed = {
				"bashls",
				"clangd",
				-- "cmake-language-server",
				"cssls",
				"dockerls",
				"docker_compose_language_service",
				"gopls",
				"graphql",
				"html",
				"jsonls",
				"ltex",
				"lua_ls",
				"pyright",
				"tailwindcss",
				"taplo",
				"tsserver",
				"yamlls",
				"rust_analyzer",
				"phpactor",
			},
		},
		config = function(_, opts)
			local mason_lspconfig = require("mason-lspconfig")
			local lspconfig = require("lspconfig")
			local lsp_utils = require("plugins.lsp.lsp-utils")
			lsp_utils.setup()

			-- lspconfig.phpactor.setup({})

			mason_lspconfig.setup(opts)

			mason_lspconfig.setup_handlers({
				function(server_name)
					lspconfig[server_name].setup({
						on_attach = lsp_utils.on_attach,
						capabilities = lsp_utils.capabilities,
					})
				end,
				["html"] = function()
					lspconfig.html.setup({
						on_attach = lsp_utils.on_attach,
						capabilities = lsp_utils.capabilities,
						filetypes = { "html", "templ", "blade" },
						-- settings = {
						-- 	html = {
						-- 		autoClosingTags = true,
						-- 		mirrorCursorOnMatchingTag = true,
						-- 	},
						-- },
					})
				end,
				["ltex"] = function()
					lspconfig.ltex.setup({
						on_attach = lsp_utils.on_attach,
						capabilities = lsp_utils.capabilities,
						filetypes = {
							"bib",
							"gitcommit",
							"markdown",
							"org",
							"plaintex",
							"rst",
							"rnoweb",
							"tex",
							"pandoc",
							"quarto",
							"rmd",
							"context",
							-- "html",
							-- "xhtml",
							"mail",
							"text",
						},
					})
				end,
				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
						on_attach = lsp_utils.on_attach,
						capabilities = lsp_utils.capabilities,
						settings = {
							Lua = {
								runtime = {
									version = "LuaJIT",
								},
								diagnostics = {
									-- Get the language server to recognize the global `vim`
									globals = { "vim", "hs", "spoon" },
								},
								workspace = {
									-- Make the server aware of Neovim runtime files
									library = vim.api.nvim_get_runtime_file("", true), --get_library(),
									-- Do not show annoying setting message
									-- https://www.reddit.com/r/neovim/comments/10qvoky/why_am_i_keep_getting_asked_this_question_all_the/
									checkThirdParty = false,
								},
								format = {
									enable = true,
									-- https://github.com/LuaLS/lua-language-server/wiki/Formatter
									-- https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/docs/format_config.md
									-- https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/lua.template.editorconfig
									defaultConfig = {
										-- The value should be STRING!
										indent_style = "space",
										indent_size = "2",
										quote_style = "double",
										local_assign_continuation_align_to_first_expression = "true",
										align_array_table = "false",
										-- call_arg_parentheses = "remove_table_only",
										-- keep_one_space_between_table_and_bracket = true,
										-- align_table_field_to_first_field = true,
									},
								},
								-- Do not send telemetry data containing a randomized but unique identifier
								telemetry = {
									enable = false,
								},
								completion = {
									-- Do not complete with arguments, as we always omit arguments
									callSnippet = "Disable",
								},
								semantic = {
									enable = false, -- Disable highlight as it conflict with treesitter
								},
							},
						},
					})
				end,
				["pyright"] = function()
					lspconfig.pyright.setup({
						on_attach = lsp_utils.on_attach,
						capabilities = lsp_utils.capabilities,
						settings = {
							python = {
								analysis = {
									typeCheckingMode = "off",
								},
							},
						},
					})
				end,
				["clangd"] = function()
					local capabilities_cpp = lsp_utils.capabilities
					capabilities_cpp.offsetEncoding = { "uts-16" }
					lspconfig.clangd.setup({
						on_attach = function(client, bufnr)
							AddKeymaps(bufnr, {
								{
									"<leader>cR",
									"<cmd>ClangdSwitchSourceHeader<cr>",
									{ desc = "Switch Source/Header (C/C++)" },
								},
								{
									"<leader>cS",
									"<cmd>ClangdSymbolInfo<cr>",
									{ desc = "Get Current Symbol Info" },
								},
								-- {
								-- 	"<leader>cM",
								-- 	"<cmd>ClangdMemoryUsage<cr>",
								-- 	{ desc = "Show Memory Usage" },
								-- },
								{
									"<leader>ch",
									"<cmd>ClangdTypeHierarchy<cr>",
									{ desc = "Show Type Hierarchy" },
								},
							})
							require("clangd_extensions.inlay_hints").setup_autocmd()
							require("clangd_extensions.inlay_hints").set_inlay_hints()
							-- Enable completion triggered by <c-x><c-o>
							vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
						end,
						capabilities = capabilities_cpp,
						cmd = {
							"clangd",
							"--background-index",
							"--background-index-priority=normal",
							-- "--all-scopes-completion",
							"--clang-tidy",
							"--header-insertion=iwyu", --/never
							"--header-insertion-decorators",
							"--completion-style=detailed", --/bundled (groups overloads/etc.)
							"--function-arg-placeholders",
							"-j=12",
							-- "--pch-storage=memory",
							-- "limit-references=1000",
							-- "limit-results=100",
							-- "rename-file-limit=50",
							-- "fallback-stule=llvm" -- used if no .clang-format file exists
							-- "project-root=...",
						},
						init_options = {
							usePlaceholders = true,
							completeUnimported = true,
							clangdFileStatus = true,
							fallbackFlags = {
								"--std=c++20",
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
								"build.ninja",
								".clangd",
								".clang-tidy",
								".clang-format"
							)(fname) or require("lspconfig.util").root_pattern(
								"compile_commands.json",
								"compile_flags.txt"
							)(fname) or require("lspconfig.util").find_git_ancestor(fname)
						end,
						-- settings = { clangd = { }}
					})
				end,
				["gopls"] = function()
					lspconfig.gopls.setup({
						on_attach = function(client, bufnr)
							-- workaround for gopls not supporting semanticTokensProvider
							-- https://github.com/golang/go/issues/54531#issuecomment-1464982242
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
							-- end workaround

							AddKeymaps(bufnr, {
								-- Workaround for the lack of a DAP strategy in neotest-go: https://github.com/nvim-neotest/neotest-go/issues/12
								{
									"<leader>tD",
									"<cmd>lua require('dap-go').debug_test()<CR>",
									desc = "Debug Nearest (Go)",
								},
							})
							-- Enable completion triggered by <c-x><c-o>
							vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
						end,
						capabilities = lsp_utils.capabilities,
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
					})
				end,
				["phpactor"] = function()
					lspconfig.phpactor.setup({
						on_attach = lsp_utils.on_attach,
						capabilities = lsp_utils.capabilities,
						filetypes = { "php", "blade", "blade.php" },
						settings = {
							phpactor = {
								enabled = true,
							},
						},
					})
				end,
				["rust_analyzer"] = function()
					-- local rust_tools_opts = require("lazyvim.util").opts("rust-tools.nvim")

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
					-- lspconfig.rust_analyzer.setup({})
					require("rust-tools").setup({
						capabilities = lsp_utils.capabilities,
						server = {
							on_attach = function(client, bufnr)
								AddKeymaps(bufnr, {
									{
										"<C-space>",
										"<cmd>RustHoverActions<cr>",
										{ desc = "Hover Actions (Rust)" },
									},
									{
										"K",
										"<cmd>RustHoverActions<cr>",
										{ desc = "Hover Actions (Rust)" },
									},
									{
										"<leader>cR",
										"<leader>cR",
										{ desc = "Rust" },
									},

									{
										"<leader>cRa",
										"<cmd>RustCodeAction<cr>",
										{ desc = "Code Action (Rust)" },
									},
									{
										"<leader>Dr",
										"<cmd>RustDebuggables<cr>",
										{ desc = "Run Debuggables (Rust)" },
									},
									{
										"<leader>cRh",
										"<leader>cRh",
										{ desc = "Inlay Hints" },
									},
									{
										"<leader>cRhs",
										"<cmd>RustSetInlayHints<Cr>",
										{ desc = "Set Inlay Hints (Rust)" },
									},
									{
										"<leader>cRhd",
										"<cmd>RustDisableInlayHints<Cr>",
										{ desc = "Disable Inlay Hints (Rust)" },
									},
									{
										"<leader>cRht",
										"<cmd>RustToggleInlayHints<Cr>",
										{ desc = "Toggle Inylay Hints (Rust)" },
									},
									{
										"<leader>cRr",
										"<cmd>RustRunnables<Cr>",
										{ desc = "Runnables (Rust)" },
									},
									{
										"<leader>cRe",
										"<leader>cRe",
										{ desc = "Expansions" },
									},
									{
										"<leader>cRem",
										"<cmd>RustExpandMacro<Cr>",
										{ desc = "Expand Macro (Rust)" },
									},
									{
										"<leader>cRo",
										"<leader>cRo",
										{ desc = "Open" },
									},

									{
										"<leader>cRoc",
										"<cmd>RustOpenCargo<Cr>",
										{ desc = "Open Cargo (Rust)" },
									},
									{
										"<leader>cRom",
										"<cmd>RustParentModule<Cr>",
										{ desc = "Open Parent Module (Rust)" },
									},
									{
										"<leader>cRJ",
										"<cmd>RustJoinLines<Cr>",
										{ desc = "Join Lines (Rust)" },
									},
									{
										"<leader>cRha",
										"<cmd>RustHoverActions<Cr>",
										{ desc = "Hover Action (Rust)" },
									},
									{
										"<leader>cRhr",
										"<cmd>RustHoverRange<Cr>",
										{ desc = "Hover Range (Rust)" },
									},
									{
										"<leader>cRm",
										"<leader>cRm",
										{ desc = "Move" },
									},
									{
										"<leader>cRmd",
										"<cmd>RustMoveItemDown<Cr>",
										{ desc = "Move Item Down (Rust)" },
									},
									{
										"<leader>cRmu",
										"<cmd>RustMoveItemUp<Cr>",
										{ desc = "Move Item Up (Rust)" },
									},
									{
										"<leader>cRs",
										"<leader>cRs",
										{ desc = "Start" },
									},
									{
										"<leader>cRsb",
										"<cmd>RustStartStandaloneServerForBuffer<Cr>",
										{ desc = "Start Standalone Server For Buffer (Rust)" },
									},
									{
										"<leader>cRd",
										"<cmd>RustDebuggables<Cr>",
										{ desc = "Run Debuggables (Rust)" },
									},
									{
										"<leader>cRv",
										"<cmd>RustViewCrateGraph<Cr>",
										{ desc = "View Crate Graph (Rust)" },
									},
									{
										"<leader>cRw",
										"<cmd>RustReloadWorkspace<Cr>",
										{ desc = "Reload Workspace (Rust)" },
									},
									{
										"<leader>cRss",
										"<cmd>RustSSR<Cr>",
										{ desc = "SSR (Rust)" },
									},
									{
										"<leader>cRx",
										"<cmd>RustOpenExternalDocs<Cr>",
										{ desc = "Open External Docs (Rust)" },
									},
								})
								-- Enable completion triggered by <c-x><c-o>
								vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
							end,
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
					})
				end,
			})
		end,
	},
	{
		"nvimdev/lspsaga.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			{ "nvim-tree/nvim-web-devicons", lazy = true },
		},
		opts = {
			symbol_in_winbar = { enable = false },
			lightbulb = {
				enable = true,
				sign = true,
			},
			outline = {
				layout = "float",
				max_height = 0.7,
				left_width = 0.4,
			},
			ui = {
				border = "rounded",
				kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
			},
		},
		keys = {
			{ "<leader>cb", "<Cmd>Lspsaga show_buf_diagnostics<CR>", desc = "Diagnostics: Show buffer's" },
			{ "<leader>ch", "<Cmd>Lspsaga finder<CR>", desc = "Find references" },
			{ "<leader>cp", "<Cmd>Lspsaga peek_definition<CR>", desc = "Peek definition" },
			{ "<leader>ct", "<Cmd>Lspsaga peek_type_definition<CR>", desc = "Peek type definition" },
			{
				"<leader>co",
				"<Cmd>Lspsaga outline<CR>",
				desc = "Show file outline - 'e' to jump, 'o' to toggle",
			},
			{
				"<leader>ca",
				"<cmd>Lspsaga code_action<CR>",
				mode = { "n", "v" },
				desc = "Show code action",
			},
		},
	},
}
