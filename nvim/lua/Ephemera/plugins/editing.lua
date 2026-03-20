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
	--     "olrtg/nvim-emmet",
	--     config = function()
	--         vim.keymap.set({ "n", "v" }, '<leader>hw', require('nvim-emmet').wrap_with_abbreviation)
	--     end,
	--     ft = { "javascript", "jsx", "tsx", "typescript", "html", "css" }
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
	},

	-- compilation mode for nvim
	{
		"ej-shafran/compile-mode.nvim",
		version = "latest",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "m00qek/baleia.nvim", tag = "v1.3.0" },
		},
		-- Add your custom keymaps here:
		keys = {
			{
				"<F5>",
				function()
					-- Get the directory of the current file and the current working directory
					local current_dir = vim.fn.expand("%:p:h")
					local cwd = vim.fn.getcwd()

					-- Check if Makefile or makefile exists in either location
					local has_make = vim.fn.filereadable(current_dir .. "/Makefile") == 1
						or vim.fn.filereadable(current_dir .. "/makefile") == 1
						or vim.fn.filereadable(cwd .. "/Makefile") == 1
						or vim.fn.filereadable(cwd .. "/makefile") == 1

					-- Grab current options so we can safely modify them
					local opts = vim.g.compile_mode or {}

					if has_make then
						-- Set default to make for the current session/buffer
						opts.default_command = "make"
						vim.g.compile_mode = opts
					else
						-- select empty default string instead of the extension stuffs
						opts.default_command = ""
						vim.g.compile_mode = opts
					end

					-- Trigger compile (will prompt you, pre-filled with whatever we set above)
					vim.cmd("Compile")
				end,
				desc = "Smart Compile (Checks for Makefile)"
			},
			{ "<F6>",  "<cmd>Recompile<CR>", desc = "Recompile" },
			-- Error Navigation Keymaps (Alt+N for Next, Alt+P for Previous)
			{ "<A-N>", "<cmd>NextError<CR>", desc = "Next Compile Error" },
			{ "<A-P>", "<cmd>PrevError<CR>", desc = "Prev Compile Error" },
		},
		config = function()
			---@module "compile-mode"
			---@type CompileModeOpts
			vim.g.compile_mode = {
				default_command = "",
				-- Use `baleia` for parsing ANSI escape codes in the output.
				baleia_setup = true,
				bang_expansion = true,
				error_regexp_table = {},
				error_ignore_file_list = {},
				error_threshold = require("compile-mode").level.WARNING,
				auto_jump_to_first_error = true,
				error_locus_highlight = 500,
				use_diagnostics = false,
				recompile_no_fail = true,
				ask_about_save = true,
				ask_to_interrupt = true,
				buffer_name = "Compilation",
				time_format = "%a %b %e %H:%M:%S",
				hidden_output = {},
				environment = nil,
				clear_environment = false,
				input_word_completion = true,
				hidden_buffer = false,
				focus_compilation_buffer = true,
				auto_scroll = true,
				use_circular_error_navigation = true,
				debug = false,
				use_pseudo_terminal = false,
			}
		end
	}
}
