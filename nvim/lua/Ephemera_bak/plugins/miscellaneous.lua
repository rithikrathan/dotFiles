return{
	{ 'ThePrimeagen/vim-be-good'}, -- Game to learn vim

	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true,
		ft = { "javascript", "jsx", "tsx", "typescript", "html", "css" }
	}, -- Autopairs

	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter"
	}, -- Autotag for the html and stuffs

	{
		"nvim-tree/nvim-web-devicons",
		lazy = false,
	} -- devicons

}
