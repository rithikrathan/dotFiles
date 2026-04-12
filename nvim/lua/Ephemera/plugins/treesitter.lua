-- Treesitter
return {
	{ "nvim-treesitter/nvim-treesitter",             build = ":TSUpdate", lazy = false },
	{ "nvim-treesitter/nvim-treesitter-textobjects", dependencies = "nvim-treesitter/nvim-treesitter", lazy = false },
}
