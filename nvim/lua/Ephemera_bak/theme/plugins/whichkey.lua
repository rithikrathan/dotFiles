local M = {}

function M.setup(colors, config)
	local utils = require("Ephemera.theme.utils")

	if not colors.plugins.whichkey then
		return
	end

	local highlight_groups = {
		WhichKey = { fg = colors.func, bg = utils.get_bg_color(colors.bg, config) },
		WhichKeyBorder = { fg = colors.comment, bg = utils.get_bg_color(colors.bg, config) },
		WhichKeyDesc = { fg = colors.func, bg = utils.get_bg_color(colors.bg, config) },
		WhichKeyGroup = { fg = colors.kw, bg = utils.get_bg_color(colors.bg, config), gui = "bold" },
		WhichKeyIcon = { fg = colors.func, bg = utils.get_bg_color(colors.bg, config) },
		WhichKeyIconAzure = { fg = colors.kw, bg = utils.get_bg_color(colors.bg, config) },
		WhichKeyIconBlue = { fg = colors.fg, bg = utils.get_bg_color(colors.bg, config) },
		WhichKeyIconCyan = { fg = colors.cursor, bg = utils.get_bg_color(colors.bg, config) },
		WhichKeyIconGreen = { fg = colors.string, bg = utils.get_bg_color(colors.bg, config) },
		WhichKeyIconGrey = { fg = colors.comment, bg = utils.get_bg_color(colors.bg, config) },
		WhichKeyIconOrange = { fg = colors.visual, bg = utils.get_bg_color(colors.bg, config) },
		WhichKeyIconPurple = { fg = colors.const, bg = utils.get_bg_color(colors.bg, config) },
		WhichKeyIconRed = { fg = colors.error, bg = utils.get_bg_color(colors.bg, config) },
		WhichKeyIconYellow = { fg = colors.warn, bg = utils.get_bg_color(colors.bg, config) },
		WhichKeyNormal = { fg = colors.fg, bg = utils.get_bg_color(colors.bg, config) },
		WhichKeySeparator = { fg = colors.comment, bg = utils.get_bg_color(colors.bg, config) },
		WhichKeyTitle = { fg = colors.kw, bg = utils.get_bg_color(colors.bg, config), gui = "bold" },
		WhichKeyValue = { fg = colors.comment, bg = utils.get_bg_color(colors.bg, config) },
	}

	utils.apply_highlights(highlight_groups, colors, config)
end

return M
