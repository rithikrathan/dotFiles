local M = {}

function M.setup(colors, config)
	local utils = require("Ephemera.theme.utils")

	if not colors.plugins.oil then
		return
	end

	-- let's get oily
	local oil_highlight_groups = {
		OilDir = { fg = colors.identifier, bg = utils.get_bg_color("NONE", config) },
		OilDirIcon = { fg = colors.func, bg = utils.get_bg_color("NONE", config) },
		OilSocket = { fg = colors.operator, bg = utils.get_bg_color("NONE", config) },
		OilLink = { fg = colors.string, bg = utils.get_bg_color("NONE", config) },
		OilLinkTarget = { fg = colors.kw, bg = utils.get_bg_color("NONE", config) },
		OilFile = { fg = colors.constant, bg = utils.get_bg_color("NONE", config) },
		OilCreate = { fg = colors.func, bg = utils.get_bg_color("NONE", config) },
		OilDelete = { fg = colors.error, bg = utils.get_bg_color("NONE", config) },
		OilMove = { fg = colors.kw, bg = utils.get_bg_color("NONE", config) },
		OilCopy = { fg = colors.string, bg = utils.get_bg_color("NONE", config) },
		OilChange = { fg = colors.changed, bg = utils.get_bg_color("NONE", config) },
		OilRestore = { fg = colors.info, bg = utils.get_bg_color("NONE", config) },
		OilPurge = { fg = colors.error, bg = utils.get_bg_color("NONE", config) },
		OilTrash = { fg = colors.warning, bg = utils.get_bg_color("NONE", config) },
		OilTrashSourcePath = { fg = colors.comment, bg = utils.get_bg_color("NONE", config) },
	}

	utils.apply_highlights(oil_highlight_groups, colors, config)
end

return M
