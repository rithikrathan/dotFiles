local M = {}
local utils = require("Ephemera.theme.utils")

-- Default configuration
M.config = {
	transparent = true,
	glow = true,
	show_end_of_buffer = false,

	colors = {
		-- Core colors
		fg = "#ffeeee",
		bg = "#04040d",
		cursor = "#ffa0a0",
		cursorLine = "#121212",
		glow_color = "#ffeeee",
		
		-- UI elements
		line_nr = "#ff1010",
		visual = "#690f0f",
		comment = "#696969",
		eob = "#3c3c3c",
		border = "#ff1e00",
		title = "#ff1e00",
		
		-- Syntax highlighting
		string = "#e4b2ab",
		func = "#ff6347",
		kw = "#ff2828",
		identifier = "#d2d2d2",
		type = "#ff420f",
		type_builtin = "#ff420f",
		search_highlight = "#ffaa00",
		operator = "#d63e3e",
		bracket = "#ff6969",
		preprocessor = "#4b8902",
		bool = "#ffa07a",
		constant = "#f59064",
		
		-- Popup menus
		pmenu_bg = "#17171d",
		pmenu_sel_bg = "#fa3e19",
		pmenu_fg = "#fc6142",
		
		-- Background layers
		bgl = "#090909",
		
		-- Git colors
		added = "#baffc9",
		changed = "#ffffba",
		removed = "#ffb3ba",
		
		-- Diagnostics
		error = "#ff0000",
		warning = "#ffee00",
		hint = "#00ffee",
		info = "#14ff6a",
		
		-- Bufferline
		bufferline_selection = "#fd1b1b",
		
		-- Extended palette
		orange = { "#ff9e64", "#ff8800", "#ff5500", "#db4b4b" },
		red = { "#ff0000", "#ff4444", "#ff6565", "#c53b53" },
		green = { "#00ff99", "#50fa7b", "#73daca", "#2e8b57" },
		blue = { "#00e1ff", "#61afef", "#7aa2f7", "#3d59a1" },
		purple = { "#ff00ff", "#bd93f9", "#c678dd", "#9d7cd8" },
		
		-- Plugin configuration
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

-- Toggle Transparency Command
M.toggle_transparency = function()
	M.config.transparent = not M.config.transparent
	M.setup()
	print("Transparency: " .. (M.config.transparent and "ON" or "OFF"))
end

-- Apply the colorscheme
function M.setup(user_config)
	M.config = vim.tbl_deep_extend("force", M.config, user_config or {})
	local colors = M.config.colors

	-- Dynamic Backgrounds for Transparency
	local bg_color = M.config.transparent and "NONE" or colors.bg
	local float_bg = M.config.transparent and "NONE" or colors.pmenu_bg

	local highlight_groups = {
		-- Basic editor highlights
		Normal = { fg = colors.fg, bg = bg_color },
		NormalFloat = { fg = colors.fg, bg = float_bg },
		FloatBorder = { fg = colors.border, bg = float_bg },
		Cursor = { fg = colors.cursor, bg = bg_color },
		CursorLine = { bg = colors.cursorLine },
		LineNr = { fg = colors.line_nr },
		EndOfBuffer = { fg = M.config.show_end_of_buffer and colors.eob or colors.bg, bg = bg_color },
		Visual = { bg = colors.visual },
		
		-- Messages and UI
		MsgArea = { fg = colors.constant, bg = bg_color, italic = true, bold = true },
		ModeMsg = { fg = colors.constant, bold = true },
		
		-- Syntax highlighting
		Comment = { fg = colors.comment, italic = true },
		String = { fg = colors.string },
		Function = { fg = colors.func },
		Keyword = { fg = colors.kw },
		Identifier = { fg = colors.identifier },
		Type = { fg = colors.type },
		PreProc = { fg = colors.preprocessor },
		Boolean = { fg = colors.bool },
		Constant = { fg = colors.constant },
		Operator = { fg = colors.operator },
		Delimiter = { fg = colors.bracket },
		
		-- Search
		Search = { fg = colors.search_highlight, bg = "NONE", bold = true },
		IncSearch = { fg = colors.search_highlight, bg = "NONE", bold = true },
		CurSearch = { bg = colors.search_highlight, fg = colors.bg, bold = true },
		
		-- Popup menus
		Pmenu = { fg = colors.pmenu_fg, bg = colors.pmenu_bg },
		PmenuSel = { fg = colors.pmenu_bg, bg = colors.pmenu_sel_bg, bold = true },
		
		-- Folding
		Folded = { fg = colors.string, bg = utils.get_bg_color("#201010", M.config), bold = true, italic = true },
		FoldColumn = { fg = colors.kw, bg = colors.bgl },
		
		-- Statusline custom highlights
		StatusBody = { fg = colors.comment, bg = colors.bgl, bold = true, italic = true },
		ModeNorm = { fg = colors.bg, bg = colors.kw, italic = true, bold = true },
		ModeIns = { fg = colors.bg, bg = colors.func, italic = true, bold = true },
		ModeVis = { fg = colors.bg, bg = colors.type, italic = true, bold = true },
		
		-- Oil.nvim
		OilDir = { fg = colors.bool, bold = true, italic = true },
		OilFile = { fg = colors.string, italic = true, bold = true },
		OilPermission = { fg = colors.comment },
		OilSize = { fg = colors.constant },
		OilDate = { fg = colors.comment },
		OilSocket = { fg = colors.type },
		OilLink = { fg = colors.string },
		
		-- Welcome screen
		WelcomeRose = { fg = "#ff5555", bold = true },
		WelcomeStem = { fg = "#50fa7b", bold = true },
		WelcomeQuote = { fg = "#a1a1a1", italic = true },
		
		-- Flash.nvim
		FlashLabel = { bg = colors.orange[1], fg = "#000000", bold = true },
		
		-- Multiple cursors
		MultipleCursorsCursor = { bg = "#00FFFF", fg = "#000000" },
		MultipleCursorsVisual = { bg = "#b294bb", fg = "#000000" },
		
		-- LSP Diagnostics
		DiagnosticError = { fg = colors.error },
		DiagnosticWarn = { fg = colors.warning },
		DiagnosticHint = { fg = colors.hint },
		DiagnosticInfo = { fg = colors.info },
		DiagnosticVirtualTextError = { fg = colors.error },
		DiagnosticVirtualTextWarn = { fg = colors.warning },
		DiagnosticVirtualTextHint = { fg = colors.hint },
		DiagnosticVirtualTextInfo = { fg = colors.info },
		
		DiagnosticUnderlineError = { underline = true, sp = colors.error },
		DiagnosticUnderlineWarn = { underline = true, sp = colors.warning },
		DiagnosticUnderlineHint = { underline = true, sp = colors.hint },
		DiagnosticUnderlineInfo = { underline = true, sp = colors.info },
		
		-- Completion
		CmpBorder = { fg = colors.border },
	}

	local function apply_highlight(group_name, config)
		-- Apply glow effect if enabled
		if M.config.glow and (
				group_name == "Function" or group_name == "Keyword"
				or group_name == "Identifier" or group_name == "Operator"
				or group_name == "@function" or group_name == "@keyword"
				or group_name == "@identifier" or group_name == "@operator"
			) then
			config.guisp = colors.glow_color
			config.bold = true
		end
		
		utils.apply_highlights({ [group_name] = config }, colors, M.config)
	end

	-- Apply all highlights
	for group_name, config in pairs(highlight_groups) do
		apply_highlight(group_name, config)
	end

	-- Create User Command for toggling
	vim.api.nvim_create_user_command("ToggleTransparency", M.toggle_transparency, {})

	-- Plugin specific highlights
	if package.loaded["Ephemera.theme.config"] then
		require("Ephemera.theme.config").setup(M.config)
	end
end

return M
