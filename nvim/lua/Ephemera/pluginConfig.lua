-- lsp configs
local mason = require("mason")
local masonConf = require("mason-lspconfig")
local lspconfig = require("lspconfig")

-- 1. Setup Mason
mason.setup({ ui = { border = "rounded" }, registries = { "github:mason-org/mason-registry" } })

-- 2. Global Capabilities
local caps = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(),
require("cmp_nvim_lsp").default_capabilities())
vim.lsp.config("*", { capabilities = caps })

-- 3. Mason LSP Config with Explicit Handlers (The "Exclude" Fix)
masonConf.setup({
	ensure_installed = { "clangd", "jdtls", "verible" },

	-- Defining handlers INSIDE setup() is the clean, correct syntax.
	handlers = {

		-- Default handler: Setup every server Mason finds automatically...
		function(server_name)
			lspconfig[server_name].setup({ capabilities = caps })
		end,

		-- EXCLUDE JDTLS: Mapping it to an empty function prevents automatic setup.
		-- This allows your manual config at the bottom to work without interference.
		["jdtls"] = function() end,

		-- Specific overrides for other servers
		["clangd"] = function()
			lspconfig.clangd.setup({
				capabilities = caps,
				cmd = { "clangd", "--compile-commands-dir=" .. vim.loop.cwd() },
				filetypes = { "c", "cpp", "objc", "objcpp", "ino" },
				init_options = { usePlaceholders = true, completeUnimported = true },
			})
		end,

		["arduino_language_server"] = function()
			lspconfig.arduino_language_server.setup({
				capabilities = caps,
				cmd = {
					"arduino-language-server",
					"-clangd", "/home/godz/.local/share/nvim/mason/bin/clangd",
					"-clangd", "/usr/bin/clangd",
					"-cli", "/home/godz/.local/bin/arduino-cli",
					"-cli-config", "/home/godz/.arduino15/arduino-cli.yaml",
					"-fqbn", "esp8266:esp8266:nodemcuv2"
				},
			})
		end,

		["verible"] = function()
			lspconfig.verible.setup({
				capabilities = caps,
				cmd = { "verible-verilog-ls", "--indentation_spaces=0", "--rules_config_search" },
				filetypes = { "verilog", "systemverilog" },
			})
		end,
	}
})

-- Verilog Auto-format
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.v", "*.sv" },
	callback = function() vim.lsp.buf.format({ async = false }) end,
})

-- completion
local cmp = require("cmp")
local lspkind = require("lspkind")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

vim.g.cmp_enabled = false
vim.g.cmp_ghost = false

local function apply_cmp()
	cmp.setup({
		enabled = vim.g.cmp_enabled,

		snippet = {
			expand = function(args)
				vim.snippet.expand(args.body)
			end,
		},

		completion = {
			autocomplete = vim.g.cmp_enabled and { cmp.TriggerEvent.TextChanged } or false,
		},

		experimental = {
			ghost_text = vim.g.cmp_ghost,
		},

		window = {
			completion = cmp.config.window.bordered({
				border = "rounded",
				winhighlight = "Normal:Normal,FloatBorder:CmpBorder,CursorLine:Visual",
				max_height = 8, -- shows only 6 entries
				max_width = 20, -- shows only 6 entries
			}),
			documentation = cmp.config.window.bordered({
				border = "rounded",
				winhighlight = "Normal:Normal,FloatBorder:CmpBorder,CursorLine:Visual",
				max_height = 14,
				max_width = 69,
			}),
		},

		formatting = {
			format = lspkind.cmp_format({
				-- mode = "text_symbol",
				-- mode = "symbol",
				mode = "text",
				maxwidth = { menu = 50, abbr = 50 },
				ellipsis_char = "...",
				show_labelDetails = false,
			}),
		},

		mapping = cmp.mapping.preset.insert({
			["<A-k>"] = cmp.mapping.select_prev_item({ behavior = "select" }),
			["<A-j>"] = cmp.mapping.select_next_item({ behavior = "select" }),
			["<A-i>"] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace }),
			["<A-c>"] = cmp.mapping.complete(),

			["<C-u>"] = cmp.mapping.scroll_docs(-4),
			["<C-d>"] = cmp.mapping.scroll_docs(4),

			["<A-b>"] = cmp.mapping(function(fallback)
				local entry = cmp.get_selected_entry()
				if entry then
					cmp.open_docs()
				else
					fallback()
				end
			end, { "i", "s" }),
		}),

		sources = {
			{ name = "nvim_lsp" },
			{ name = "verible" },
			{ name = "path" },
			{ name = "luasnip" },
			{ name = "html-css" },
			{
				name = "buffer",
				option = {
					get_bufnrs = function()
						return vim.api.nvim_list_bufs()
					end,
				},
			},
			{ name = "rg",   keyword_length = 3 },
			{ name = "calc" },
			{ name = "spell" },
		},
	})
end

apply_cmp()

vim.api.nvim_create_user_command("ToggleCompletion", function()
	vim.g.cmp_enabled = not vim.g.cmp_enabled
	vim.g.cmp_ghost = vim.g.cmp_enabled
	apply_cmp()
end, {})

cmp.setup.filetype("go", {
	preselect = cmp.PreselectMode.None,
	completion = { completeopt = "menu,menuone,noinsert,noselect" },
})

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
