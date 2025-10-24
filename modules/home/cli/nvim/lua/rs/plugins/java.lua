return {
	{
		"nvim-java/nvim-java",
		dependencies = {
			"nvim-java/nvim-java-core",
			"nvim-java/nvim-java-test",
			"nvim-java/nvim-java-dap",
			"nvim-java/nvim-java-refactor",
		},
		ft = { "java" },
		config = function()
			local lsp = require("rs.lsp")

			-- Must be called before lspconfig
			require("java").setup({
				-- Automatically install java-debug-adapter, java-test, spring-boot-tools
				-- These are installed via nvim-java automatically
				jdk = {
					auto_install = false, -- We're managing JDK via Nix
				},
				notifications = {
					-- Use snacks for notifications
					dap = true,
				},
				spring_boot_tools = {
					enable = true,
				},
				jdtls = {
					-- jdtls setup will be configured through lspconfig
				},
			})

			-- Configure jdtls after java.setup()
			require("lspconfig").jdtls.setup({
				on_attach = lsp.custom_attach,
				on_init = lsp.custom_init,
				capabilities = lsp.capabilities,
				settings = {
					java = {
						signatureHelp = { enabled = true },
						contentProvider = { preferred = "fernflower" },
						completion = {
							favoriteStaticMembers = {
								"org.junit.jupiter.api.Assertions.*",
								"org.junit.Assert.*",
								"org.mockito.Mockito.*",
								"org.mockito.ArgumentMatchers.*",
								"org.assertj.core.api.Assertions.*",
							},
							filteredTypes = {
								"com.sun.*",
								"io.micrometer.shaded.*",
								"java.awt.*",
								"jdk.*",
								"sun.*",
							},
						},
						sources = {
							organizeImports = {
								starThreshold = 9999,
								staticStarThreshold = 9999,
							},
						},
						codeGeneration = {
							toString = {
								template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
							},
							hashCodeEquals = {
								useJava7Objects = true,
							},
							useBlocks = true,
						},
						configuration = {
							runtimes = {
								{
									name = "JavaSE-25",
									path = vim.fn.getenv("JAVA_HOME") ~= "" and vim.fn.getenv("JAVA_HOME")
										or vim.fn.system("which java"):gsub("/bin/java\n", ""),
									default = true,
								},
							},
						},
					},
				},
			})
		end,
		keys = {
			{
				"<leader>jt",
				function()
					require("java").test.run_current_test_method()
				end,
				desc = "[Java] Run test method",
				silent = true,
			},
			{
				"<leader>jT",
				function()
					require("java").test.run_current_class()
				end,
				desc = "[Java] Run test class",
				silent = true,
			},
			{
				"<leader>jd",
				function()
					require("java").test.debug_current_test_method()
				end,
				desc = "[Java] Debug test method",
				silent = true,
			},
			{
				"<leader>jD",
				function()
					require("java").test.debug_current_class()
				end,
				desc = "[Java] Debug test class",
				silent = true,
			},
			{
				"<leader>jr",
				function()
					require("java").runner.run_app()
				end,
				desc = "[Java] Run application",
				silent = true,
			},
			{
				"<leader>jR",
				function()
					require("java").runner.debug_app()
				end,
				desc = "[Java] Debug application",
				silent = true,
			},
			{
				"<leader>js",
				function()
					require("java").runner.stop_app()
				end,
				desc = "[Java] Stop application",
				silent = true,
			},
			{
				"<leader>jo",
				"<cmd>JdtUpdateConfig<cr>",
				desc = "[Java] Update configuration",
				silent = true,
			},
			{
				"<leader>jc",
				"<cmd>JdtCompile<cr>",
				desc = "[Java] Compile project",
				silent = true,
			},
			{
				"<leader>jb",
				"<cmd>JdtBytecode<cr>",
				desc = "[Java] View bytecode",
				silent = true,
			},
			{
				"<leader>jv",
				function()
					require("jdtls").extract_variable()
				end,
				desc = "[Java] Extract variable",
				mode = { "n", "v" },
				silent = true,
			},
			{
				"<leader>jm",
				function()
					require("jdtls").extract_method(true)
				end,
				desc = "[Java] Extract method",
				mode = "v",
				silent = true,
			},
		},
	},
}
