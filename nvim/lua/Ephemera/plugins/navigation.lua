return {
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({

				default_file_explorer = false,
				-- The highlights above will automwtically color these columns

				columns = {
					"permissions",
					"size",
					"icon",
				},

				win_options = {
					wrap = false,
					signcolumn = "no",
					cursorcolumn = false,
					foldcolumn = "0",
					spell = false,
					list = false,
					conceallevel = 3,
					concealcursor = "nvic",
				},

				float = {
					padding = 2,
					max_width = 80,
					max_height = 0,
					border = "double",
					win_options = {
						winblend = 0,
					},
				},

				keymaps = {
					["g?"] = "actions.show_help",
					["<CR>"] = "actions.select",
					["<C-s>"] = "actions.select_vsplit",
					["<C-h>"] = "actions.select_split",
					["<C-t>"] = "actions.select_tab",
					["<C-p>"] = "actions.preview",
					["<Esc>"] = "actions.close",
					["<C-l>"] = "actions.refresh",
					["-"] = "actions.parent",
					["_"] = "actions.open_cwd",
					["`"] = "actions.cd",
					["~"] = "actions.tcd",
					["gs"] = "actions.change_sort",
					["gx"] = "actions.open_external",
					["g."] = "actions.toggle_hidden",
				},
				view_options = {
					show_hidden = true,
					sort = {
						{ "type", "asc" },
						{ "name", "asc" },
					},
				},
			})

			vim.keymap.set("n", "we", require("oil").toggle_float, { desc = "Toggle Oil Floating Window" })
		end,
	},

	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},

	-- Harpoon
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup({})
			local conf = require("telescope.config").values
			local function toggle_telescope(harpoon_files)
				local file_paths = {}
				for _, item in ipairs(harpoon_files.items) do table.insert(file_paths, item.value) end
				require("telescope.pickers").new({}, {
					prompt_title = "Harpoon",
					finder = require("telescope.finders").new_table({ results = file_paths }),
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
					initial_mode = "normal",
				}):find()
			end
			vim.keymap.set("n", "<leader>e", function() toggle_telescope(harpoon:list()) end,
				{ desc = "Open harpoon window" })
		end
	},

	-- fzf ik I got the telescope like shut the fuck up its my config
	{
		"junegunn/fzf.vim",
		dependencies = { "junegunn/fzf" },
		event = "VeryLazy",
	}

}
