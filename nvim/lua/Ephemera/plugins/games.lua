return {
	{ 'ThePrimeagen/vim-be-good' }, -- Game to learn vim
	{ "Maelwalser/speed-motion.nvim" },

	{
		"ryansaxe/buffergolf.nvim",
		dependencies = { "nvim-mini/mini.diff" },
		opts = {
			-- Default values shown, all are optional
			disabled_plugins = "auto", -- auto-detect and disable conflicting plugins
			auto_dedent = true, -- auto-dedent practice buffer for consistent indentation
			keymaps = {
				toggle = "<leader>bg",
				countdown = "<leader>bG",
				golf = {
					next_hunk = "]h",
					prev_hunk = "[h",
					first_hunk = "[H",
					last_hunk = "]H",
					toggle_overlay = "<leader>do",
				},
			},
			windows = {
				reference = {
					position = "right", -- "right", "left", "top", "bottom"
					size = 50, -- width for left/right, height for top/bottom
				},
				stats = {
					position = "top", -- "top" or "bottom"
					height = 3,
				},
			},
			-- Mode-specific overrides
			typing_mode = {
				disabled_plugins = {
					matchparen = true, -- disable match parens in typing mode
					treesitter_context = true, -- disable context in typing mode
				},
			},
			golf_mode = {
				disabled_plugins = {
					matchparen = false, -- keep match parens in golf mode
				},
			},
		},
	}
}
