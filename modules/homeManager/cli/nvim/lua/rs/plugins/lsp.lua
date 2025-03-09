return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{
				"j-hui/fidget.nvim",
				opts = {
					notification = {
						window = {
							winblend = 0,
						},
					},
				},
			},
		},
		config = function()
			local lspconfig = require("lspconfig")
			local lsp = require("rs.lsp")

			local setup_server = function(server, config)
				if not config then
					return
				end

				if type(config) ~= "table" then
					config = {}
				end

				config = vim.tbl_deep_extend("force", {
					on_init = lsp.custom_init,
					on_attach = lsp.custom_attach,
					capabilities = lsp.capabilities,
					flags = {
						debounce_text_changes = 50,
					},
				}, config)

				lspconfig[server].setup(config)
			end

			for server, config in pairs(lsp.servers) do
				setup_server(server, config)
			end
		end,
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
}
