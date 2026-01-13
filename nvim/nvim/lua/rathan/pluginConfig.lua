--- if you use the mini.nvim suite- ==========================================================================
-- 1. COLORSCHEME & UI
-- ==========================================================================
local csName = "darkvoid"
local colorScheme = require(csName)
local istransparent = true

vim.api.nvim_create_user_command("ToggleTransparency",
	function()
		istransparent = not istransparent
		colorScheme.setup({
			transparent = istransparent,
		})
		vim.cmd("colorscheme " .. csName)
		require("lualine").setup({
			options = {
				theme = "Ra-lualine",
			},
		})
	end, {}
)

colorScheme.setup({
	transparent = istransparent,
	glow = istransparent,
	show_end_of_buffer = true,
	colors = {
		fg = "#ffeeee",
		bg = "#040409",
		cursor = "#ffa0a0",
		line_nr = "#ff1010",
		visual = "#690202",
		comment = "#696969",
		string = "#e4b2ab",
		func = "#ff6347",
		kw = "#ff5555",
		identifier = "#d2d2d2",
		type = "#ff420f",
		type_builtin = "#ff420f",
		search_highlight = "#ffaa00",
		operator = "#d63e3e",
		bracket = "#ffeeee",
		preprocessor = "#4b8902",
		bool = "#ffa07a",
		constant = "#f59064",
		added = "#baffc9",
		changed = "#ffffba",
		removed = "#ffb3ba",
		pmenu_bg = "#1c1c1f",
		pmenu_sel_bg = "#fa3e19",
		pmenu_fg = "#fc6142",
		eob = "#3c3c3c",
		border = "#ff1e00",
		title = "#ff1e00",
		bufferline_selection = "#fd7d1b",
		error = "#ff0000",
		warning = "#ffee00",
		hint = "#00ffee",
		info = "#14ff6a",
		plugins = {
			gitsigns = true,
			nvim_cmp = true,
			treesitter = true,
			nvimtree = true,
			telescope = true,
			lualine = true,
			bufferline = true,
			oil = true,
			whichkey = true,
			nvim_notify = true,
		},
	},
})
vim.cmd("colorscheme darkvoid")

-- Lualine
require("lualine").setup({
	options = {
		icons_enabled = true,
		-- theme = "ayu_dark",
		-- theme = "codedark",
		theme = "Ra-lualine",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		always_divide_middle = true,
		always_show_tabline = true,
		globalstatus = true,
		refresh = { statusline = 100, tabline = 100, winbar = 100 },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "filename", "aerial" },
		lualine_c = { "searchcount" },
		lualine_x = { "fileformat", "encoding" },
		lualine_y = { "diagnostics", "progress", "location", "filetype" },
		lualine_z = { "mode" },
	},
})

-- Treesitter
require("nvim-treesitter.configs").setup({
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "python", "cpp", "java", "gdscript" },
	sync_install = false,
	auto_install = true,
	highlight = { enable = true, additional_vim_regex_highlighting = false },
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = { ["af"] = "@function.outer", ["if"] = "@function.inner", ["ac"] = "@class.outer", ["ic"] = "@class.inner" }
		}
	},
	move = {
		enable = true,
		goto_next_start = { ["]m"] = "@function.outer" },
		goto_previous_start = { ["[m"] = "@function.outer" }
	}
})

-- Harpoon
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
vim.keymap.set("n", "<leader>e", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })

-- UndoTree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- ==========================================================================
-- 2. MODERN LSP (Update for 0.11+)
-- ==========================================================================
local mason = require("mason")
local masonConf = require("mason-lspconfig")

mason.setup({ ui = { border = "rounded" }, registries = { "github:mason-org/mason-registry" } })

-- Define capabilities globally for all future configs
local caps = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(),
	require("cmp_nvim_lsp").default_capabilities())
vim.lsp.config("*", { capabilities = caps })

-- clangd
vim.lsp.config("clangd", {
	cmd = { "clangd", "--compile-commands-dir=" .. vim.loop.cwd() },
	filetypes = { "c", "cpp", "objc", "objcpp", "ino" },
	init_options = { usePlaceholders = true, completeUnimported = true },
})

-- arduino
vim.lsp.config("arduino_language_server", {
	cmd = {
		"arduino-language-server",
		"-clangd", "/home/godz/.local/share/nvim/mason/bin/clangd",
		"-clangd", "/usr/bin/clangd",
		"-cli", "/home/godz/.local/bin/arduino-cli",
		"-cli-config", "/home/godz/.arduino15/arduino-cli.yaml",
		"-fqbn", "esp8266:esp8266:nodemcuv2"
	},
})

