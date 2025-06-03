return {
	{
		"windwp/nvim-autopairs",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			check_ts = true,
		},
	},
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"numtostr/comment.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = true,
	},
}
