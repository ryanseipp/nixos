return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {},
	},
	{
		"ravitemer/mcphub.nvim",
		cmd = "MCPHub",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			cmd = vim.g.mcphub_path,
		},
	},
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"ravitemer/mcphub.nvim",
		},
		opts = {
			extensions = {
				mcphub = {
					callback = "mcphub.extensions.codecompanion",
					opts = {
						make_vars = true,
						make_slash_commands = true,
						show_result_in_chat = true,
					},
				},
			},
		},
	},
}