-- verible
vim.lsp.config("verible", {
	cmd = { "verible-verilog-ls", "--indentation_spaces=0", "--rules_config_search" },
	filetypes = { "verilog", "systemverilog" },
})

-- Enable servers (replacing handlers)
masonConf.setup({ ensure_installed = { "clangd", "jdtls", "verible" } })
vim.lsp.enable({ "clangd", "arduino_language_server", "verible", "jdtls", "gdscript" })

-- Verilog Auto-format
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.v", "*.sv" },
	callback = function() vim.lsp.buf.format({ async = false }) end,
})

-- ==========================================================================
-- 3. COMPLETION (Restored nvim-cmp logic)
-- ==========================================================================
local cmp = require("cmp")
local lspkind = require('lspkind')
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

cmp.setup({
	snippet = { expand = function(args) vim.snippet.expand(args.body) end },
	formatting = {
		format = lspkind.cmp_format({
			mode = 'text_symbol',
			maxwidth = { menu = 50, abbr = 50 },
			ellipsis_char = '...',
			show_labelDetails = true,
			before = function(entry, vim_item)
				if entry.source.name == "html-css" then
					vim_item.menu = "[" .. (entry.completion_item.provider or "html-css") .. "]"
				end
				return vim_item
			end
		})
	},
	mapping = cmp.mapping.preset.insert({
		["<A-k>"] = cmp.mapping.select_prev_item({ behavior = "select" }),
		["<A-j>"] = cmp.mapping.select_next_item({ behavior = "select" }),
		["<A-i>"] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace }),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
	}),
	sources = {
		{ name = "nvim_lsp" }, { name = "verible" }, { name = "path" },
		{ name = "buffer" }, { name = "luasnip" }, { name = "html-css" },
		{ name = "emoji" }, { name = "dictionary" }
	},
})

cmp.setup.filetype("go", {
	preselect = cmp.PreselectMode.None,
	completion = { completeopt = "menu,menuone,noinsert,noselect" },
})
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- ==========================================================================
-- 4. MINIMAP HIGHLIGHTS (Restored)
-- ==========================================================================
vim.cmd("highlight minimapCursor ctermbg=59 ctermfg=228 guibg=#5F5F5F guifg=#ff5555")
vim.cmd("highlight minimapCursor ctermbg=238 ctermfg=228 guibg= #121212 guifg = #d70000")
vim.cmd("highlight minimapRange ctermbg=242 ctermfg=228 guibg= #262626 guifg = #ff5555")
vim.cmd("highlight minimapDiffRemoved ctermfg=197 guifg=#c70a52")
vim.cmd("highlight minimapDiffAdded ctermfg=148 guifg=#82b500")
vim.cmd("highlight minimapDiffLine ctermfg=141 guifg=#9162f0")
vim.cmd("highlight minimapCursorDiffRemoved ctermbg=59 ctermfg=197 guibg=#5F5F5F guifg=#FC1A70")
vim.cmd("highlight minimapCursorDiffAdded ctermbg=59 ctermfg=148 guibg=#5F5F5F guifg=#A4E400")
vim.cmd("highlight minimapCursorDiffLine ctermbg=59 ctermfg=141 guibg=#5F5F5F guifg=#AF87FF")
vim.cmd("highlight minimapRangeDiffRemoved ctermbg=242 ctermfg=197 guibg=#4F4F4F guifg=#FC1A70")
vim.cmd("highlight minimapRangeDiffAdded ctermbg=242 ctermfg=148 guibg=#4F4F4F guifg=#A4E400")
vim.cmd("highlight minimapRangeDiffLine ctermbg=242 ctermfg=141 guibg=#4F4F4F guifg=#AF87FF")

-- ==========================================================================
-- 5. OTHER PLUGINS & KEYMAPS (Restored)
-- ==========================================================================
-- LuaSnip
local ls = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/additional files/snippets/" })
vim.keymap.set({ "i" }, "<leader>fk", function() ls.expand() end)
vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end)
vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end)

-- Conform
local conform = require("conform")
conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		verilog = { "istyle" },
		systemverilog = { "istyle" },
	},
	format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
})
vim.keymap.set("n", "<leader>fo", function() conform.format({ lsp_fallback = true, async = false, timeout_ms = 500 }) end)

