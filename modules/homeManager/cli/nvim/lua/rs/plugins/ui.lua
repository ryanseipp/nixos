return {
	{
		"catppuccin/nvim",
		name = "catppuccin-nvim",
		priority = 1000,
		opts = {
			integrations = {
				fidget = true,
				noice = true,
				notify = true,
			},
		},
		config = function()
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},
	-- {
	--     'rebelot/kanagawa.nvim',
	--     lazy = false,
	--     priority = 1000,
	--     config = function()
	--         vim.cmd.colorscheme('kanagawa')
	--     end,
	-- },
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {
			options = {
				theme = "catppuccin",
			},
		},
	},
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = true,
		init = function()
			vim.api.nvim_set_hl(0, "DashboardProjectTitle", { link = "DashboardCenter" })
			vim.api.nvim_set_hl(0, "DashboardProjectTitleIcon", { link = "DashboardIcon" })
			vim.api.nvim_set_hl(0, "DashboardProjectIcon", { link = "DashboardIcon" })
			vim.api.nvim_set_hl(0, "DashboardMruTitle", { link = "DashboardCenter" })
			vim.api.nvim_set_hl(0, "DashboardMruIcon", { link = "DashboardIcon" })
			vim.api.nvim_set_hl(0, "DashboardFiles", { link = "DashboardKey" })
		end,
		opts = {
			theme = "hyper",
			config = {
				week_header = {
					enable = true,
				},
				shortcut = {},
				footer = {
					"",
					"  Sharp tools make good work.",
				},
			},
		},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"muniftanjim/nui.nvim",
			"rcarriga/nvim-notify",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = false,
				lsp_doc_border = true,
			},
		},
	},
	{
		"stevearc/dressing.nvim",
		opts = {},
	},
	{
		"nvim-tree/nvim-tree.lua",
		keys = {
			{ "<leader>tt", "<cmd>NvimTreeToggle<cr>", desc = "NvimTreeToggle" },
			{ "<leader>tf", "<cmd>NvimTreeFocus<cr>", desc = "NvimTreeFocus" },
		},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			update_focused_file = {
				enable = true,
			},
			view = {
				width = 60,
			},
		},
	},
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
}
