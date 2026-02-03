return{
	-- for colours
	{ "uga-rosa/ccc.nvim" },

	--  for diagrams
	{ "jbyuki/venn.nvim", ft = { "markdown", "text" } },

	-- todo comment highlights
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
		}
	},

	-- render markdown
	{
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
		opts = {},
		ft = { "markdown", "text" }
	},

}
