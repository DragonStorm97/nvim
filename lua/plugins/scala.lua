return {
	{
		"scalameta/nvim-metals",
		event = "BufReadPre *.scala",
		cmd = "MetalsStartServer",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"mfussenegger/nvim-dap",
			{ "hrsh7th/cmp-nvim-lsp" },
		},
		config = function()
			local metals_config = require("metals").bare_config()

			-- Example of settings
			metals_config.settings = {
				showImplicitArguments = true,
				excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
			}

			-- *READ THIS*
			-- I *highly* recommend setting statusBarProvider to true, however if you do,
			-- you *have* to have a setting to display this in your statusline or else
			-- you'll not see any messages from metals. There is more info in the help
			-- docs about this
			-- metals_config.init_options.statusBarProvider = "on"

			-- Example if you are using cmp how to make sure the correct capabilities for snippets are set
			metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

			metals_config.on_attach = function(client, bufnr)
				require("metals").setup_dap()
			end
			require("metals").initialize_or_attach(metals_config)
			local api = vim.api
			local cmd = vim.cmd
			local map = vim.keymap.set

			-- local cmp = require("cmp")
			-- cmp.setup({
			-- 	sources = {
			-- 		{ name = "nvim_lsp" },
			-- 		-- { name = "vsnip" },
			-- 		{ name = "luasnip" }, -- For luasnip users.
			-- 	},
			-- 	snippet = {
			-- 		expand = function(args)
			-- 			-- Comes from vsnip
			-- 			-- vim.fn["vsnip#anonymous"](args.body)
			-- 			require("luasnip").lsp_expand(args.body)
			-- 		end,
			-- 	},
			-- 	mapping = cmp.mapping.preset.insert({
			-- 		-- None of this made sense to me when first looking into this since there
			-- 		-- is no vim docs, but you can't have select = true here _unless_ you are
			-- 		-- also using the snippet stuff. So keep in mind that if you remove
			-- 		-- snippets you need to remove this select
			-- 		-- ["<CR>"] = cmp.mapping.confirm({ select = true }),
			-- 		["<C-y>"] = cmp.mapping.confirm({ select = true }),
			-- 		-- I use tabs... some say you should stick to ins-completion but this is just here as an example
			-- 		["<Tab>"] = function(fallback)
			-- 			if cmp.visible() then
			-- 				cmp.select_next_item()
			-- 			else
			-- 				fallback()
			-- 			end
			-- 		end,
			-- 		["<S-Tab>"] = function(fallback)
			-- 			if cmp.visible() then
			-- 				cmp.select_prev_item()
			-- 			else
			-- 				fallback()
			-- 			end
			-- 		end,
			-- 	}),
			-- })

			----------------------------------
			-- LSP Setup ---------------------
			----------------------------------
			local metals_config = require("metals").bare_config()

			-- Example of settings
			metals_config.settings = {
				showImplicitArguments = true,
				excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
			}

			-- *READ THIS*
			-- I *highly* recommend setting statusBarProvider to true, however if you do,
			-- you *have* to have a setting to display this in your statusline or else
			-- you'll not see any messages from metals. There is more info in the help
			-- docs about this
			-- metals_config.init_options.statusBarProvider = "on"

			-- Example if you are using cmp how to make sure the correct capabilities for snippets are set
			metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Debug settings if you're using nvim-dap
			local dap = require("dap")

			dap.configurations.scala = {
				{
					type = "scala",
					request = "launch",
					name = "RunOrTest",
					metals = {
						runType = "runOrTestFile",
						--args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
					},
				},
				{
					type = "scala",
					request = "launch",
					name = "Test Target",
					metals = {
						runType = "testTarget",
					},
				},
			}

			metals_config.on_attach = function(client, bufnr)
				require("metals").setup_dap()
			end

			-- Autocmd that will actually be in charging of starting the whole thing
			local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
			api.nvim_create_autocmd("FileType", {
				-- NOTE: You may or may not want java included here. You will need it if you
				-- want basic Java support but it may also conflict if you are using
				-- something like nvim-jdtls which also works on a java filetype autocmd.
				pattern = { "scala", "sbt", "java" },
				callback = function()
					require("metals").initialize_or_attach(metals_config)
				end,
				group = nvim_metals_group,
			})
		end,
	},
}
