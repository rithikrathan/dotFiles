local M = {}

-- my Colours
M.config = {
	transparent = true, -- Toggle transparency with this
	glow = true,

	colors = {
		fg = "#ffeeee",
		bg = "#040409",
		cursor = "#ffa0a0",
		glow_color = "#ffeeee",
		line_nr = "#ff1010",
		visual = "#690f0f",
		comment = "#696969",
		string = "#e4b2ab",
		func = "#ff6347",
		kw = "#ff5555",
		identifier = "#d2d2d2",
		type = "#ff420f",
		type_builtin = "#ff420f",
		search_highlight = "#ffaa00",
		operator = "#d63e3e",
		bracket = "#ff6969",
		preprocessor = "#4b8902",

		bool = "#ffa07a",
		constant = "#f59064",
		added = "#baffc9",
		changed = "#ffffba",
		removed = "#ffb3ba",
		pmenu_bg = "#1c1c2f",
		pmenu_sel_bg = "#fa3e19",
		pmenu_fg = "#fc6142",

		eob = "#3c3c3c",
		border = "#ff1e00",
		title = "#ff1e00",

		bufferline_selection = "#fd1b1b",
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
}

M.extend = function(user_config)
	M.config = vim.tbl_deep_extend("force", M.config, user_config or {})
end

-- Apply the colorscheme (using defined colors and groups)
function M.setup(user_config)
	-- Merge user configuration with default (optional)
	M.config = vim.tbl_deep_extend("force", M.config, user_config or {})

	local colors = M.config.colors

	local highlight_groups = {
		Normal = { fg = colors.fg, bg = M.config.transparent and "NONE" or colors.bg },
		Cursor = { fg = colors.cursor, bg = M.config.transparent and "NONE" or colors.bg },
		LineNr = { fg = colors.line_nr },
		Visual = { bg = colors.visual },

		Comment = { fg = colors.comment, gui = "italic" },
		String = { fg = colors.string },
		Function = { fg = colors.func },
		Keyword = { fg = colors.kw },
		Identifier = { fg = colors.identifier },
		Type = { fg = colors.type },
		PreProc = { fg = colors.preprocessor },
		Boolean = { fg = colors.bool },
		Constant = { fg = colors.constant },

		Search = { fg = colors.search_highlight, bg = "NONE", gui = "bold" },
		IncSearch = { fg = colors.search_highlight, bg = "NONE", gui = "bold" },
		Operator = { fg = colors.operator },
		Delimiter = { fg = colors.bracket },

		Pmenu = { fg = colors.pmenu_fg, bg = M.config.transparent and "NONE" or colors.pmenu_bg },
		PmenuSel = { fg = colors.pmenu_bg, bg = colors.pmenu_sel_bg, gui = "bold" },

		-- have to define treesitter based functions as well for glow effect
		["@function"] = { fg = colors.func },
		["@keyword"] = { fg = colors.kw },
		["@identifier"] = { fg = colors.identifier },
		["@operator"] = { fg = colors.operator },

		-- EndOfBuffer
		EndOfBuffer = {
			fg = M.config.show_end_of_buffer and colors.eob or colors.bg,
			bg = M.config.transparent and "NONE" or colors.bg,
		},

		-- LSP diagnostics
		DiagnosticError = { fg = colors.error },
		DiagnosticWarn = { fg = colors.warning },
		DiagnosticHint = { fg = colors.hint },
		DiagnosticInfo = { fg = colors.info },
		DiagnosticVirtualTextError = { fg = colors.error },
		DiagnosticVirtualTextWarn = { fg = colors.warning },
		DiagnosticVirtualTextHint = { fg = colors.hint },
		DiagnosticVirtualTextInfo = { fg = colors.info },

		DiagnosticUnderlineError = { gui = "underline", sp = colors.error },
		DiagnosticUnderlineWarn = { gui = "underline", sp = colors.warning },
		DiagnosticUnderlineHint = { gui = "underline", sp = colors.hint },
		DiagnosticUnderlineInfo = { gui = "underline", sp = colors.info },
	}

	local function apply_highlight(group_name, config)
		local cmd = "highlight " .. group_name
		if config.fg then
			cmd = cmd .. " guifg=" .. config.fg
		end
		if config.bg then
			cmd = cmd .. " guibg=" .. config.bg
		end
		if config.gui then
			cmd = cmd .. " gui=" .. config.gui
		end
		if config.sp then
			cmd = cmd .. " guisp=" .. config.sp
		end

		if
			M.config.glow
			and (
				group_name == "Function"
				or group_name == "Keyword"
				or group_name == "Identifier"
				or group_name == "Operator"
				or group_name == "@function"
				or group_name == "@keyword"
				or group_name == "@identifier"
				or group_name == "@operator"
			)
		then
			cmd = cmd .. " gui=bold guisp=" .. colors.glow_color
		end

		vim.cmd(cmd)
	end

	-- Apply all highlights
	for group_name, config in pairs(highlight_groups) do
		apply_highlight(group_name, config)
	end

	-- Apply plugin specific highlight groups
	require("Ephemera.theme.config").setup(M.config)
end

return M
