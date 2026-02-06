local M = {}
local utils = require("Ephemera.theme.utils")

M.setup = function(colors, config)
	local enabled = colors.plugins.nvim_cmp

	if not enabled then
		return
	end

	local highlight_groups = {
		CmpItemAbbr = { fg = colors.fg, bg = utils.get_bg_color("NONE", config) },
		CmpItemAbbrMatch = { fg = colors.cursor, bg = utils.get_bg_color("NONE", config), bold = true },
		CmpItemAbbrDeprecated = {
			fg = colors.comment,
			bg = utils.get_bg_color("NONE", config),
			italic = true,
		},
		CmpItemAbbrMatchFuzzy = { fg = colors.visual, bg = utils.get_bg_color("NONE", config), bold = true },
		CmpItemMenu = { fg = colors.comment, bg = utils.get_bg_color("NONE", config) },
	}

	local kinds = {
		"Text", "Method", "Function", "Constructor", "Field", "Variable",
		"Class", "Interface", "Module", "Property", "Unit", "Value",
		"Enum", "Keyword", "Snippet", "Color", "File", "Reference",
		"Folder", "EnumMember", "Constant", "Struct", "Event", "Operator", "TypeParameter",
	}

	for _, kind in ipairs(kinds) do
		highlight_groups["CmpItemKind" .. kind] = { fg = colors.kw }
	end

	utils.apply_highlights(highlight_groups, colors, config)
end

return M
