local M = {}

M.config = {
	transparent = true,
	glow = true,
	show_end_of_buffer = false,
	colors = {
		-- Base UI (Rosé Pine Main)
		fg                   = "#e0def4", -- Text (Bright and high contrast)
		bg                   = "#191724", -- Base (Deep dusty dark background)
		bgl                  = "#1f1d2e", -- Surface (Floating menus/statusline base)
		black                = "#191724",
		white                = "#e0def4",
		eob                  = "#26233a", -- Overlay (Subtle end-of-buffer)
		border               = "#403d52", -- Highlight Med (Clear borders)
		title                = "#c4a7e7", -- Iris (Purple)

		-- Cursor & Selection
		cursor               = "#e0def4", -- Text
		cursorLine           = "#21202e", -- Highlight Low
		visual               = "#403d52", -- Highlight Med (Distinct selection)
		line_nr              = "#6e6a86", -- Muted (Line numbers)

		-- Syntax (Rosé Pine Strict Palette)
		comment              = "#6e6a86", -- Muted
		string               = "#f6c177", -- Gold
		func                 = "#ebbcba", -- Rose (Functions/Methods)
		kw                   = "#c4a7e7", -- Iris (Keywords/Control flow)
		identifier           = "#e0def4", -- Text (Keeps normal text bright and consistent)
		type                 = "#9ccfd8", -- Foam (Teal for types)
		type_builtin         = "#31748f", -- Pine (Darker cyan)
		operator             = "#908caa", -- Subtle
		bracket              = "#6e6a86", -- Muted
		preprocessor         = "#eb6f92", -- Love (Red)
		bool                 = "#ebbcba", -- Rose
		constant             = "#ebbcba", -- Rose

		-- Search & Highlighting
		search_highlight     = "#e0def4", -- Text
		search_bg            = "#403d52", -- Highlight Med
		inc_search_bg        = "#ebbcba", -- Rose
		inc_search_fg        = "#191724", -- Base
		cur_search_bg        = "#f6c177", -- Gold
		glow_color           = "#e0def4",

		-- Popup Menu (High Contrast Floating Windows)
		pmenu_bg             = "#1f1d2e", -- Surface
		pmenu_sel_bg         = "#403d52", -- Highlight Med
		pmenu_fg             = "#e0def4", -- Text

		-- Git
		added                = "#9ccfd8", -- Foam
		changed              = "#f6c177", -- Gold
		removed              = "#eb6f92", -- Love

		-- Diagnostics
		error                = "#eb6f92", -- Love (Red)
		warning              = "#f6c177", -- Gold (Yellow)
		hint                 = "#9ccfd8", -- Foam (Teal)
		info                 = "#31748f", -- Pine (Blue)

		-- Plugin Specific
		bufferline_selection = "#c4a7e7", -- Iris
		cyan                 = "#9ccfd8", -- Foam
		purple_light         = "#c4a7e7", -- Iris
		quote_fg             = "#6e6a86", -- Muted

		-- Extended Palette (Rosé Pine mapped)
		orange1              = "#f6c177", -- Gold
		orange2              = "#f6c177",
		orange3              = "#ebbcba", -- Rose
		orange4              = "#f6c177",

		red1                 = "#eb6f92", -- Love
		red2                 = "#eb6f92",
		red3                 = "#eb6f92",
		red4                 = "#eb6f92",
		red_light            = "#ebbcba", -- Rose for welcome dashboard

		green1               = "#9ccfd8", -- Foam (Rosé pine lacks a true green, relies on Foam)
		green2               = "#31748f", -- Pine
		green3               = "#9ccfd8",
		green4               = "#31748f",

		blue1                = "#31748f", -- Pine
		blue2                = "#9ccfd8", -- Foam
		blue3                = "#31748f",
		blue4                = "#31748f",

		purple1              = "#c4a7e7", -- Iris
		purple2              = "#c4a7e7",
		purple3              = "#c4a7e7",
		purple4              = "#c4a7e7",
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
