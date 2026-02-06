local M = {}
local utils = require("Ephemera.theme.utils")

function M.setup(colors, config)
	local enabled = colors.plugins.bufferline

	if not enabled then
		return
	end

	local highlight_groups = {
		BufferLineFill = { bg = utils.get_bg_color("NONE", config), fg = colors.fg },
		BufferLineBackground = { bg = utils.get_bg_color("NONE", config), fg = colors.fg },
		BufferLineBufferVisible = { bg = utils.get_bg_color("NONE", config), fg = colors.fg },
		BufferLineBufferSelected = { bg = utils.get_bg_color("NONE", config), fg = colors.bufferline_selection, bold = true },
		BufferLineTab = { bg = utils.get_bg_color("NONE", config), fg = colors.fg },
		BufferLineTabSelected = { bg = utils.get_bg_color("NONE", config), fg = colors.bg },
		BufferLineTabClose = { bg = utils.get_bg_color("NONE", config), fg = colors.fg },
		BufferLineSeparator = { bg = utils.get_bg_color("NONE", config), fg = colors.line_nr },
		BufferLineSeparatorSelected = { bg = colors.bg, fg = colors.bufferline_selection },
		BufferLineIndicatorSelected = { bg = colors.bg, fg = colors.bufferline_selection },
		BufferLineModified = { fg = colors.warning },
		BufferLineModifiedSelected = { fg = colors.warning, bold = true },
	}

	utils.apply_highlights(highlight_groups, colors, config)
end

return M
