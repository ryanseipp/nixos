return {
	{
		"mfussenegger/nvim-dap",
		keys = {
			{
				"<F1>",
				function()
					require("dap").step_back()
				end,
				desc = "[DAP] Step back",
				silent = true,
			},
			{
				"<F2>",
				function()
					require("dap").step_into()
				end,
				desc = "[DAP] Step into scope",
				silent = true,
			},
			{
				"<F3>",
				function()
					require("dap").step_over()
				end,
				desc = "[DAP] Step over line",
				silent = true,
			},
			{
				"<F4>",
				function()
					require("dap").step_out()
				end,
				desc = "[DAP] Step out of scope",
				silent = true,
			},
			{
				"<F5>",
				function()
					require("dap").continue()
				end,
				desc = "[DAP] Continue debugger",
				silent = true,
			},
			{
				"<leader>do",
				function()
					require("dap").repl.open()
				end,
				desc = "[DAP] Open debugger REPL",
				silent = true,
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "[DAP] Toggle breakpoint",
				silent = true,
			},
			{
				"<leader>dbc",
				function()
					require("dap").set_breakpoint(vim.fn.input("[DAP] Condition > "))
				end,
				desc = "[DAP] Set breakpoint condition",
				silent = true,
			},
		},
		dependencies = {
			{
				"thehamsta/nvim-dap-virtual-text",
				opts = {
					enabled = true,
					enabled_commands = false,
					highlight_changed_variables = true,
					highlight_new_as_changes = true,
					commented = false,
					show_stop_reason = true,
				},
			},
			"rcarriga/nvim-dap-ui",
		},
		config = function()
			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "◎", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapStopped", { text = "➡", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "", linehl = "", numhl = "" })

			local dap, dapui = require("dap"), require("dapui")
			dap.defaults.fallback.external_terminal = {
				command = "/usr/bin/kitty",
			}

			dap.adapters.firefox = {
				type = "executable",
				command = "node",
				args = { os.getenv("HOME") .. "/.local/share/vscode-firefox-debug/dist/adapter.bundle.js" },
			}
			dap.configurations.typescript = {
				name = "Debug with Firefox",
				type = "firefox",
				request = "launch",
				reAttach = true,
				url = "http://localhost:8000",
				webRoot = "${workspaceFolder}",
				firefoxExecutable = "/usr/bin/firefox",
			}
			dap.configurations.typescriptreact = {
				name = "Debug with Firefox",
				type = "firefox",
				request = "launch",
				reAttach = true,
				url = "http://localhost:8000",
				webRoot = "${workspaceFolder}",
				firefoxExecutable = "/usr/bin/firefox",
			}

			dap.listeners.after.event_initialized.dapui_config = function()
				dapui.open()
			end

			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end

			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		keys = {
			{
				"<leader>de",
				function()
					require("dapui").eval()
				end,
				desc = "[DAP] eval",
			},
			{
				"<leader>dE",
				function()
					require("dapui").eval(vim.fn.input("[DAP] Expression > "))
				end,
				desc = "[DAP] eval expression",
			},
		},
		config = true,
	},
	{
		"leoluz/nvim-dap-go",
		ft = { "go" },
		dependencies = { "mfussenegger/nvim-dap" },
		opts = {},
	},
}
