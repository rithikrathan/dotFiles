local M = {}

M.config = {
	transparent = true,
	glow = true,
	show_end_of_buffer = false,
	colors = {
		fg                   = "#d8dee9",
		bg                   = "#07090f",
		bgl                  = "#05070c",
		black                = "#000000",
		white                = "#e8eef8",
		eob                  = "#1a2030",
		border               = "#4b5b70",
		title                = "#81a1c1",

		cursor               = "#d8dee9",
		cursorLine           = "#182030",
		visual               = "#2a3848",
		line_nr              = "#4a6070",

		comment              = "#607080",
		string               = "#a3be8c",
		func                 = "#88c0d0",
		kw                   = "#81a1c1",
		identifier           = "#d8dee9",
		type                 = "#8fbcbb",
		type_builtin         = "#88c0d0",
		operator             = "#8fbcbb",
		bracket              = "#d8dee9",
		preprocessor         = "#bf616a",
		bool                 = "#ebcb8b",
		constant             = "#ebcb8b",

		search_highlight     = "#07090f",
		search_bg            = "#ebcb8b",
		inc_search_bg        = "#88c0d0",
		inc_search_fg        = "#07090f",
		cur_search_bg        = "#d08770",
		glow_color           = "#e8eef8",

		pmenu_bg             = "#0e1018",
		pmenu_sel_bg         = "#2a3848",
		pmenu_fg             = "#d8dee9",

		added                = "#a3be8c",
		changed              = "#ebcb8b",
		removed              = "#bf616a",

		error                = "#bf616a",
		warning              = "#ebcb8b",
		hint                 = "#88c0d0",
		info                 = "#8fbcbb",

		bufferline_selection = "#81a1c1",
		cyan                 = "#88c0d0",
		purple_light         = "#b48ead",
		quote_fg             = "#607080",

		orange1              = "#d08770",
		orange2              = "#ebcb8b",
		orange3              = "#bf616a",
		orange4              = "#d08770",

		red1                 = "#bf616a",
		red2                 = "#b05a60",
		red3                 = "#c06a70",
		red4                 = "#bf616a",
		red_light            = "#d08090",

		green1               = "#a3be8c",
		green2               = "#8fbcbb",
		green3               = "#b8e8d8",
		green4               = "#a3be8c",

		blue1                = "#81a1c1",
		blue2                = "#8fbcbb",
		blue3                = "#88c0d0",
		blue4                = "#81a1c1",

		purple1              = "#b48ead",
		purple2              = "#a3be8c",
		purple3              = "#8fbcbb",
		purple4              = "#b48ead",
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

		ModeNorm                    = { fg = colors.bg, bg = colors.blue1, italic = true, bold = true },
		SepNormA                    = { fg = colors.blue1, bg = colors.pmenu_bg },
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
		["@function.builtin"]       = { fg = colors.cyan },
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
		["@variable.builtin"]       = { fg = colors.cyan, italic = true },
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

		TelescopeNormal             = { fg = colors.fg, bg = "NONE" },
		TelescopeBorder             = { fg = colors.border, bg = "NONE" },
		TelescopePromptNormal       = { fg = colors.white, bg = "NONE" },
		TelescopePromptBorder       = { fg = colors.border, bg = "NONE" },
		TelescopePromptTitle        = { fg = colors.title, bg = "NONE", bold = true },
		TelescopePromptCounter      = { fg = colors.comment, bg = "NONE" },
		TelescopeSelectionCaret     = { fg = colors.kw, bg = colors.visual },
		TelescopeSelection          = { fg = colors.white, bg = colors.visual, bold = true },
		TelescopeMatching           = { fg = colors.green1, bg = "NONE", bold = true },

		CmpItemAbbr                 = { fg = colors.fg, bg = "NONE" },
		CmpItemAbbrMatch            = { fg = colors.green1, bg = "NONE", bold = true },
		CmpItemAbbrDeprecated       = { fg = colors.comment, bg = "NONE", strikethrough = true },
		CmpItemAbbrMatchFuzzy       = { fg = colors.green1, bg = "NONE", bold = true },
		CmpItemMenu                 = { fg = colors.comment, bg = "NONE" },
		CmpBorder                   = { fg = colors.border },

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

		AerialLine                  = { fg = colors.blue1, bg = colors.visual, bold = true },
		AerialLineNC                = { fg = colors.comment, bg = colors.bg },
		AerialGuide                 = { fg = colors.comment },
		AerialSymbolsl              = { fg = colors.func, bg = colors.bgl, bold = true },
		AerialTextsl                = { fg = colors.type, bg = colors.bgl, bold = true },
	}

	local kinds = { "Text", "Method", "Function", "Constructor", "Field", "Variable", "Class", "Interface", "Module",
		"Property", "Unit", "Value", "Enum", "Keyword", "Snippet", "Color", "File", "Reference", "Folder", "EnumMember",
		"Constant", "Struct", "Event", "Operator", "TypeParameter" }
	for _, kind in ipairs(kinds) do highlight_groups["CmpItemKind" .. kind] = { fg = colors.blue1 } end

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
