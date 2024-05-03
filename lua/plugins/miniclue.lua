return {
	{
		"echasnovski/mini.clue",
		version = false,
		enabled = true,
		lazy = false,
		config = function()
			local miniclue = require("mini.clue")
			miniclue.setup({
				triggers = {
					-- Leader triggers
					{ mode = "n", keys = "<Leader>" },
					{ mode = "x", keys = "<Leader>" },

					-- Built-in completion
					{ mode = "i", keys = "<C-x>" },

					-- `g` key
					{ mode = "n", keys = "g" },
					{ mode = "x", keys = "g" },

					-- Marks
					{ mode = "n", keys = "'" },
					{ mode = "n", keys = "`" },
					{ mode = "x", keys = "'" },
					{ mode = "x", keys = "`" },

					-- Registers
					{ mode = "n", keys = '"' },
					{ mode = "x", keys = '"' },
					{ mode = "i", keys = "<C-r>" },
					{ mode = "c", keys = "<C-r>" },

					-- Window commands
					{ mode = "n", keys = "<C-w>" },

					-- `z` key
					{ mode = "n", keys = "z" },
					{ mode = "x", keys = "z" },

					-- [ and ] keys:
					{ mode = "n", keys = "[" },
					{ mode = "x", keys = "[" },
					{ mode = "n", keys = "]" },
					{ mode = "x", keys = "]" },

					{ mode = "n", keys = "<C>" },
					{ mode = "x", keys = "<C>" },
				},

				clues = {
					{ mode = "n", keys = "<leader>b", desc = "+Buffers" },
					{ mode = "n", keys = "<leader>c", desc = "+Code" },
					{ mode = "n", keys = "<leader><tab>", desc = "+Tabs" },
					{ mode = "n", keys = "<leader>D", desc = "+Debug" },
					{ mode = "n", keys = "<leader>f", desc = "+file/find" },
					{ mode = "n", keys = "<leader>g", desc = "+git" },
					{ mode = "n", keys = "<leader>gh", desc = "+diffs" },
					{ mode = "n", keys = "<leader>m", desc = "+markdown" },
					{ mode = "n", keys = "<leader>q", desc = "+quit/session" },
					{ mode = "n", keys = "<leader>s", desc = "+search" },
					{ mode = "n", keys = "<leader>t", desc = "+test" },
					{ mode = "n", keys = "<leader>u", desc = "+ui" },
					{ mode = "n", keys = "<leader>w", desc = "+windows" },
					{ mode = "n", keys = "<leader>x", desc = "+diagnostics/quickfix" },
					{ mode = "n", keys = "gz", desc = "+surround" },

					-- Enhance this by adding descriptions for <Leader> mapping groups
					miniclue.gen_clues.builtin_completion(),
					miniclue.gen_clues.g(),
					miniclue.gen_clues.marks(),
					miniclue.gen_clues.registers(),
					miniclue.gen_clues.windows(),
					miniclue.gen_clues.z(),
				},
				window = {
					-- Floating window config
					config = {
						width = "auto",
						-- delay = 500,
						col = 150, -- vim.api.nvim_win_get_width(vim.api.nvim_get_current_win()) / 3,
						row = 30, -- vim.api.nvim_win_get_height(vim.api.nvim_get_current_win()) / 3,
					},

					-- Delay before showing clue window
					delay = 500,

					-- Keys to scroll inside the clue window
					scroll_down = "<C-d>",
					scroll_up = "<C-u>",
				},
			})
		end,
	},
}
