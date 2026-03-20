local M = {}

M.config = {
	transparent = true,
	glow = true,
	show_end_of_buffer = false,
	colors = {
		-- Base UI (Ultra Dark for LCD)
		fg                   = "#e0d8c0", -- Warm off-white, high contrast
		bg                   = "#0c0c0a", -- Near-black with warm tint
		bgl                  = "#0a0a08", -- Even darker for panels
		black                = "#000000",
		white                = "#f0e8d0", -- Brightest foreground
		eob                  = "#2a2820", -- Subtle end-of-buffer
		border               = "#4a4a3a", -- Muted border
		title                = "#b8bb26", -- Green title

		-- Cursor & Selection
		cursor               = "#e0d8c0",
		cursorLine           = "#1a1a16", -- Subtle highlight
		visual               = "#3a3a30", -- Soft brown selection
		line_nr              = "#4a4a3a", -- Subdued but visible line numbers

		-- Syntax (Gruvbox with better LCD contrast)
		comment              = "#6a6050", -- Gray (readable on dark bg)
		string               = "#a8b860", -- Green (slightly brighter)
		func                 = "#8ab860", -- Green for functions
		kw                   = "#e04040", -- Red for keywords (brighter)
		identifier           = "#e0d8c0", -- Normal text
		type                 = "#d0a030", -- Yellow (brighter for visibility)
		type_builtin         = "#d07030", -- Orange
		operator             = "#70a060", -- Aqua (muted but visible)
		bracket              = "#90a080", -- Neutral (readable)
		preprocessor         = "#70a060", -- Aqua
		bool                 = "#c07090", -- Purple (readable)
		constant             = "#c07090", -- Purple

		-- Search & Highlighting
		search_highlight     = "#0c0c0a",
		search_bg            = "#b08020", -- Yellow bg
		inc_search_bg        = "#c06020",
		inc_search_fg        = "#0c0c0a",
		cur_search_bg        = "#c09030",
		glow_color           = "#f0e8d0",

		-- Popup Menu
		pmenu_bg             = "#141410", -- Darker than base bg
		pmenu_sel_bg         = "#3a3a30", -- Selection
		pmenu_fg             = "#e0d8c0",

		-- Git
		added                = "#8ab860", -- Green
		changed              = "#80b070", -- Aqua
		removed              = "#e04040", -- Red

		-- Diagnostics
		error                = "#e04040", -- Red
		warning              = "#c09020", -- Yellow
		hint                 = "#70a060", -- Aqua
		info                 = "#6080a0", -- Blue

		-- Plugin Specific
		bufferline_selection = "#c06030",
		cyan                 = "#70a060",
		purple_light         = "#b07090",
		quote_fg             = "#6a6050",

		-- Extended Palette
		orange1              = "#b06020",
		orange2              = "#c06030",
		orange3              = "#904020",
		orange4              = "#b06020",

		red1                 = "#a03020",
		red2                 = "#e04040",
		red3                 = "#801010",
		red4                 = "#a03020",
		red_light            = "#e05050",

		green1               = "#708020",
		green2               = "#8ab860",
		green3               = "#506010",
		green4               = "#708020",

		blue1                = "#406070",
		blue2                = "#608090",
		blue3                = "#305060",
		blue4                = "#406070",

		purple1              = "#905070",
		purple2              = "#b07090",
		purple3              = "#703050",
		purple4              = "#905070",
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
		Normal                      = { fg = colors.fg, bg = bg_color },
		Folded                      = { fg = colors.comment, bg = bg_color, italic = true },
		FoldColumn                  = { fg = colors.comment, bg = bg_color },
		Cursor                      = { fg = colors.cursor, bg = bg_color },
		CursorLine                  = { bg = colors.cursorLine },
		LineNr                      = { fg = colors.line_nr },
		Visual                      = { bg = colors.visual },
		EndOfBuffer                 = { fg = M.config.show_end_of_buffer and colors.eob or colors.bg, bg = bg_color },
		WinSeparator                = { fg = colors.border, bg = bg_color },

		-- Messages & Cmdline
		MsgSeparator                = { bg = colors.bgl },
		MsgArea                     = { fg = colors.fg, bg = bg_color },
		ModeMsg                     = { fg = colors.string, bold = true },

		-- Search
		Search                      = { bg = colors.search_bg, fg = colors.search_highlight, bold = true },
		IncSearch                   = { bg = colors.inc_search_bg, fg = colors.inc_search_fg, bold = true },
		CurSearch                   = { bg = colors.cur_search_bg, fg = colors.black, bold = true },

		-- Floating Windows & Menus
		Pmenu                       = { fg = colors.pmenu_fg, bg = float_bg },
		PmenuSel                    = { fg = colors.white, bg = colors.pmenu_sel_bg, bold = true },
		NormalFloat                 = { fg = colors.fg, bg = float_bg },
		FloatBorder                 = { fg = colors.border, bg = float_bg },

		-- Syntax (General)
		Comment                     = { fg = colors.comment, italic = true },
		String                      = { fg = colors.string },
		Function                    = { fg = colors.func, bold = true },
		Keyword                     = { fg = colors.kw },
		Identifier                  = { fg = colors.identifier }, -- Fixed: Normal text won't be blue
		Type                        = { fg = colors.type },
		PreProc                     = { fg = colors.preprocessor },
		Boolean                     = { fg = colors.bool },
		Constant                    = { fg = colors.constant },
		Operator                    = { fg = colors.operator },
		Delimiter                   = { fg = colors.bracket },

		-- =====================================
		-- CUSTOM MODES
		-- =====================================
		ModeVenn                    = { fg = colors.bg, bg = colors.preprocessor, italic = true, bold = true },
		ModeMul                     = { fg = colors.bg, bg = colors.blue2, italic = true, bold = true },

		-- =====================================
		-- STATUSLINE
		-- =====================================
		ModeNorm                    = { fg = colors.bg, bg = colors.kw, italic = true, bold = true },
		SepNormA                    = { fg = colors.kw, bg = colors.pmenu_bg },
		InfoNorm                    = { fg = colors.fg, bg = colors.pmenu_bg },
		SepNormB                    = { fg = colors.pmenu_bg, bg = colors.bgl },
		ModeIns                     = { fg = colors.bg, bg = colors.func, italic = true, bold = true },
		SepInsA                     = { fg = colors.func, bg = colors.pmenu_bg },
		InfoIns                     = { fg = colors.fg, bg = colors.pmenu_bg },
		SepInsB                     = { fg = colors.pmenu_bg, bg = colors.bgl },
		ModeVis                     = { fg = colors.bg, bg = colors.type, italic = true, bold = true },
		SepVisA                     = { fg = colors.type, bg = colors.pmenu_bg },
		InfoVis                     = { fg = colors.fg, bg = colors.pmenu_bg },
		SepVisB                     = { fg = colors.pmenu_bg, bg = colors.bgl },
		StatusBody                  = { fg = colors.comment, bg = colors.bgl, bold = true, italic = true },
		SlRef                       = { fg = colors.comment, bg = colors.bgl, bold = true, italic = true },

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
		["@string.escape"]          = { fg = colors.orange2 },
		["@number"]                 = { fg = colors.constant },
		["@boolean"]                = { fg = colors.bool },
		["@variable"]               = { fg = colors.fg }, -- Fixed: Variables are strictly foreground
		["@variable.builtin"]       = { fg = colors.orange2 },
		["@parameter"]              = { fg = colors.fg },
		["@parameter.reference"]    = { fg = colors.fg },
		["@field"]                  = { fg = colors.blue2 }, -- Standard retrobox applies blue to fields/props
		["@property"]               = { fg = colors.blue2 },
		["@type"]                   = { fg = colors.type },
		["@type.builtin"]           = { fg = colors.type_builtin },
		["@class"]                  = { fg = colors.type },
		["@enum"]                   = { fg = colors.type },
		["@namespace"]              = { fg = colors.fg },
		["@struct"]                 = { fg = colors.type },
		["@module"]                 = { fg = colors.fg },
		["@attribute"]              = { fg = colors.orange2 },
		["@punctuation.delimiter"]  = { fg = colors.bracket },
		["@punctuation.bracket"]    = { fg = colors.bracket },
		["@punctuation.special"]    = { fg = colors.operator },
		["@operator"]               = { fg = colors.operator },
		["@comment"]                = { fg = colors.comment, italic = true },
		["@annotation"]             = { fg = colors.preprocessor },
		["@tag"]                    = { fg = colors.kw },
		["@tag.attribute"]          = { fg = colors.blue2 },
		["@tag.delimiter"]          = { fg = colors.bracket },
		["@constructor"]            = { fg = colors.type },
		["@constructor.lua"]        = { fg = colors.bracket },
		["@decorator"]              = { fg = colors.preprocessor },

		-- =====================================
		-- TELESCOPE
		-- =====================================
		TelescopeNormal             = { fg = colors.fg, bg = "NONE" },
		TelescopeBorder             = { fg = colors.border, bg = "NONE" },
		TelescopePromptNormal       = { fg = colors.white, bg = "NONE" },
		TelescopePromptBorder       = { fg = colors.border, bg = "NONE" },
		TelescopePromptTitle        = { fg = colors.title, bg = "NONE", bold = true },
		TelescopePromptCounter      = { fg = colors.comment, bg = "NONE" },
		TelescopeSelectionCaret     = { fg = colors.orange2, bg = colors.visual },
		TelescopeSelection          = { fg = colors.white, bg = colors.visual, bold = true },
		TelescopeMatching           = { fg = colors.orange2, bg = "NONE", bold = true },

		-- =====================================
		-- NVIM-CMP (Fixed Blending)
		-- =====================================
		-- Removed 'bg_color' so they properly inherit Pmenu background
		CmpItemAbbr                 = { fg = colors.fg, bg = "NONE" },
		CmpItemAbbrMatch            = { fg = colors.orange2, bg = "NONE", bold = true },
		CmpItemAbbrDeprecated       = { fg = colors.comment, bg = "NONE", strikethrough = true },
		CmpItemAbbrMatchFuzzy       = { fg = colors.orange2, bg = "NONE", bold = true },
		CmpItemMenu                 = { fg = colors.comment, bg = "NONE" },
		CmpBorder                   = { fg = colors.border },

		-- =====================================
		-- OIL
		-- =====================================
		OilDir                      = { fg = colors.blue2, bold = true },
		OilPermission               = { fg = colors.comment },
		OilSize                     = { fg = colors.constant },
		OilDate                     = { fg = colors.comment },
		OilFile                     = { fg = colors.fg },
		OilSocket                   = { fg = colors.type },
		OilLink                     = { fg = colors.string },
		OilLinkTarget               = { fg = colors.kw },
		OilCreate                   = { fg = colors.green2 },
		OilDelete                   = { fg = colors.error },
		OilMove                     = { fg = colors.orange2 },
		OilCopy                     = { fg = colors.string },
		OilChange                   = { fg = colors.changed },
		OilRestore                  = { fg = colors.info },
		OilPurge                    = { fg = colors.error },
		OilTrash                    = { fg = colors.warning },
		OilTrashSourcePath          = { fg = colors.comment },
		OilFloatBorder              = { fg = colors.border },

		-- =====================================
		-- GITSIGNS
		-- =====================================
		GitSignsAdd                 = { fg = colors.added, bg = "NONE" },
		GitSignsChange              = { fg = colors.changed, bg = "NONE" },
		GitSignsDelete              = { fg = colors.removed, bg = "NONE" },

		-- =====================================
		-- DIAGNOSTICS & LSP
		-- =====================================
		LspSignatureActiveParameter = { bg = colors.visual, italic = true },
		DiagnosticError             = { fg = colors.error },
		DiagnosticWarn              = { fg = colors.warning },
		DiagnosticHint              = { fg = colors.hint },
		DiagnosticInfo              = { fg = colors.info },
		DiagnosticVirtualTextError  = { fg = colors.error },
		DiagnosticVirtualTextWarn   = { fg = colors.warning },
		DiagnosticVirtualTextHint   = { fg = colors.hint },
		DiagnosticVirtualTextInfo   = { fg = colors.info },
		DiagnosticUnderlineError    = { gui = "undercurl", sp = colors.error },
		DiagnosticUnderlineWarn     = { gui = "undercurl", sp = colors.warning },
		DiagnosticUnderlineHint     = { gui = "undercurl", sp = colors.hint },
		DiagnosticUnderlineInfo     = { gui = "undercurl", sp = colors.info },

		-- =====================================
		-- MULTICURSOR
		-- =====================================
		MultipleCursorsCursor       = { bg = colors.cyan, fg = colors.black },
		MultipleCursorsVisual       = { bg = colors.purple_light, fg = colors.black },

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
		FlashLabel                  = { bg = colors.orange2, fg = colors.black, bold = true },

		-- =====================================
		-- WELCOME / DASHBOARD
		-- =====================================
		WelcomeRose                 = { fg = colors.red_light, bold = true },
		WelcomeStem                 = { fg = colors.green2, bold = true },
		WelcomeQuote                = { fg = colors.quote_fg, italic = true },

		-- =====================================
		-- AERIAL
		-- =====================================
		AerialLine                  = { fg = colors.orange2, bg = colors.visual, bold = true },
		AerialLineNC                = { fg = colors.comment, bg = colors.bg },
		AerialGuide                 = { fg = colors.comment },
		AerialSymbolsl              = { fg = colors.func, bg = colors.bgl, bold = true },
		AerialTextsl                = { fg = colors.type, bg = colors.bgl, bold = true },
	}

	-- CMP Kind Icons Loop (Fixed: No longer setting everything to pure red)
	local kinds = { "Text", "Method", "Function", "Constructor", "Field", "Variable", "Class", "Interface", "Module",
		"Property", "Unit", "Value", "Enum", "Keyword", "Snippet", "Color", "File", "Reference", "Folder", "EnumMember",
		"Constant", "Struct", "Event", "Operator", "TypeParameter" }
	for _, kind in ipairs(kinds) do highlight_groups["CmpItemKind" .. kind] = { fg = colors.func } end

	-- Application Loop
	for group, conf in pairs(highlight_groups) do
		local cmd = string.format("highlight %s guifg=%s guibg=%s", group, conf.fg or "NONE", conf.bg or "NONE")
		if conf.sp then cmd = cmd .. " guisp=" .. conf.sp end
		local gui = {}
		if conf.bold then table.insert(gui, "bold") end
		if conf.italic then table.insert(gui, "italic") end
		if conf.strikethrough then table.insert(gui, "strikethrough") end
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
