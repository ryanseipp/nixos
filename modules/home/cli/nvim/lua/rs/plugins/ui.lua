return {
	{
		"catppuccin/nvim",
		name = "catppuccin-nvim",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				transparent_background = true,
				integrations = {
					fidget = true,
					noice = true,
					notify = true,
					blink_cmp = true,
					snacks = true,
				},
			})
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		---@module 'lualine'
		opts = {
			options = {
				theme = "catppuccin",
			},
		},
	},
	-- {
	-- 	"folke/noice.nvim",
	-- 	event = "VeryLazy",
	-- 	dependencies = {
	-- 		"muniftanjim/nui.nvim",
	-- 		"rcarriga/nvim-notify",
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 	},
	-- 	---@module 'noice'
	-- 	---@type NoiceConfig
	-- 	opts = {
	-- 		lsp = {
	-- 			override = {
	-- 				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
	-- 				["vim.lsp.util.stylize_markdown"] = true,
	-- 				["cmp.entry.get_documentation"] = true,
	-- 			},
	-- 		},
	-- 		presets = {
	-- 			bottom_search = true,
	-- 			command_palette = true,
	-- 			long_message_to_split = true,
	-- 			inc_rename = false,
	-- 			lsp_doc_border = true,
	-- 		},
	-- 	},
	-- },
	{
		"knubie/vim-kitty-navigator",
		cmd = {
			"KittyNavigateLeft",
			"KittyNavigateDown",
			"KittyNavigateUp",
			"KittyNavigateRight",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>KittyNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>KittyNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>KittyNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>KittyNavigateRight<cr>" },
		},
	},
	{
		"meanderingprogrammer/render-markdown.nvim",
		ft = { "markdown", "codecompanion" },
	},
	{
		"echasnovski/mini.diff",
		config = function()
			local diff = require("mini.diff")
			diff.setup({
				-- Disabled by default
				source = diff.gen_source.none(),
			})
		end,
	},
}
