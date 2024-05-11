return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	cmd = "Telescope",
	keys = {
		-- dotfiles
		{
			"<leader>fn",
			function()
				require("telescope.builtin").find_files({
					prompt_title = "~ nvim ~",
					shorten_path = false,
					cwd = "~/nixos/homes/features/cli/nvim/",
				})
			end,
			desc = "find_nvim",
			silent = true,
		},
		{
			"<leader>fh",
			function()
				require("telescope.builtin").find_files({
					prompt_title = "~ home-manager ~",
					shorten_path = false,
					cwd = "~/nixos/homes/",
					hidden = true,
				})
			end,
			desc = "find_home_manager",
			silent = true,
		},

		-- files
		{
			"<leader>ff",
			function()
				require("telescope.builtin").find_files()
			end,
			desc = "find_files",
			silent = true,
		},
		{
			"<leader>fg",
			function()
				require("telescope.builtin").git_files()
			end,
			desc = "git_files",
			silent = true,
		},
		{
			"<leader>fs",
			function()
				require("telescope.builtin").live_grep()
			end,
			desc = "live_grep",
			silent = true,
		},

		-- git
		{
			"<leader>gs",
			function()
				require("telescope.builtin").git_status()
			end,
			desc = "git_status",
			silent = true,
		},
		{
			"<leader>gc",
			function()
				require("telescope.builtin").git_commits()
			end,
			desc = "git_commits",
			silent = true,
		},
		{
			"<leader>gb",
			function()
				require("telescope.builtin").git_branches()
			end,
			desc = "git_branches",
			silent = true,
		},

		-- nvim
		{
			"<leader>nb",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = "buffers",
			silent = true,
		},
		{
			"<leader>nj",
			function()
				require("telescope.builtin").jumplist()
			end,
			desc = "jumplist",
			silent = true,
		},
		{
			"<leader>nr",
			function()
				require("telescope.builtin").registers()
			end,
			desc = "registers",
			silent = true,
		},
		{
			"<leader>nc",
			function()
				require("telescope.builtin").commands()
			end,
			desc = "commands",
			silent = true,
		},
		{
			"<leader>ncc",
			function()
				require("telescope.builtin").colorscheme()
			end,
			desc = "colorscheme",
			silent = true,
		},
		{
			"<leader>nh",
			function()
				require("telescope.builtin").help_tags()
			end,
			desc = "help_tags",
			silent = true,
		},
		{
			"<leader>nk",
			function()
				require("telescope.builtin").keymaps()
			end,
			desc = "keymaps",
			silent = true,
		},
		{
			"<leader>nac",
			function()
				require("telescope.builtin").autocommands()
			end,
			desc = "autocommands",
			silent = true,
		},

		-- dap
		{
			"<leader>ldb",
			function()
				require("telescope").extensions.dap.list_breakpoints()
			end,
			desc = "[DAP] List debugger breakpoints",
			silent = true,
		},
	},
	dependencies = {
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			config = function()
				require("telescope").load_extension("fzf")
			end,
		},
		{
			"nvim-telescope/telescope-dap.nvim",
			config = function()
				require("telescope").load_extension("dap")
			end,
		},
	},
	opts = {
		extensions = {
			fzf = {
				fuzzy = true,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = "smart_case",
			},
		},
	},
}
