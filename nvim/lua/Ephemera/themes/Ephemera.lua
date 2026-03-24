local M = {}
M.config = {
	transparent = true,
	glow = true,
	show_end_of_buffer = false,
	colors = {
		-- Base UI
		fg                   = "#ddcccc",
		bg                   = "#04040d",
		bgl                  = "#090909",
		black                = "#000000",
		white                = "#ffffff",
		eob                  = "#3c3c3c",
		border               = "#ff1e00",
		title                = "#ff1e00",

		-- Cursor & Selection
		cursor               = "#ffa0a0",
		cursorLine           = "#121212",
		visual               = "#4a0a0a", -- Darkened for legibility
		line_nr              = "#ff1010",

		-- Syntax
		comment              = "#696969",
		string               = "#e4b2ab",
		func                 = "#ff6347",
		kw                   = "#b3242a",
		identifier           = "#d2d2d2",
		type                 = "#ff420f",
		type_builtin         = "#ff420f",
		operator             = "#d63e3e",
		bracket              = "#ff6969",
		preprocessor         = "#4b8902",
		bool                 = "#ffa07a",
		constant             = "#f59064",

		-- Search & Highlighting
		search_highlight     = "#ffaa00",
		search_bg            = "#5631a6",
		inc_search_bg        = "#ff3e0b",
		inc_search_fg        = "#440000",
		cur_search_bg        = "#ff5555",
		glow_color           = "#ffeeee",

		-- Popup Menu
		pmenu_bg             = "#17171d",
		pmenu_sel_bg         = "#fa3e19",
		pmenu_fg             = "#fc6142",

		-- Git
		added                = "#4b8902",
		changed              = "#ff8800",
		removed              = "#ff0000",

		-- Diagnostics
		error                = "#ff0000",
		warning              = "#ffee00",
		hint                 = "#00ffee",
		info                 = "#14ff6a",

		-- Plugin Specific
		bufferline_selection = "#fd1b1b",
		cyan                 = "#00FFFF",
		purple_light         = "#b294bb",
		quote_fg             = "#a1a1a1",

		-- Extended Palette
		orange1              = "#ff9e64",
		orange2              = "#ff8800",
		orange3              = "#ff5500",
		orange4              = "#db4b4b",

		red1                 = "#ff0000",
		red2                 = "#ff4444",
		red3                 = "#ff6565",
		red4                 = "#c53b53",
		red_light            = "#ff5555",

		green1               = "#00ff99",
		green2               = "#50fa7b",
		green3               = "#73daca",
		green4               = "#2e8b57",

		blue1                = "#00e1ff",
		blue2                = "#61afef",
		blue3                = "#7aa2f7",
		blue4                = "#3d59a1",

		purple1              = "#ff00ff",
		purple2              = "#bd93f9",
		purple3              = "#c678dd",
		purple4              = "#9d7cd8",
	},
}


