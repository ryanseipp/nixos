return {
	{
		"mrcjkb/rustaceanvim",
		version = "^3",
		ft = { "rust" },
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
		dependencies = {
			"nvimtools/none-ls.nvim",
		},
		config = function()
			local lsp = require("rs.lsp")
			require("null-ls").setup({
				on_init = lsp.custom_init,
				on_attach = function(client, bufnr)
					lsp.custom_attach(client, bufnr)
					vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>pc", "", {
						desc = "[Crates] Show crate popup",
						callback = function()
							require("crates").show_crate_popup()
						end,
					})
					vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>pd", "", {
						desc = "[Crates] Show dependencies popup",
						callback = function()
							require("crates").show_dependencies_popup()
						end,
					})
					vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>pf", "", {
						desc = "[Crates] Show features popup",
						callback = function()
							require("crates").show_features_popup()
						end,
					})
					vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>pv", "", {
						desc = "[Crates] Show versions popup",
						callback = function()
							require("crates").show_versions_popup()
						end,
					})
				end,
			})
			require("crates").setup({
				null_ls = { enabled = true },
			})
		end,
	},
}
