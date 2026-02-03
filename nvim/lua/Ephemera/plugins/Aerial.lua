return {
	{
		'stevearc/aerial.nvim',

		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons"
		},

		keys = {
			{ "<leader>at", "<cmd>AerialToggle!<CR>", desc = "Toggle Aerial" },
		},

		config = function()
			require("aerial").setup({
				-- Buffer-local keymaps (only set when aerial attaches)
				on_attach = function(bufnr)
					vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
					vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
				end,

				lazy_load = true,
				backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },
				default_direction = "prefer_left",
				manage_folds = true,
				link_tree_to_folds = true,
				nerd_font = "auto",
				open_automatic = true,
				post_jump_cmd = "normal! zt",
				show_guides = true,

				guides = {
					mid_item = "├─",
					last_item = "└─",
					nested_top = "│ ",
					whitespace = "  ",
				},

				lsp = {
					diagnostics_trigger_update = false,
					update_when_errors = true,
					update_delay = 300,
				},

				treesitter = { update_delay = 300 },
				markdown = { update_delay = 300 },
				asciidoc = { update_delay = 300 },
				man = { update_delay = 300 },
			})
		end
	}
}