function M.setup(user_config)
	M.config = vim.tbl_deep_extend("force",
		M.config,
		user_config or {})
	local colors = M.config.colors
	local bg_color = M.config.transparent and "NONE" or colors.bg
	local float_bg = M.config.transparent and "NONE" or colors.pmenu_bg

	local highlight_groups = {
		-- =====================================
		-- CORE UI
		-- =====================================
		Normal       = { fg = colors.fg, bg = bg_color },
		Folded       = { fg = colors.bool, bg = bg_color, italic = true, bold = true },
		FoldColumn   = { fg = colors.type, bg = bg_color },
		Cursor       = { fg = colors.cursor, bg = bg_color },
		CursorLine   = { bg = colors.cursorLine },
		LineNr       = { fg = colors.line_nr },
		Visual       = { bg = colors.visual },
		EndOfBuffer  = { fg = M.config.show_end_of_buffer and colors.eob or colors.bg, bg = bg_color },
		WinSeparator = { fg = colors.kw, bg = bg_color },

		-- Messages & Cmdline
		MsgSeparator = { bg = colors.bgl },
		MsgArea      = { fg = colors.constant, bg = bg_color, italic = true, bold = true },
		ModeMsg      = { fg = colors.constant, bold = true },
		-- MsgArea =    { bg = bg_color },
		-- NormalMsg =  { bg = bg_color },
		-- ModeMsg =    { bg = bg_color },

		-- Search
		Search       = { bg = colors.search_bg, fg = colors.white, bold = true },
		IncSearch    = { bg = colors.inc_search_bg, fg = colors.inc_search_fg, bold = true },
		CurSearch    = { bg = colors.cur_search_bg, fg = colors.black, bold = true },

		-- Floating Windows & Menus
		Pmenu        = { fg = colors.pmenu_fg, bg = colors.pmenu_bg },
		PmenuSel     = { fg = colors.pmenu_bg, bg = colors.pmenu_sel_bg, bold = true },
		NormalFloat  = { fg = colors.fg, bg = float_bg },
		FloatBorder  = { fg = colors.border, bg = float_bg },

		-- Syntax (General)
		Comment      = { fg = colors.comment, italic = true, bold = true },
		String       = { fg = colors.string },
		Function     = { fg = colors.func },
		Keyword      = { fg = colors.kw },
		Identifier   = { fg = colors.identifier },
		Type         = { fg = colors.type },
		PreProc      = { fg = colors.preprocessor },
		Boolean      = { fg = colors.bool },
		Constant     = { fg = colors.constant },
		Operator     = { fg = colors.operator },
		Delimiter    = { fg = colors.bracket },

		-- =====================================
		-- CUSTOM MODES
		-- =====================================
		ModeVenn     = { fg = colors.bg, bg = colors.preprocessor, italic = true, bold = true },
		ModeMul      = { fg = colors.bg, bg = colors.blue2, italic = true, bold = true },

		-- =====================================
		-- STATUSLINE
		-- =====================================
		ModeNorm     = { fg = colors.bg, bg = colors.kw, italic = true, bold = true },
		SepNormA     = { fg = colors.kw, bg = colors.pmenu_bg },
		InfoNorm     = { fg = colors.fg, bg = colors.pmenu_bg },
		SepNormB     = { fg = colors.pmenu_bg, bg = colors.bgl },
		ModeIns      = { fg = colors.bg, bg = colors.func, italic = true, bold = true },
		SepInsA      = { fg = colors.func, bg = colors.pmenu_bg },
		InfoIns      = { fg = colors.fg, bg = colors.pmenu_bg },
		SepInsB      = { fg = colors.pmenu_bg, bg = colors.bgl },
		ModeVis      = { fg = colors.bg, bg = colors.type, italic = true, bold = true },
		SepVisA      = { fg = colors.type, bg = colors.pmenu_bg },
		InfoVis      = { fg = colors.fg, bg = colors.pmenu_bg },
		SepVisB      = { fg = colors.pmenu_bg, bg = colors.bgl },
		StatusBody   = { fg = colors.comment, bg = colors.bgl, bold = true, italic = true },
		SlRef        = { fg = colors.comment, bg = colors.bgl, bold = true, italic = true },



		-- =====================================
		-- TREESITTER
		-- =====================================
		["@function"]               = { fg = colors.func },
		["@method"]                 = { fg = colors.func },
		["@function.builtin"]       = { fg = colors.func },
		["@function.call"]          = { fg = colors.func },
		["@keyword"]                = { fg = colors.kw },
		["@keyword.function"]       = { fg = colors.kw },
		["@keyword.return"]         = { fg = colors.kw },
		["@conditional"]            = { fg = colors.kw },
		["@repeat"]                 = { fg = colors.kw },
		["@constant"]               = { fg = colors.constant },
		["@constant.builtin"]       = { fg = colors.constant },
		["@string"]                 = { fg = colors.string },
		["@string.regex"]           = { fg = colors.string },
		["@string.escape"]          = { fg = colors.operator },
		["@number"]                 = { fg = colors.constant },
		["@boolean"]                = { fg = colors.bool },
		["@variable"]               = { fg = colors.identifier },
		["@variable.builtin"]       = { fg = colors.identifier },
		["@parameter"]              = { fg = colors.identifier },
		["@parameter.reference"]    = { fg = colors.identifier },
		["@field"]                  = { fg = colors.identifier },
		["@property"]               = { fg = colors.identifier },
		["@type"]                   = { fg = colors.type },
		["@type.builtin"]           = { fg = colors.type_builtin },
		["@class"]                  = { fg = colors.type },
		["@enum"]                   = { fg = colors.type },
		["@namespace"]              = { fg = colors.identifier },
		["@struct"]                 = { fg = colors.type },
		["@module"]                 = { fg = colors.identifier },
		["@attribute"]              = { fg = colors.identifier },
		["@punctuation.delimiter"]  = { fg = colors.bracket },
		["@punctuation.bracket"]    = { fg = colors.bracket },
		["@punctuation.special"]    = { fg = colors.operator },
		["@operator"]               = { fg = colors.operator },
		["@comment"]                = { fg = colors.comment },
		["@annotation"]             = { fg = colors.preprocessor },
		["@tag"]                    = { fg = colors.func },
		["@tag.attribute"]          = { fg = colors.identifier },
		["@tag.delimiter"]          = { fg = colors.bracket },
		["@constructor"]            = { fg = colors.func },
		["@constructor.lua"]        = { fg = colors.bracket },
		["@decorator"]              = { fg = colors.preprocessor },

		-- =====================================
		-- TELESCOPE
		-- =====================================
		TelescopeNormal             = { fg = colors.fg, bg = "NONE" },
		TelescopeBorder             = { fg = colors.comment, bg = "NONE" },
		TelescopePromptNormal       = { fg = colors.pmenu_fg, bg = "NONE" },
		TelescopePromptBorder       = { fg = colors.border, bg = "NONE" },
		TelescopePromptTitle        = { fg = colors.title, bg = "NONE", bold = true },
		TelescopePromptCounter      = { fg = colors.cursor, bg = "NONE" },
		TelescopeSelectionCaret     = { fg = colors.operator, bg = colors.visual },
		TelescopeSelection          = { fg = colors.fg, bg = colors.visual, bold = true },
		TelescopeMatching           = { fg = colors.operator, bg = "NONE", bold = true },

		-- =====================================
		-- BUFFERLINE
		-- =====================================
		-- BufferLineFill = { bg = "NONE", fg = colors.fg },
		-- BufferLineBackground = { bg = "NONE", fg = colors.fg },
		-- BufferLineBufferVisible = { bg = "NONE", fg = colors.fg },
		-- BufferLineBufferSelected = { bg = "NONE", fg = colors.bufferline_selection, bold = true },
		-- BufferLineTab = { bg = "NONE", fg = colors.fg },
		-- BufferLineTabSelected = { bg = "NONE", fg = colors.bg },
		-- BufferLineTabClose = { bg = "NONE", fg = colors.fg },
		-- BufferLineSeparator = { bg = "NONE", fg = colors.line_nr },
		-- BufferLineSeparatorSelected = { bg = colors.bg, fg = colors.bufferline_selection },
		-- BufferLineIndicatorSelected = { bg = colors.bg, fg = colors.bufferline_selection },

		-- =====================================
		-- NVIM-CMP
		-- =====================================
		CmpItemAbbr                 = { fg = colors.fg, bg = bg_color },
		CmpItemAbbrMatch            = { fg = colors.cursor, bg = bg_color, bold = true },
		CmpItemAbbrDeprecated       = { fg = colors.comment, bg = bg_color, italic = true },
		CmpItemAbbrMatchFuzzy       = { fg = colors.visual, bg = bg_color, bold = true },
		CmpItemMenu                 = { fg = colors.comment, bg = bg_color },
		CmpBorder                   = { fg = colors.red_light },

		-- =====================================
		-- OIL
		-- =====================================
		OilDir                      = { fg = colors.bool, bold = true, italic = true },
		OilPermission               = { fg = colors.comment },
		OilSize                     = { fg = colors.constant },
		OilDate                     = { fg = colors.comment },
		OilFile                     = { fg = colors.string, italic = true },
		OilSocket                   = { fg = colors.type },
		OilLink                     = { fg = colors.string },
		OilLinkTarget               = { fg = colors.kw },
		OilCreate                   = { fg = colors.func },
		OilDelete                   = { fg = colors.error },
		OilMove                     = { fg = colors.kw },
		OilCopy                     = { fg = colors.string },
		OilChange                   = { fg = colors.changed },
		OilRestore                  = { fg = colors.info },
		OilPurge                    = { fg = colors.error },
		OilTrash                    = { fg = colors.warning },
		OilTrashSourcePath          = { fg = colors.comment },
		OilFloatBorder              = { fg = colors.comment },

		-- =====================================
		-- GITSIGNS
		-- =====================================
		GitSignsAdd                 = { fg = colors.added, bg = "NONE" },
		GitSignsChange              = { fg = colors.changed, bg = "NONE" },
		GitSignsDelete              = { fg = colors.removed, bg = "NONE" },

		-- =====================================
		-- DIAGNOSTICS & LSP
		-- =====================================
		LspSignatureActiveParameter = { bg = bg_color, italic = true },
		DiagnosticError             = { fg = colors.error },
		DiagnosticWarn              = { fg = colors.warning },
		DiagnosticHint              = { fg = colors.hint },
		DiagnosticInfo              = { fg = colors.info },
		DiagnosticVirtualTextError  = { fg = colors.error },
		DiagnosticVirtualTextWarn   = { fg = colors.warning },
		DiagnosticVirtualTextHint   = { fg = colors.hint },
		DiagnosticVirtualTextInfo   = { fg = colors.info },
		DiagnosticUnderlineError    = { gui = "underline", sp = colors.error },
		DiagnosticUnderlineWarn     = { gui = "underline", sp = colors.warning },
		DiagnosticUnderlineHint     = { gui = "underline", sp = colors.hint },
		DiagnosticUnderlineInfo     = { gui = "underline", sp = colors.info },

		-- =====================================
		-- MULTICURSOR
		-- =====================================
		-- first plugin
		MultipleCursorsCursor       = { bg = colors.cyan, fg = colors.black },
		MultipleCursorsVisual       = { bg = colors.purple_light, fg = colors.black },

		-- second plugin
		MultiCursorCursor           = { bg = colors.cyan, fg = colors.black },
		MultiCursorVisual           = { bg = colors.purple_light, fg = colors.black },
		MultiCursorSign             = { link = "SignColumn" },
		MultiCursorMatchPreview     = { link = "Search" },
		MultiCursorDisabledCursor   = { bg = colors.cyan, fg = colors.black },
		MultiCursorDisabledVisual   = { bg = colors.purple_light, fg = colors.black },
		MultiCursorDisabledSign     = { link = "SignColumn" },

		-- =====================================
		-- FLASH
		-- =====================================
		FlashLabel                  = { bg = colors.orange1, fg = colors.black, bold = true },

		-- =====================================
		-- WELCOME / DASHBOARD
		-- =====================================
		WelcomeRose                 = { fg = colors.red_light, bold = true },
		WelcomeStem                 = { fg = colors.green2, bold = true },
		WelcomeQuote                = { fg = colors.quote_fg, italic = true },

		-- =====================================
		-- AERIAL
		-- =====================================
		AerialLine                  = { fg = colors.red2, bg = colors.bg, bold = true }, -- Active cursor line in sidebar
		AerialLineNC                = { fg = colors.comment, bg = colors.bg },      -- Active line when sidebar is not focused
		AerialGuide                 = { fg = colors.comment },                      -- Vertical guide lines
		AerialSymbolsl              = { fg = colors.func, bg = colors.bgl, bold = true }, -- The Icon in statusline
		AerialTextsl                = { fg = colors.type, bg = colors.bgl, bold = true }, -- The Text in statusline

	}

	-- CMP Kind Icons Loop
	local kinds = { "Text", "Method", "Function", "Constructor", "Field", "Variable", "Class", "Interface", "Module",
		"Property", "Unit", "Value", "Enum", "Keyword", "Snippet", "Color", "File", "Reference", "Folder", "EnumMember",
		"Constant", "Struct", "Event", "Operator", "TypeParameter" }
	for _, kind in ipairs(kinds) do highlight_groups["CmpItemKind" .. kind] = { fg = colors.kw } end

	-- Application Loop
	for group, conf in pairs(highlight_groups) do
		local cmd = string.format("highlight %s guifg=%s guibg=%s", group, conf.fg or "NONE", conf.bg or "NONE")
		if conf.sp then cmd = cmd .. " guisp=" .. conf.sp end
		local gui = {}
		if conf.bold then table.insert(gui, "bold") end
		if conf.italic then table.insert(gui, "italic") end
		-- if conf.underline then table.insert(gui, "underline") end
		if conf.gui then table.insert(gui, conf.gui) end
		if M.config.glow and (group == "Function" or group == "Keyword" or group == "@function" or group == "@keyword") then
			table.insert(gui, "bold")
			cmd = cmd .. " guisp=" .. colors.glow_color
		end
		if #gui > 0 then cmd = cmd .. " gui=" .. table.concat(gui, ",") end
		vim.cmd(cmd)
	end
end

M.toggle_transparency = function()
	M.config.transparent = not M.config.transparent
	M.setup()
	print("Transparency: " .. (M.config.transparent and "ON" or "OFF"))
end

vim.api.nvim_create_user_command("ToggleTransparency", M.toggle_transparency, {})

return M
