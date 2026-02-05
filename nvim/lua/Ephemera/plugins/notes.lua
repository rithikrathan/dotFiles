return{
	-- for colours
	{
		"uga-rosa/ccc.nvim",
		config = function()
			local ccc = require("ccc")
			local _mapping = ccc.mapping
			ccc.setup({
				highlighter = {
					auto_enable = false,
					lsp = true,
				},
			})
		end
	},

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
		ft = { "markdown"}
	},

}
