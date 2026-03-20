local M = {}

M.config = {
	transparent = true,
	glow = true,
	show_end_of_buffer = false,
	colors = {
		fg                   = "#f8f8f2",
		bg                   = "#060606",
		bgl                  = "#040404",
		black                = "#000000",
		white                = "#ffffff",
		eob                  = "#1a1a1a",
		border               = "#505060",
		title                = "#a6e22e",

		cursor               = "#f8f8f2",
		cursorLine           = "#1a1a2a",
		visual               = "#333344",
		line_nr              = "#505060",

		comment              = "#606878",
		string               = "#e6db74",
		func                 = "#a6e22e",
		kw                   = "#f92672",
		identifier           = "#f8f8f2",
		type                 = "#66d9ef",
		type_builtin         = "#fd971f",
		operator             = "#f92672",
		bracket              = "#f8f8f0",
		preprocessor         = "#ae81ff",
		bool                 = "#ae81ff",
		constant             = "#ae81ff",

		search_highlight     = "#060606",
		search_bg            = "#f4bf75",
		inc_search_bg        = "#66d9ef",
		inc_search_fg        = "#060606",
		cur_search_bg        = "#a6e22e",
		glow_color           = "#f8f8f2",

		pmenu_bg             = "#0e0e14",
		pmenu_sel_bg         = "#333344",
		pmenu_fg             = "#f8f8f2",

		added                = "#a6e22e",
		changed              = "#f4bf75",
		removed              = "#f92672",

		error                = "#f92672",
		warning              = "#f4bf75",
		hint                 = "#66d9ef",
		info                 = "#ae81ff",

		bufferline_selection = "#f92672",
		cyan                 = "#66d9ef",
		purple_light         = "#ae81ff",
		quote_fg             = "#606878",

		orange1              = "#fd971f",
		orange2              = "#f4bf75",
		orange3              = "#e6db74",
		orange4              = "#fd971f",

		red1                 = "#f92672",
		red2                 = "#f74a60",
		red3                 = "#ff2a5a",
		red4                 = "#f92672",
		red_light            = "#ff5a80",

		green1               = "#a6e22e",
		green2               = "#b8e060",
		green3               = "#c8f080",
		green4               = "#a6e22e",

		blue1                = "#66d9ef",
		blue2                = "#9aeeff",
		blue3                = "#74d0f0",
		blue4                = "#66d9ef",

		purple1              = "#ae81ff",
		purple2              = "#c0a0ff",
		purple3              = "#d0b8ff",
		purple4              = "#ae81ff",
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

		Normal                      = { fg = colors.fg, bg = bg_color },
		Folded                      = { fg = colors.comment, bg = bg_color, italic = true },
		FoldColumn                  = { fg = colors.comment, bg = bg_color },
		Cursor                      = { fg = colors.cursor, bg = bg_color },
		CursorLine                  = { bg = colors.cursorLine },
		LineNr                      = { fg = colors.line_nr },
		Visual                      = { bg = colors.visual },
		EndOfBuffer                 = { fg = M.config.show_end_of_buffer and colors.eob or colors.bg, bg = bg_color },
		WinSeparator                = { fg = colors.border, bg = bg_color },

		MsgSeparator                = { bg = colors.bgl },
		MsgArea                     = { fg = colors.fg, bg = bg_color },
		ModeMsg                     = { fg = colors.string, bold = true },

		Search                      = { bg = colors.search_bg, fg = colors.search_highlight, bold = true },
		IncSearch                   = { bg = colors.inc_search_bg, fg = colors.inc_search_fg, bold = true },
		CurSearch                   = { bg = colors.cur_search_bg, fg = colors.black, bold = true },

		Pmenu                       = { fg = colors.pmenu_fg, bg = float_bg },
		PmenuSel                    = { fg = colors.white, bg = colors.pmenu_sel_bg, bold = true },
		NormalFloat                 = { fg = colors.fg, bg = float_bg },
		FloatBorder                 = { fg = colors.border, bg = float_bg },

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

		ModeVenn                    = { fg = colors.bg, bg = colors.preprocessor, italic = true, bold = true },
		ModeMul                     = { fg = colors.bg, bg = colors.cyan, italic = true, bold = true },

		ModeNorm                    = { fg = colors.bg, bg = colors.kw, italic = true, bold = true },
		SepNormA                    = { fg = colors.kw, bg = colors.pmenu_bg },
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

		["@function"]               = { fg = colors.func },
		["@method"]                 = { fg = colors.func },
		["@function.builtin"]       = { fg = colors.orange1 },
		["@function.call"]          = { fg = colors.func },
		["@keyword"]                = { fg = colors.kw },
		["@keyword.function"]       = { fg = colors.kw, italic = true },
		["@keyword.return"]         = { fg = colors.kw, italic = true },
		["@conditional"]            = { fg = colors.kw },
		["@repeat"]                 = { fg = colors.kw },
		["@constant"]               = { fg = colors.constant },
		["@constant.builtin"]       = { fg = colors.constant },
		["@string"]                 = { fg = colors.string },
		["@string.regex"]           = { fg = colors.func },
		["@string.escape"]          = { fg = colors.orange1 },
		["@number"]                 = { fg = colors.constant },
		["@boolean"]                = { fg = colors.bool },
		["@variable"]               = { fg = colors.fg },
		["@variable.builtin"]       = { fg = colors.orange1, italic = true },
		["@parameter"]              = { fg = colors.fg, italic = true },
		["@parameter.reference"]    = { fg = colors.fg },
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
		["@tag.attribute"]          = { fg = colors.type },
		["@tag.delimiter"]          = { fg = colors.bracket },
		["@constructor"]            = { fg = colors.type },
		["@constructor.lua"]        = { fg = colors.bracket },
		["@decorator"]              = { fg = colors.preprocessor },

		TelescopeNormal             = { fg = colors.fg, bg = "NONE" },
		TelescopeBorder             = { fg = colors.border, bg = "NONE" },
		TelescopePromptNormal       = { fg = colors.white, bg = "NONE" },
		TelescopePromptBorder       = { fg = colors.border, bg = "NONE" },
		TelescopePromptTitle        = { fg = colors.title, bg = "NONE", bold = true },
		TelescopePromptCounter      = { fg = colors.comment, bg = "NONE" },
		TelescopeSelectionCaret     = { fg = colors.func, bg = colors.visual },
		TelescopeSelection          = { fg = colors.white, bg = colors.visual, bold = true },
		TelescopeMatching           = { fg = colors.green1, bg = "NONE", bold = true },

		CmpItemAbbr                 = { fg = colors.fg, bg = "NONE" },
		CmpItemAbbrMatch            = { fg = colors.green1, bg = "NONE", bold = true },
		CmpItemAbbrDeprecated       = { fg = colors.comment, bg = "NONE", strikethrough = true },
		CmpItemAbbrMatchFuzzy       = { fg = colors.green1, bg = "NONE", bold = true },
		CmpItemMenu                 = { fg = colors.comment, bg = "NONE" },
		CmpBorder                   = { fg = colors.border },

		OilDir                      = { fg = colors.green1, bold = true },
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

		GitSignsAdd                 = { fg = colors.added, bg = "NONE" },
		GitSignsChange              = { fg = colors.changed, bg = "NONE" },
		GitSignsDelete              = { fg = colors.removed, bg = "NONE" },

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

		MultipleCursorsCursor       = { bg = colors.cyan, fg = colors.black },
		MultipleCursorsVisual       = { bg = colors.purple_light, fg = colors.black },

		MultiCursorCursor           = { bg = colors.cyan, fg = colors.black },
		MultiCursorVisual           = { bg = colors.purple_light, fg = colors.black },
		MultiCursorSign             = { link = "SignColumn" },
		MultiCursorMatchPreview     = { link = "Search" },
		MultiCursorDisabledCursor   = { bg = colors.cyan, fg = colors.black },
		MultiCursorDisabledVisual   = { bg = colors.purple_light, fg = colors.black },
		MultiCursorDisabledSign     = { link = "SignColumn" },

		FlashLabel                  = { bg = colors.orange2, fg = colors.black, bold = true },

		WelcomeRose                 = { fg = colors.red_light, bold = true },
		WelcomeStem                 = { fg = colors.green1, bold = true },
		WelcomeQuote                = { fg = colors.quote_fg, italic = true },

		AerialLine                  = { fg = colors.green1, bg = colors.visual, bold = true },
		AerialLineNC                = { fg = colors.comment, bg = colors.bg },
		AerialGuide                 = { fg = colors.comment },
		AerialSymbolsl              = { fg = colors.func, bg = colors.bgl, bold = true },
		AerialTextsl                = { fg = colors.type, bg = colors.bgl, bold = true },
	}

	local kinds = { "Text", "Method", "Function", "Constructor", "Field", "Variable", "Class", "Interface", "Module",
		"Property", "Unit", "Value", "Enum", "Keyword", "Snippet", "Color", "File", "Reference", "Folder", "EnumMember",
		"Constant", "Struct", "Event", "Operator", "TypeParameter" }
	for _, kind in ipairs(kinds) do highlight_groups["CmpItemKind" .. kind] = { fg = colors.green1 } end

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
