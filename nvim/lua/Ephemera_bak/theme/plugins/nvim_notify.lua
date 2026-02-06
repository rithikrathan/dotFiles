local M = {}

function M.setup(colors, config)
	local utils = require("Ephemera.theme.utils")

	if not colors.plugins.nvim_notify then
		return
	end

	local highlight_groups = {
		NotifyERRORBorder = { fg = colors.error, bg = utils.get_bg_color("NONE", config) },
		NotifyWARNBorder = { fg = colors.warn, bg = utils.get_bg_color("NONE", config) },
		NotifyINFOBorder = { fg = colors.info, bg = utils.get_bg_color("NONE", config) },
		NotifyDEBUGBorder = { fg = colors.info, bg = utils.get_bg_color("NONE", config) },
		NotifyTRACEBorder = { fg = colors.info, bg = utils.get_bg_color("NONE", config) },

		NotifyERRORIcon = { fg = colors.error, bg = utils.get_bg_color("NONE", config) },
		NotifyWARNIcon = { fg = colors.warn, bg = utils.get_bg_color("NONE", config) },
		NotifyINFOIcon = { fg = colors.info, bg = utils.get_bg_color("NONE", config) },
		NotifyDEBUGIcon = { fg = colors.info, bg = utils.get_bg_color("NONE", config) },
		NotifyTRACEIcon = { fg = colors.info, bg = utils.get_bg_color("NONE", config) },

		NotifyERRORTitle = { fg = colors.error, bg = utils.get_bg_color("NONE", config) },
		NotifyWARNTitle = { fg = colors.warn, bg = utils.get_bg_color("NONE", config) },
		NotifyINFOTitle = { fg = colors.info, bg = utils.get_bg_color("NONE", config) },
		NotifyDEBUGTitle = { fg = colors.info, bg = utils.get_bg_color("NONE", config) },
		NotifyTRACETitle = { fg = colors.info, bg = utils.get_bg_color("NONE", config) },
	}

	utils.apply_highlights(highlight_groups, colors, config)
end

return M
