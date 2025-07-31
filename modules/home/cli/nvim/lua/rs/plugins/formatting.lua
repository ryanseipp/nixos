return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		{
			"<leader>rf",
			function()
				require("conform").format({
					lsp_fallback = true,
					async = false,
				})
			end,
			mode = { "n", "v" },
			desc = "Format file or range (in visual mode)",
		},
	},
	config = function()
		local conform = require("conform")
		local prettier_fts = {
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
			"svelte",
			"css",
			"html",
			"json",
			"jsonc",
			"yaml",
			"markdown",
		}

		local formatters_by_ft = {
			c = { "clang_format" },
			cs = { "csharpier" },
			lua = { "stylua" },
			nix = { "nixfmt" },
			ocaml = { "ocamlformat" },
			rust = { "leptosfmt", "rustfmt", "rustywind" },
			sh = { "beautysh" },
			bash = { "beautysh" },
			zsh = { "beautysh" },
		}

		for _, value in ipairs(prettier_fts) do
			formatters_by_ft[value] = { "prettier", "rustywind" }
		end

		conform.setup({
			formatters = {
				shfmt = {
					prepend_args = { "-i", "4" },
				},
				prettier = {
					prepend_args = function(_, ctx)
						local ft = vim.bo[ctx.buf].filetype
						if ft == "markdown" then
							return { "--prose-wrap", "always" }
						end

						return {}
					end,
				},
			},
			formatters_by_ft = formatters_by_ft,
			format_on_save = {
				lsp_fallback = true,
				async = false,
			},
		})
	end,
}
