return {
	--  for diagrams
	{ "jbyuki/venn.nvim" },

	-- render markdown
	{
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
		opts = {},
	},

	-- emoji nvim
	{
		"allaman/emoji.nvim",
		version = "1.0.0", -- optionally pin to a tag

		ft = "markdown", -- adjust to your needs
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
		},
		opts = {
			--- if you use the mini.nvim suite- default is false, also needed for blink.cmp integration!
			enable_cmp_integration = true,

		},
		config = function(_, opts)
			require("emoji").setup(opts)

			-- optional for telescope integration
			local ts = require('telescope').load_extension 'emoji'
			vim.keymap.set('n', '<leader>se', ts.emoji, { desc = '[S]earch [E]moji' })
		end,
	},


	-- markdown tools
	{
		"tadmccorkle/markdown.nvim",
		ft = "markdown", -- or 'event = "VeryLazy"'
		opts = {
		},
	}
}
