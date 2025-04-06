---@module 'lspconfig'
local M = {}

--- add commands to run when init every langserver
--- @param client vim.lsp.Client
M.custom_init = function(client)
	client.config.flags = client.config.flags or {}
	client.config.flags.allow_incremental_sync = true
end

--- @alias keymap {[1]: string, [2]: string, [3]: fun()}
--- @param bufnr integer
--- @param keymaps keymap[]
local buf_set_keymaps = function(bufnr, keymaps)
	for _, v in ipairs(keymaps) do
		vim.api.nvim_buf_set_keymap(bufnr, "n", v[1], "", { desc = v[2], callback = v[3], noremap = true })
	end
end

local augroup_highlight = vim.api.nvim_create_augroup("custom-lsp-references", { clear = true })
local augroup_codelens = vim.api.nvim_create_augroup("custom-lsp-codelens", { clear = true })
local augroup_format = vim.api.nvim_create_augroup("custom-lsp-format", { clear = true })
local augroup_eslint_fixall = vim.api.nvim_create_augroup("custom-lsp-format", { clear = true })
local augroup_csharp_fiximports = vim.api.nvim_create_augroup("custom-lsp-fiximports", { clear = true })

local autocmd_format = function(async, filter)
	vim.api.nvim_clear_autocmds({ buffer = 0, group = augroup_format })
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = augroup_format,
		buffer = 0,
		callback = function()
			vim.lsp.buf.format({ async = async, filter = filter })
		end,
	})
end

local autocmd_eslint_fixall = function()
	vim.api.nvim_clear_autocmds({ buffer = 0, group = augroup_eslint_fixall })
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = augroup_eslint_fixall,
		buffer = 0,
		callback = function()
			local clients = vim.lsp.get_active_clients()
			for _, v in pairs(clients) do
				if v.name == "eslint" then
					vim.cmd([[ EslintFixAll ]])
				end
			end
		end,
	})
end

local autocmd_csharp_fiximports = function()
	vim.api.nvim_clear_autocmds({ buffer = 0, group = augroup_csharp_fiximports })
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = augroup_csharp_fiximports,
		buffer = 0,
		callback = function()
			require("csharp").fix_usings()
		end,
	})
end

-- add filetype specific commands here
--- @type table<string, fun(client:vim.lsp.Client)>
local filetype_attach = setmetatable({
	csharp = function(_)
		autocmd_format(false)
		autocmd_csharp_fiximports()
	end,
	javascript = function()
		autocmd_eslint_fixall()
	end,
	javascriptreact = function()
		autocmd_eslint_fixall()
	end,
	["javascript.jsx"] = function()
		autocmd_eslint_fixall()
	end,
	typescript = function()
		autocmd_eslint_fixall()
	end,
	typescriptreact = function()
		autocmd_eslint_fixall()
	end,
	["typescript.ts"] = function()
		autocmd_eslint_fixall()
	end,
}, {
	__index = function()
		return function() end
	end,
})

--- @param client vim.lsp.Client
--- @param bufnr integer
M.custom_attach = function(client, bufnr)
	local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

	vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

	-- Set autocommands conditional on server_capabilities
	if client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_clear_autocmds({ group = augroup_highlight, buffer = bufnr })
		vim.api.nvim_create_autocmd("CursorHold", {
			group = augroup_highlight,
			callback = vim.lsp.buf.document_highlight,
			buffer = bufnr,
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			group = augroup_highlight,
			callback = vim.lsp.buf.clear_references,
			buffer = bufnr,
		})
	end

	if client.server_capabilities.codeLensProvider then
		vim.api.nvim_clear_autocmds({ group = augroup_codelens, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufEnter", {
			group = augroup_codelens,
			callback = vim.lsp.codelens.refresh,
			buffer = bufnr,
			once = true,
		})
		vim.api.nvim_create_autocmd({ "BufWritePost", "CursorHold" }, {
			group = augroup_codelens,
			callback = vim.lsp.codelens.refresh,
			buffer = bufnr,
		})
	end

	-- Attach any filetype specific options to the client
	filetype_attach[filetype](client, bufnr)
