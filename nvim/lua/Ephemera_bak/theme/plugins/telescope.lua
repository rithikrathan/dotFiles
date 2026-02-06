local M = {}
local utils = require("Ephemera.theme.utils")

function M.setup(colors, config)
	local enabled = colors.plugins.telescope

	if not enabled then
		return
	end

	local highlight_groups = {
		TelescopeNormal = { fg = colors.kw, bg = "NONE" },
		TelescopeBorder = { fg = colors.kw, bg = "NONE" },
		TelescopePromptNormal = { fg = colors.pmenu_fg, bg = "NONE" },
		TelescopePromptBorder = { fg = colors.border, bg = "NONE" },
		TelescopePromptTitle = { fg = colors.fg, bg = "NONE", bold = true },
		TelescopePromptCounter = { fg = colors.cursor, bg = "NONE" },
		TelescopeSelectionCaret = { fg = colors.operator, bg = colors.visual },
		TelescopeSelection = { fg = colors.bool, bg = colors.visual, bold = true },
		TelescopeMatching = { fg = colors.operator, bg = "NONE", bold = true },
		TelescopePreviewNormal = { fg = colors.fg, bg = utils.get_bg_color(colors.pmenu_bg, config) },
		TelescopePreviewBorder = { fg = colors.border, bg = utils.get_bg_color(colors.pmenu_bg, config) },
		TelescopeResultsNormal = { fg = colors.fg, bg = utils.get_bg_color(colors.pmenu_bg, config) },
		TelescopeResultsBorder = { fg = colors.border, bg = utils.get_bg_color(colors.pmenu_bg, config) },
	}

	utils.apply_highlights(highlight_groups, colors, config)
end

return M
