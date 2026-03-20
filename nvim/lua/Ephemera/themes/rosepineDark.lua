local M = {}

M.config = {
	transparent = true,
	glow = true,
	show_end_of_buffer = false,
	colors = {
		-- Base UI (Ultra Dark Rosé Pine for LCD)
		fg                   = "#d8d4e8", -- Bright but soft
		bg                   = "#0a0810", -- Near-black purple
		bgl                  = "#080610", -- Darker for panels
		black                = "#000000",
		white                = "#e8e4f0",
		eob                  = "#1a1620", -- Subtle tildes
		border               = "#4a4060", -- Muted purple border
		title                = "#a080d0", -- Iris (brighter)

		-- Cursor & Selection
		cursor               = "#e8e4f0",
		cursorLine           = "#181420", -- Subtle highlight
		visual               = "#302840", -- Distinct selection
		line_nr              = "#504060", -- Visible line numbers

		-- Syntax (Rosé Pine with better LCD contrast)
		comment              = "#504860", -- Muted but readable
		string               = "#d0a050", -- Gold (brighter)
		func                 = "#d0a0a0", -- Rose (brighter)
		kw                   = "#a080d0", -- Iris (brighter)
		identifier           = "#d8d4e8", -- Normal text
		type                 = "#80c0d0", -- Foam (brighter)
		type_builtin         = "#405870", -- Pine (readable)
		operator             = "#706080", -- Subtle (readable)
		bracket              = "#605070", -- Muted
		preprocessor         = "#c05070", -- Love (brighter)
		bool                 = "#c0a0a0", -- Rose (brighter)
		constant             = "#c0a0a0", -- Rose

		-- Search & Highlighting
		search_highlight     = "#0a0810",
		search_bg            = "#504870", -- Highlight Med (brighter)
		inc_search_bg        = "#c08080", -- Rose (brighter)
		inc_search_fg        = "#080610",
		cur_search_bg        = "#c0a050",
		glow_color           = "#f0e8f8",

		-- Popup Menu
		pmenu_bg             = "#100c18", -- Darker than base bg
		pmenu_sel_bg         = "#302840",
		pmenu_fg             = "#d8d4e8",

		-- Git
		added                = "#70b0c0", -- Foam (brighter)
		changed              = "#c0a040", -- Gold (brighter)
		removed              = "#c04060", -- Love (brighter)

		-- Diagnostics
		error                = "#c04060", -- Love (Red)
		warning              = "#c0a040", -- Gold (Yellow)
		hint                 = "#80c0c0", -- Foam (Teal)
		info                 = "#405870", -- Pine (Blue)

		-- Plugin Specific
		bufferline_selection = "#a080d0",
		cyan                 = "#80c0d0",
		purple_light         = "#a080d0",
		quote_fg             = "#504860",

		-- Extended Palette
		orange1              = "#c0a040",
		orange2              = "#c0a040",
		orange3              = "#c0a0a0",
		orange4              = "#c0a040",

		red1                 = "#c04060",
		red2                 = "#c04060",
		red3                 = "#c04060",
		red4                 = "#c04060",
		red_light            = "#c0a0a0",

		green1               = "#70b0c0",
		green2               = "#405870",
		green3               = "#70b0c0",
		green4               = "#405870",

		blue1                = "#405870",
		blue2                = "#80c0d0",
		blue3                = "#405870",
		blue4                = "#405870",

		purple1              = "#a080d0",
		purple2              = "#a080d0",
		purple3              = "#a080d0",
		purple4              = "#a080d0",
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
		Identifier                  = { fg = colors.identifier },
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
		ModeMul                     = { fg = colors.bg, bg = colors.cyan, italic = true, bold = true },

		-- =====================================
		-- STATUSLINE
		-- =====================================
		ModeNorm                    = { fg = colors.bg, bg = colors.purple1, italic = true, bold = true },
		SepNormA                    = { fg = colors.purple1, bg = colors.pmenu_bg },
		InfoNorm                    = { fg = colors.fg, bg = colors.pmenu_bg },
		SepNormB                    = { fg = colors.pmenu_bg, bg = colors.bgl },
		ModeIns                     = { fg = colors.bg, bg = colors.string, italic = true, bold = true }, -- Gold for insert
		SepInsA                     = { fg = colors.string, bg = colors.pmenu_bg },
		InfoIns                     = { fg = colors.fg, bg = colors.pmenu_bg },
		SepInsB                     = { fg = colors.pmenu_bg, bg = colors.bgl },
		ModeVis                     = { fg = colors.bg, bg = colors.func, italic = true, bold = true }, -- Rose for visual
		SepVisA                     = { fg = colors.func, bg = colors.pmenu_bg },
		InfoVis                     = { fg = colors.fg, bg = colors.pmenu_bg },
		SepVisB                     = { fg = colors.pmenu_bg, bg = colors.bgl },
		StatusBody                  = { fg = colors.fg, bg = colors.bgl, bold = true },
		SlRef                       = { fg = colors.comment, bg = colors.bgl, italic = true },

		-- =====================================
		-- TREESITTER
		-- =====================================
		["@function"]               = { fg = colors.func },
		["@method"]                 = { fg = colors.func },
		["@function.builtin"]       = { fg = colors.func, italic = true },
		["@function.call"]          = { fg = colors.func },
		["@keyword"]                = { fg = colors.kw },
		["@keyword.function"]       = { fg = colors.kw, italic = true },
		["@keyword.return"]         = { fg = colors.kw, italic = true },
		["@conditional"]            = { fg = colors.kw },
		["@repeat"]                 = { fg = colors.kw },
		["@constant"]               = { fg = colors.constant },
		["@constant.builtin"]       = { fg = colors.constant },
		["@string"]                 = { fg = colors.string },
		["@string.regex"]           = { fg = colors.preprocessor },
		["@string.escape"]          = { fg = colors.type_builtin },
		["@number"]                 = { fg = colors.constant },
		["@boolean"]                = { fg = colors.bool },
		["@variable"]               = { fg = colors.fg },
		["@variable.builtin"]       = { fg = colors.type, italic = true },
		["@parameter"]              = { fg = colors.fg, italic = true },
		["@parameter.reference"]    = { fg = colors.fg },
		["@field"]                  = { fg = colors.type }, -- Foam for fields matches Rosé Pine defaults
		["@property"]               = { fg = colors.type },
		["@type"]                   = { fg = colors.type },
		["@type.builtin"]           = { fg = colors.type_builtin },
		["@class"]                  = { fg = colors.type },
		["@enum"]                   = { fg = colors.type },
		["@namespace"]              = { fg = colors.fg },
		["@struct"]                 = { fg = colors.type },
		["@module"]                 = { fg = colors.fg },
		["@attribute"]              = { fg = colors.func },
		["@punctuation.delimiter"]  = { fg = colors.bracket },
		["@punctuation.bracket"]    = { fg = colors.bracket },
		["@punctuation.special"]    = { fg = colors.operator },
		["@operator"]               = { fg = colors.operator },
		["@comment"]                = { fg = colors.comment, italic = true },
		["@annotation"]             = { fg = colors.preprocessor },
		["@tag"]                    = { fg = colors.kw },
		["@tag.attribute"]          = { fg = colors.type },
		["@tag.delimiter"]          = { fg = colors.bracket },
		["@constructor"]            = { fg = colors.type },
		["@constructor.lua"]        = { fg = colors.bracket },
		["@decorator"]              = { fg = colors.func },

		-- =====================================
		-- TELESCOPE
		-- =====================================
		TelescopeNormal             = { fg = colors.fg, bg = "NONE" },
		TelescopeBorder             = { fg = colors.border, bg = "NONE" },
		TelescopePromptNormal       = { fg = colors.white, bg = "NONE" },
		TelescopePromptBorder       = { fg = colors.border, bg = "NONE" },
		TelescopePromptTitle        = { fg = colors.title, bg = "NONE", bold = true },
		TelescopePromptCounter      = { fg = colors.comment, bg = "NONE" },
		TelescopeSelectionCaret     = { fg = colors.func, bg = colors.visual },
		TelescopeSelection          = { fg = colors.white, bg = colors.visual, bold = true },
		TelescopeMatching           = { fg = colors.string, bg = "NONE", bold = true },

		-- =====================================
		-- NVIM-CMP
		-- =====================================
		CmpItemAbbr                 = { fg = colors.fg, bg = "NONE" },
		CmpItemAbbrMatch            = { fg = colors.func, bg = "NONE", bold = true },
		CmpItemAbbrDeprecated       = { fg = colors.comment, bg = "NONE", strikethrough = true },
		CmpItemAbbrMatchFuzzy       = { fg = colors.func, bg = "NONE", bold = true },
		CmpItemMenu                 = { fg = colors.comment, bg = "NONE" },
		CmpBorder                   = { fg = colors.border },

		-- =====================================
		-- OIL
		-- =====================================
		OilDir                      = { fg = colors.type, bold = true }, -- Foam
		OilPermission               = { fg = colors.comment },
		OilSize                     = { fg = colors.constant },
		OilDate                     = { fg = colors.comment },
		OilFile                     = { fg = colors.fg },
		OilSocket                   = { fg = colors.type },
		OilLink                     = { fg = colors.cyan },
		OilLinkTarget               = { fg = colors.kw },
		OilCreate                   = { fg = colors.func },
		OilDelete                   = { fg = colors.error },
		OilMove                     = { fg = colors.orange1 },
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
		FlashLabel                  = { bg = colors.kw, fg = colors.black, bold = true },

		-- =====================================
		-- WELCOME / DASHBOARD
		-- =====================================
		WelcomeRose                 = { fg = colors.red_light, bold = true },
		WelcomeStem                 = { fg = colors.green1, bold = true },
		WelcomeQuote                = { fg = colors.quote_fg, italic = true },

		-- =====================================
		-- AERIAL
		-- =====================================
		AerialLine                  = { fg = colors.func, bg = colors.visual, bold = true },
		AerialLineNC                = { fg = colors.comment, bg = colors.bg },
		AerialGuide                 = { fg = colors.comment },
		AerialSymbolsl              = { fg = colors.func, bg = colors.bgl, bold = true },
		AerialTextsl                = { fg = colors.type, bg = colors.bgl, bold = true },
	}

	-- CMP Kind Icons Loop
	local kinds = { "Text", "Method", "Function", "Constructor", "Field", "Variable", "Class", "Interface", "Module",
		"Property", "Unit", "Value", "Enum", "Keyword", "Snippet", "Color", "File", "Reference", "Folder", "EnumMember",
		"Constant", "Struct", "Event", "Operator", "TypeParameter" }

	-- Using Iris Purple for completion icons
	for _, kind in ipairs(kinds) do highlight_groups["CmpItemKind" .. kind] = { fg = colors.purple1 } end

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
