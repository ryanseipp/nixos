local M = {}

--- add commands to run when init every langserver
--- @param client lsp.Client
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
--- @type table<string, fun(client:lsp.Client, bufnr:integer)>
local filetype_attach = setmetatable({
	csharp = function(_, bufnr)
		autocmd_format(false)
		autocmd_csharp_fiximports()
		buf_set_keymaps(bufnr, {
			{
				"<leader>dr",
				"[DAP] Debugger runnables",
				function()
					require("csharp").debug_project()
				end,
			},
			{
				"gd",
				"[LSP] Go to definition",
				function()
					require("csharp").go_to_definition()
				end,
			},
		})
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
	--- @param bufnr integer
	rust = function(_, bufnr)
		buf_set_keymaps(bufnr, {
			{
				"<leader>dr",
				"[DAP] Debugger runnables",
				function()
					vim.cmd.RustLsp("debuggables")
				end,
			},
			{
				"<leader>rr",
				"[LSP] Run runnables",
				function()
					vim.cmd.RustLsp("runnables")
				end,
			},
			{
				"<leader>me",
				"[LSP] Rust macro expand",
				function()
					vim.cmd.RustLsp("expandMacro")
				end,
			},
			{
				"<leader>mr",
				"[LSP] Rust macro rebuild",
				function()
					vim.cmd.RustLsp("rebuildProcMacros")
				end,
			},
		})
	end,
	go = function(_, bufnr)
		buf_set_keymaps(bufnr, {
			{
				"<leader>dt",
				"[DAP] Debug test under cursor",
				function()
					require("dap-go").debug_test()
				end,
			},
		})
	end,
}, {
	__index = function()
		return function() end
	end,
})

--- @param client lsp.Client
--- @param bufnr integer
M.custom_attach = function(client, bufnr)
	local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

	buf_set_keymaps(bufnr, {
		{ "gd", "[LSP] Go to definition", vim.lsp.buf.definition },
		{ "gD", "[LSP] Go to declaration", vim.lsp.buf.declaration },
		{ "gT", "[LSP] Go to type definition", vim.lsp.buf.type_definition },
		{
			"gr",
			"[LSP] Go to references",
			function()
				require("telescope")["lsp_references"]()
			end,
		},
		{
			"gi",
			"[LSP] Go to implementations",
			function()
				require("telescope")["lsp_implementations"]()
			end,
		},
		{ "K", "[LSP] Show more information", vim.lsp.buf.hover },
		-- { "<c-k>", "[LSP] Show signature help", vim.lsp.buf.signature_help },
		{ "<leader>rn", "[LSP] Rename", vim.lsp.buf.rename },
		{ "[d", "[LSP] Go to next diagnostic", vim.diagnostic.goto_next },
		{ "]d", "[LSP] Go to previous diagnostic", vim.diagnostic.goto_prev },
		{ "<leader>ca", "[LSP] View code actions", vim.lsp.buf.code_action },
		{
			"<leader>rr",
			"[LSP] Restart LSP Server",
			function()
				vim.cmd([[ LspRestart ]])
			end,
		},
	})

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

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
updated_capabilities.textDocument.codeLens = { dynamicRegistration = false }
updated_capabilities = require("cmp_nvim_lsp").default_capabilities(updated_capabilities)

M.capabilities = updated_capabilities

local lua_runtime_path = vim.split(package.path, ";")
table.insert(lua_runtime_path, "lua/?.lua")
table.insert(lua_runtime_path, "lua/?/init.lua")

-- define lang server configs
M.servers = {
	-- ansiblels = true,
	astro = true,
	bashls = true,
	dockerls = true,
	elixirls = true,
	gopls = true,
	ocamllsp = true,
	nixd = true,
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
		enable_editorconfig_support = false,
		enable_import_completion = true,
	},
	lua_ls = true,
	yamlls = {
		settings = {
			yaml = {
				keyOrdering = false,
			},
		},
	},
}

return M
