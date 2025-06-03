return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"mrcjkb/rustaceanvim",
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{
				"<leader>tr",
				function()
					require("neotest").run.run()
				end,
				desc = "[Test] Run the nearest test",
				silent = true,
			},
			{
				"<leader>trf",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "[Test] Run all tests in the current file",
				silent = true,
			},
			{
				"<leader>td",
				function()
					require("neotest").run.run({ strategy = "dap" })
				end,
				desc = "[Test] Debug the nearest test",
				silent = true,
			},
			{
				"<leader>ta",
				function()
					require("neotest").run.attach()
				end,
				desc = "[Test] Attach to the nearest test",
				silent = true,
			},
			{
				"<leader>tw",
				function()
					require("neotest").watch.toggle(vim.fn.expand("%"))
				end,
				desc = "[Test] Toggles watching tests in the file, running them when related files change",
				silent = true,
			},
			{
				"<leader>ts",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "[Test] Toggles the neotest summary window",
				silent = true,
			},
			{
				"<leader>to",
				function()
					require("neotest").output.open()
				end,
				desc = "[Test] Show the result of the test",
				silent = true,
			},
		},
		---@module 'neotest'
		---@type neotest.Config
		opts = {
			adapters = {
				require("rustaceanvim.neotest"),
			},
		},
	},
}
