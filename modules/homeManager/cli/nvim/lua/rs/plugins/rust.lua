return {
	{
		"mrcjkb/rustaceanvim",
		lazy = false,
		keys = {
			{
				"<leader>rd",
				function()
					vim.cmd.RustLsp("debug")
				end,
				desc = "[Rust] Debug target under cursor",
				silent = true,
			},
			{
				"<leader>rds",
				function()
					vim.cmd.RustLsp("debuggables")
				end,
				desc = "[Rust] Search for debuggables",
				silent = true,
			},
			{
				"<leader>rr",
				function()
					vim.cmd.RustLsp("run")
				end,
				desc = "[Rust] Run target under cursor",
				silent = true,
			},
			{
				"<leader>rrs",
				function()
					vim.cmd.RustLsp("runnables")
				end,
				desc = "[Rust] Search for runnables",
				silent = true,
			},
			{
				"<leader>rts",
				function()
					vim.cmd.RustLsp("testables")
				end,
				desc = "[Rust] Search for testables",
				silent = true,
			},
			{
				"<leader>rem",
				function()
					vim.cmd.RustLsp("expandMacro")
				end,
				desc = "[Rust] Expand macro",
				silent = true,
			},
			{
				"<leader>rd",
				function()
					vim.cmd.RustLsp({ "renderDiagnostic", "cycle" })
				end,
				desc = "[Rust] Show diagnostics output by the compiler",
				silent = true,
			},
		},
		init = function()
			local lsp = require("rs.lsp")

			vim.g.rustaceanvim = {
				server = {
					on_attach = lsp.custom_attach,
					settings = {
						["rust-analyzer"] = {
							cargo = {
								buildScripts = {
									enable = true,
								},
								features = "all",
							},
							checkOnSave = {
								command = "clippy",
							},
						},
					},
				},
			}
		end,
	},
	{
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		keys = {
			{
				"<leader>pc",
				function()
					require("crates").show_crate_popup()
				end,
				desc = "[Crates] Show crate popup",
				silent = true,
			},
			{
				"<leader>pd",
				function()
					require("crates").show_dependencies_popup()
				end,
				desc = "[Crates] Show dependencies popup",
				silent = true,
			},
			{
				"<leader>pf",
				function()
					require("crates").show_features_popup()
				end,
				desc = "[Crates] Show features popup",
				silent = true,
			},
			{
				"<leader>pv",
				function()
					require("crates").show_versions_popup()
				end,
				desc = "[Crates] Show versions popup",
				silent = true,
			},
		},
		config = function()
			local lsp = require("rs.lsp")
			require("crates").setup({
				lsp = {
					enabled = true,
					actions = true,
					hover = true,
					completion = true,
					on_attach = lsp.custom_attach,
				},
			})
		end,
	},
}
