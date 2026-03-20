local M = {}

M.config = {
	transparent = true,
	glow = true,
	show_end_of_buffer = false,
	colors = {
		-- Base UI (Ultra Dark Catppuccin for LCD)
		fg                   = "#d0d0e8", -- Bright but soft
		bg                   = "#0a0a14", -- Deep dark purple-black
		bgl                  = "#080810", -- Darker for panels
		black                = "#000000",
		white                = "#e0e0f0",
		eob                  = "#1a1a28", -- Subtle end-of-buffer
		border               = "#505070", -- Muted border
		title                = "#7090d0", -- Blue (brighter)

		-- Cursor & Selection
		cursor               = "#e0d0d8",
		cursorLine           = "#1c1c2a", -- Subtle highlight
		visual               = "#2c2c40", -- Distinct selection
		line_nr              = "#505068", -- Visible line numbers

		-- Syntax (Catppuccin with better LCD contrast)
		comment              = "#606080", -- Muted blue
		string               = "#80c070", -- Green (brighter)
		func                 = "#7090d0", -- Blue (brighter)
		kw                   = "#a080d0", -- Mauve (brighter)
		identifier           = "#d0d0e8", -- Normal text
		type                 = "#c0b070", -- Yellow (brighter)
		type_builtin         = "#c09060", -- Peach (brighter)
		operator             = "#70c0d0", -- Sky (brighter)
		bracket              = "#70c0b0", -- Teal (brighter)
		preprocessor         = "#c07080", -- Red (brighter)
		bool                 = "#c09070", -- Peach (brighter)
		constant             = "#c09070", -- Peach

		-- Search & Highlighting
		search_highlight     = "#0a0a14",
		search_bg            = "#b0a040", -- Yellow bg
		inc_search_bg        = "#c09060", -- Peach bg
		inc_search_fg        = "#080810",
		cur_search_bg        = "#c0b040",
		glow_color           = "#e0e0f0",

		-- Popup Menu
		pmenu_bg             = "#0e0e18", -- Darker than base bg
		pmenu_sel_bg         = "#2c2c40",
		pmenu_fg             = "#d0d0e8",

		-- Git
		added                = "#70c060", -- Green
		changed              = "#b0a030", -- Yellow
		removed              = "#c06070", -- Red

		-- Diagnostics
		error                = "#c06070", -- Red
		warning              = "#c0b030", -- Yellow
		hint                 = "#70b0a0", -- Teal
		info                 = "#70b0c0", -- Sky

		-- Plugin Specific
		bufferline_selection = "#a080d0",
		cyan                 = "#70b0c0",
		purple_light         = "#a080d0",
		quote_fg             = "#606080",

		-- Extended Palette
		orange1              = "#c08050",
		orange2              = "#c09060",
		orange3              = "#b08080",
		orange4              = "#c08050",

		red1                 = "#c06070",
		red2                 = "#c06070",
		red3                 = "#b08080",
		red4                 = "#c06070",
		red_light            = "#d0a0c0",

		green1               = "#70c060",
		green2               = "#70c060",
		green3               = "#70b0a0",
		green4               = "#70c060",

		blue1                = "#7090d0",
		blue2                = "#60a0c0",
		blue3                = "#70b0c0",
		blue4                = "#7090d0",

		purple1              = "#a080d0",
		purple2              = "#a080d0",
		purple3              = "#c090b0",
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
		CurSearch                   = { bg = colors.cur_search_bg, fg = colors.search_highlight, bold = true },

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
		Identifier                  = { fg = colors.identifier }, -- Keeps standard text bright!
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
		ModeIns                     = { fg = colors.bg, bg = colors.green1, italic = true, bold = true },
		SepInsA                     = { fg = colors.green1, bg = colors.pmenu_bg },
		InfoIns                     = { fg = colors.fg, bg = colors.pmenu_bg },
		SepInsB                     = { fg = colors.pmenu_bg, bg = colors.bgl },
		ModeVis                     = { fg = colors.bg, bg = colors.orange1, italic = true, bold = true },
		SepVisA                     = { fg = colors.orange1, bg = colors.pmenu_bg },
		InfoVis                     = { fg = colors.fg, bg = colors.pmenu_bg },
		SepVisB                     = { fg = colors.pmenu_bg, bg = colors.bgl },
		StatusBody                  = { fg = colors.fg, bg = colors.bgl, bold = true },
		SlRef                       = { fg = colors.comment, bg = colors.bgl, italic = true },

		-- =====================================
		-- TREESITTER
		-- =====================================
		["@function"]               = { fg = colors.func },
		["@method"]                 = { fg = colors.func },
		["@function.builtin"]       = { fg = colors.red_light },
		["@function.call"]          = { fg = colors.func },
		["@keyword"]                = { fg = colors.kw },
		["@keyword.function"]       = { fg = colors.kw, italic = true },
		["@keyword.return"]         = { fg = colors.kw, italic = true },
		["@conditional"]            = { fg = colors.kw },
		["@repeat"]                 = { fg = colors.kw },
		["@constant"]               = { fg = colors.constant },
		["@constant.builtin"]       = { fg = colors.constant },
		["@string"]                 = { fg = colors.string },
		["@string.regex"]           = { fg = colors.red1 },
		["@string.escape"]          = { fg = colors.orange1 },
		["@number"]                 = { fg = colors.constant },
		["@boolean"]                = { fg = colors.bool },
		["@variable"]               = { fg = colors.fg },
		["@variable.builtin"]       = { fg = colors.red_light, italic = true },
		["@parameter"]              = { fg = colors.orange1, italic = true },
		["@parameter.reference"]    = { fg = colors.orange1 },
		["@field"]                  = { fg = colors.fg },
		["@property"]               = { fg = colors.fg },
		["@type"]                   = { fg = colors.type },
		["@type.builtin"]           = { fg = colors.type_builtin },
		["@class"]                  = { fg = colors.type },
		["@enum"]                   = { fg = colors.type },
		["@namespace"]              = { fg = colors.fg },
		["@struct"]                 = { fg = colors.type },
		["@module"]                 = { fg = colors.fg },
		["@attribute"]              = { fg = colors.green1 },
		["@punctuation.delimiter"]  = { fg = colors.bracket },
		["@punctuation.bracket"]    = { fg = colors.bracket },
		["@punctuation.special"]    = { fg = colors.operator },
		["@operator"]               = { fg = colors.operator },
		["@comment"]                = { fg = colors.comment, italic = true },
		["@annotation"]             = { fg = colors.preprocessor },
		["@tag"]                    = { fg = colors.kw },
		["@tag.attribute"]          = { fg = colors.orange1 },
		["@tag.delimiter"]          = { fg = colors.bracket },
		["@constructor"]            = { fg = colors.type },
		["@constructor.lua"]        = { fg = colors.bracket },
		["@decorator"]              = { fg = colors.orange1 },

		-- =====================================
		-- TELESCOPE
		-- =====================================
		TelescopeNormal             = { fg = colors.fg, bg = "NONE" },
		TelescopeBorder             = { fg = colors.border, bg = "NONE" },
		TelescopePromptNormal       = { fg = colors.white, bg = "NONE" },
		TelescopePromptBorder       = { fg = colors.border, bg = "NONE" },
		TelescopePromptTitle        = { fg = colors.title, bg = "NONE", bold = true },
		TelescopePromptCounter      = { fg = colors.comment, bg = "NONE" },
		TelescopeSelectionCaret     = { fg = colors.kw, bg = colors.visual },
		TelescopeSelection          = { fg = colors.white, bg = colors.visual, bold = true },
		TelescopeMatching           = { fg = colors.green1, bg = "NONE", bold = true },

		-- =====================================
		-- NVIM-CMP
		-- =====================================
		CmpItemAbbr                 = { fg = colors.fg, bg = "NONE" },
		CmpItemAbbrMatch            = { fg = colors.blue1, bg = "NONE", bold = true },
		CmpItemAbbrDeprecated       = { fg = colors.comment, bg = "NONE", strikethrough = true },
		CmpItemAbbrMatchFuzzy       = { fg = colors.blue1, bg = "NONE", bold = true },
		CmpItemMenu                 = { fg = colors.comment, bg = "NONE" },
		CmpBorder                   = { fg = colors.border },

		-- =====================================
		-- OIL
		-- =====================================
		OilDir                      = { fg = colors.blue1, bold = true },
		OilPermission               = { fg = colors.comment },
		OilSize                     = { fg = colors.constant },
		OilDate                     = { fg = colors.comment },
		OilFile                     = { fg = colors.fg },
		OilSocket                   = { fg = colors.type },
		OilLink                     = { fg = colors.cyan },
		OilLinkTarget               = { fg = colors.kw },
		OilCreate                   = { fg = colors.green1 },
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
		FlashLabel                  = { bg = colors.orange2, fg = colors.black, bold = true },

		-- =====================================
		-- WELCOME / DASHBOARD
		-- =====================================
		WelcomeRose                 = { fg = colors.red_light, bold = true },
		WelcomeStem                 = { fg = colors.green1, bold = true },
		WelcomeQuote                = { fg = colors.quote_fg, italic = true },

		-- =====================================
		-- AERIAL
		-- =====================================
		AerialLine                  = { fg = colors.blue1, bg = colors.visual, bold = true },
		AerialLineNC                = { fg = colors.comment, bg = colors.bg },
		AerialGuide                 = { fg = colors.comment },
		AerialSymbolsl              = { fg = colors.func, bg = colors.bgl, bold = true },
		AerialTextsl                = { fg = colors.type, bg = colors.bgl, bold = true },
	}

	-- CMP Kind Icons Loop
	local kinds = { "Text", "Method", "Function", "Constructor", "Field", "Variable", "Class", "Interface", "Module",
		"Property", "Unit", "Value", "Enum", "Keyword", "Snippet", "Color", "File", "Reference", "Folder", "EnumMember",
		"Constant", "Struct", "Event", "Operator", "TypeParameter" }

	-- Using Sky Blue for completion icons
	for _, kind in ipairs(kinds) do highlight_groups["CmpItemKind" .. kind] = { fg = colors.cyan } end

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
