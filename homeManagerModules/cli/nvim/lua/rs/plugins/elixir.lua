return {
	{
		"elixir-tools/elixir-tools.nvim",
		ft = { "elixir", "eelixir", "heex", "surface" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local lsp, elixir = require("rs.lsp"), require("elixir")

			elixir.setup({
				elixirls = {
					enable = true,
					cmd = vim.g.elixirls_path,
					on_attach = function(client, bufnr)
						lsp.custom_attach(client, bufnr)
						vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>efp", ":ElixirFromPipe<cr>", {
							desc = "[Elixirls] From pipe",
						})
						vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>etp", ":ElixirToPipe<cr>", {
							desc = "[Elixirls] To pipe",
						})
						vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>eem", ":ElixirExpandMacro<cr>", {
							desc = "[Elixirls] Expand macro",
						})
					end,
				},
			})
		end,
	},
}