-- Other tools
require('nvim-ts-autotag').setup({ opts = { enable_close = true, enable_rename = true } })

require('live-server').setup({})

require("html-css").setup({
	opts = {
		enable_on = { "html", "htmldjango", "tsx", "jsx", "svelte", "vue" },
		handlers = { definition = { bind = "gd" }, hover = { bind = "K", border = "single" } },
		style_sheets = { "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" }
	}
})
require("netrw").setup({})

require("nvim-toggler").setup({ inverses = { ["HIGH"] = "LOW", ["-"] = "+", ["0"] = "1" } })

require("aerial").setup({
	on_attach = function(bufnr)
		vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
		vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
	end
})

vim.keymap.set("n", "<leader>at", "<cmd>AerialToggle!<CR>")
require("lsp_signature").setup({ floating_window = false, hint_enable = true, handler_opts = { border = "rounded" } })

-- FZF
vim.g.fzf_layout = { window = { width = 0.9, height = 0.6, border = "rounded" } }
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#ff880a" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })

-- ==========================================================================
-- JDTLS & PDE/J2ME CONFIGURATION
-- ==========================================================================

-- 1. Treat .pde files as Java
vim.filetype.add({
	extension = { pde = "java" },
})

-- 2. The JDTLS Setup Function
local function setup_jdtls()
	local jdtls = require("jdtls")

	-- Path detection
	local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
	local root_dir = jdtls.setup.find_root(root_markers)
	if root_dir == "" then return end

	local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
	local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

	-- Mason Paths
	local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
	local launcher_jar = vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
	local config_dir = mason_path .. "/config_linux"

	-- Command to start JDTLS
	local cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xms1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens", "java.base/java.util=ALL-UNNAMED",
		"--add-opens", "java.base/java.lang=ALL-UNNAMED",
		"-jar", launcher_jar,
		"-configuration", config_dir,
		"-data", workspace_dir,
	}

	local config = {
		cmd = cmd,
		root_dir = root_dir,
		settings = {
			java = {
				signatureHelp = { enabled = true },
				-- Processing & J2ME Library Support
				project = {
					referencedLibraries = {
						-- Add your specific .jar paths here
						"/usr/share/processing/core/library/core.jar",
						-- "/path/to/j2me/midpapi20.jar",
					},
				},
				configuration = {
					runtimes = {
						{
							name = "JavaSE-1.8", -- J2ME often needs Java 8 or older
							path = "/usr/lib/jvm/java-8-openjdk/",
						},
					},
				},
			},
		},
	}

	-- Start or Attach
	jdtls.start_or_attach(config)
end

-- 3. Create the Autocmd (Replaces ftplugin/java.lua)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "java", -- This will now catch .pde files too
	callback = function()
		setup_jdtls()
	end,
})

-- venn.nvim settings
--
-- venn.nvim: enable or disable keymappings
function _G.Toggle_venn()
	local venn_enabled = vim.inspect(vim.b.venn_enabled)
	if venn_enabled == "nil" then
		vim.b.venn_enabled = true
		vim.cmd [[setlocal ve=all]]
		-- draw a line on HJKL keystokes
		vim.api.nvim_buf_set_keymap(0, "n", "<A-j>", "<C-v>j:VBox<CR>", { noremap = true })
		vim.api.nvim_buf_set_keymap(0, "n", "<A-k>", "<C-v>k:VBox<CR>", { noremap = true })
		vim.api.nvim_buf_set_keymap(0, "n", "<A-l>", "<C-v>l:VBox<CR>", { noremap = true })
		vim.api.nvim_buf_set_keymap(0, "n", "<A-h>", "<C-v>h:VBox<CR>", { noremap = true })
		-- draw a box by pressing "f" with visual selection
		vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
	else
		vim.cmd [[setlocal ve=]]
		vim.api.nvim_buf_del_keymap(0, "n", "<A-j>")
		vim.api.nvim_buf_del_keymap(0, "n", "<A-k>")
		vim.api.nvim_buf_del_keymap(0, "n", "<A-l>")
		vim.api.nvim_buf_del_keymap(0, "n", "<A-h>")
		vim.api.nvim_buf_del_keymap(0, "v", "f")
		vim.b.venn_enabled = nil
	end
end

-- toggle keymappings for venn using <leader>v
vim.api.nvim_set_keymap('n', '<leader>vn', ":lua Toggle_venn()<CR>", { noremap = true })
