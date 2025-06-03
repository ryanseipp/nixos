return {
	"pmizio/typescript-tools.nvim",
	ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	opts = function()
		local lsp = require("rs.lsp")
		return {
			on_init = lsp.custom_init,
			on_attach = lsp.custom_attach,
		}
	end,
}
