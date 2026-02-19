return {
	{
		"github/copilot.vim",
		config = function()
			-- Accept suggestion with Alt+i
			vim.keymap.set("i", "<A-i>", 'copilot#Accept("\\<CR>")', {
				expr = true,
				silent = true,
				replace_keycodes = false,
			})

			-- Next suggestion with Alt+l
			vim.keymap.set("i", "<A-l>", "<Plug>(copilot-next)")
		end,
	},
}
