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
		event = "VeryLazy",
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
		-- event = "InsertEnter",
		event = "VeryLazy",
		config = function()
			require('nvim-ts-autotag').setup({ opts = { enable_close = true, enable_rename = true } })
		end

	}, -- Autotag

	-- emmet
	-- {
	-- 	"olrtg/nvim-emmet",
	-- 	config = function()
	-- 		vim.keymap.set({ "n", "v" }, '<leader>hw', require('nvim-emmet').wrap_with_abbreviation)
	-- 	end,
	-- 	ft = { "javascript", "jsx", "tsx", "typescript", "html", "css" }
	-- },

	{
		"mattn/emmet-vim",
		ft = { "html", "css", "javascript", "typescript", "jsx", "tsx" },
		event = "VeryLazy",
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

	-- luasnip
	{
		"L3MON4D3/LuaSnip",
		event = "VeryLazy",
		dependencies = { "rafamadriz/friendly-snippets", "saadparwaiz1/cmp_luasnip" },
		config = function()
			local ls = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/additional files/snippets/" })
			-- vim.keymap.set({ "i" }, "<leader>fk", function() ls.expand() end)
			-- vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end)
			-- vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end)
		end
	},

	-- commentary
	{
		"folke/ts-comments.nvim",
	},

	-- surround
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup()
		end
	},

	-- mini move
	{
		'nvim-mini/mini.move',
		version = '*',
		mappings = {
			left = '<A-h>',
			right = '<A-l>',
			down = '<A-j>',
			up = '<A-k>',
			line_left = '',
			line_right = '',
			line_down = '',
			line_up = '',
		},

		options = {
			reindent_linewise = true
		},

		config = function()
			require('mini.move').setup()
		end
	}

}
