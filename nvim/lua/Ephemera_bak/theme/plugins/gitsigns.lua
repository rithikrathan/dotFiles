local M = {}

function M.setup(colors, config)
	local utils = require("Ephemera.theme.utils")

	if not colors.plugins.gitsigns then
		return
	end

	local highlight_groups = {
		GitSignsAdd = { fg = colors.added, bg = utils.get_bg_color("NONE", config) },
		GitSignsChange = { fg = colors.changed, bg = utils.get_bg_color("NONE", config) },
		GitSignsDelete = { fg = colors.removed, bg = utils.get_bg_color("NONE", config) },
	}

	utils.apply_highlights(highlight_groups, colors, config)
end

return M
