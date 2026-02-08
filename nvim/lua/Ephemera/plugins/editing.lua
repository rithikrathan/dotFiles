return {
	-- undotree
	{ "mbbill/undotree" },

	-- autopairs
	{
		'altermo/ultimate-autopair.nvim',
		event = { 'InsertEnter', 'CmdlineEnter' },
		branch = 'v0.6', --recommended as each new version will have breaking changes
		opts = {
			--Config goes here
		},
	},

	-- idk what this is i forgot
	{
		"Jezda1337/nvim-html-css",
		dependencies = { "hrsh7th/nvim-cmp", "nvim-treesitter/nvim-treesitter" },
		ft = { "javascript", "jsx", "tsx", "typescript", "html", "css" },
		config = function()
			require("html-css").setup({
				opts = {
					enable_on = { "html", "htmldjango", "tsx", "jsx", "svelte", "vue" },
					handlers = { definition = { bind = "gd" }, hover = { bind = "K", border = "single" } },
					style_sheets = { "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" }
				}
			})
		end
	}, -- html-css

	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		config = function()
			require('nvim-ts-autotag').setup({ opts = { enable_close = true, enable_rename = true } })
		end

	}, -- Autotag

	-- emmet
	{
		"olrtg/nvim-emmet",
		config = function()
			vim.keymap.set({ "n", "v" }, '<leader>hw', require('nvim-emmet').wrap_with_abbreviation)
		end,
		ft = { "javascript", "jsx", "tsx", "typescript", "html", "css" }
	},

	{
		"mattn/emmet-vim",
		ft = { "html", "css", "javascript", "typescript", "jsx", "tsx" },
		init = function()
			vim.g.user_emmet_leader_key = "]]" -- default
		end,
	},

	-- -- commentary
	-- { "tpope/vim-commentary" },

	-- flash
	-- TODO: idk this plugin gives me mixed feelings config it better
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {
			modes = {
				search = {
					enabled = true,
				},
			}
		},
		keys = {
			{ "<leader>fs", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
			{ "<leader>FS", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
			{ "<leader>fr", mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
			{ "<leader>fR", mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<C-s>",      mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
		},
	},

	-- multicursor
	-- TODO: learn to use all the things you can use with this thing
	-- > also add the mode text for this like MULTI CURSOR or something idk
	{
		"brenton-leighton/multiple-cursors.nvim",
		version = "*",
		opts = {
			custom_key_maps = {
				{ "n", "<Leader>al", function() require("multiple-cursors").align() end },
			}
		}, -- This causes the plugin setup function to be called

		keys = {
			{ "<A-c>", "<Cmd>MultipleCursorsAddDown<CR>",          mode = { "n", "x", "i" }, desc = "Add cursor and move down" },
			{ "<A-u>", "<Cmd>MultipleCursorsAddUp<CR>",            mode = { "n", "x", "i" }, desc = "Add cursor and move up" },

			{ "<A-x>", "<Cmd>MultipleCursorsMouseAddDelete<CR>",   mode = { "n", "i" },      desc = "Add or remove cursor" },

			{ "`n",    "<Cmd>MultipleCursorsAddVisualArea<CR>",    mode = { "x" },           desc = "Add cursors to the lines of the visual area" },

			{ "<C-n>", "<Cmd>MultipleCursorsAddMatches<CR>",       mode = { "n", "x" },      desc = "Add cursors to cword" },
			{ "<C-b>", "<Cmd>MultipleCursorsAddMatchesV<CR>",      mode = { "n", "x" },      desc = "Add cursors to cword in previous area" },

			{ "<A-m>", "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", mode = { "n", "i", "x" }, desc = "Add cursor and jump to next cword" },
			{ "`j",    "<Cmd>MultipleCursorsJumpNextMatch<CR>",    mode = { "n", "x" },      desc = "Jump to next cword" },

			{ "`l",    "<Cmd>MultipleCursorsLock<CR>",             mode = { "n", "x" },      desc = "Lock virtual cursors" },
		},
	},

	-- luasnip
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets", "saadparwaiz1/cmp_luasnip" },
		config = function()
			local ls = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/additional files/snippets/" })
			-- vim.keymap.set({ "i" }, "<leader>fk", function() ls.expand() end)
			-- vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end)
			-- vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end)
		end
	}


}