end

M.capabilities = require("blink.cmp").get_lsp_capabilities({}, true)

local lua_runtime_path = vim.split(package.path, ";")
table.insert(lua_runtime_path, "lua/?.lua")
table.insert(lua_runtime_path, "lua/?/init.lua")

-- define lang server configs
M.servers = {
	-- ansiblels = true,
	astro = true,
	bashls = true,
	dockerls = true,
	gopls = true,
	ocamllsp = true,
	nixd = {
		-- settings = {
		-- 	nixd = {
		-- 		options = {
		-- 			nixos = {
		-- 				expr = "",
		-- 			},
		-- 		},
		-- 	},
		-- },
	},
	-- denols = {
	-- 	settings = {
	-- 		deno = {
	-- 			enable = vim.fs.root(0, "deno.json") ~= nil,
	-- 		},
	-- 	},
	-- },
	tailwindcss = {
		filetypes = {
			"aspnetcorerazor",
			"astro",
			"astro-markdown",
			"blade",
			"clojure",
			"django-html",
			"htmldjango",
			"edge",
			"eelixir",
			"elixir",
			"ejs",
			"erb",
			"eruby",
			"gohtml",
			"gohtmltmpl",
			"haml",
			"handlebars",
			"hbs",
			"html",
			"html-eex",
			"heex",
			"jade",
			"leaf",
			"liquid",
			"markdown",
			"mdx",
			"mustache",
			"njk",
			"nunjucks",
			"php",
			"razor",
			"slim",
			"twig",
			"css",
			"less",
			"postcss",
			"sass",
			"scss",
			"stylus",
			"sugarss",
			"javascript",
			"javascriptreact",
			"reason",
			"rescript",
			-- "rust",
			"typescript",
			"typescriptreact",
			"vue",
			"svelte",
			"templ",
		},
		init_options = {
			userLanguages = {
				rust = "html",
			},
		},
	},
	zls = true,
	clangd = {
		cmd = {
			"clangd",
			"--offset-encoding=utf-16",
		},
		init_options = {
			clangdFileStatus = true,
		},
	},
	eslint = {
		settings = {
			packageManager = "pnpm",
			format = false,
		},
	},
	omnisharp = {
		cmd = { vim.g.omnisharp_path },
		settings = {
			FormattingOptions = {
				EnableEditorConfigSupport = false,
				OrganizeImports = true,
			},
			RoslynExtensionsOptoins = {
				EnableAnalyzersSupport = true,
				EnableImportCompletion = true,
			},
		},
	},
	lua_ls = true,
	-- lua_ls = {
	-- 	on_init = function(client)
	-- 		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
	-- 			runtime = {
	-- 				-- Tell the language server which version of Lua you're using
	-- 				-- (most likely LuaJIT in the case of Neovim)
	-- 				version = "LuaJIT",
	-- 			},
	-- 			-- Make the server aware of Neovim runtime files
	-- 			workspace = {
	-- 				checkThirdParty = false,
	-- 				library = {
	-- 					vim.env.VIMRUNTIME,
	-- 					-- Depending on the usage, you might want to add additional paths here.
	-- 					-- "${3rd}/luv/library"
	-- 					-- "${3rd}/busted/library",
	-- 				},
	-- 				-- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
	-- 				-- library = vim.api.nvim_get_runtime_file("", true)
	-- 			},
	-- 		})
	-- 	end,
	-- 	settings = {
	-- 		Lua = {
	-- 			hint = {
	-- 				enable = true,
	-- 			},
	-- 		},
	-- 	},
	-- },
	yamlls = {
		settings = {
			yaml = {
				keyOrdering = false,
				schemas = {
					kubernetes = "*.yaml",
					["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
					["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
					["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
					["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
					["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
					["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
					["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
					["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
					["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
					["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
					["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
					["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
				},
			},
		},
	},
}

return M
