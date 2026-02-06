local M = {}

function M.setup(colors, config)
	local utils = require("Ephemera.theme.utils")

	if not colors.plugins.nvimtree then
		return
	end

	local highlight_groups = {
		NvimTreeFolderIcon = { fg = colors.identifier, bg = utils.get_bg_color("NONE", config) },
		NvimTreeFolderName = { fg = colors.func, bg = utils.get_bg_color("NONE", config) },
		NvimTreeOpenedFolderName = { fg = colors.kw, bg = utils.get_bg_color("NONE", config) },
		NvimTreeEmptyFolderName = { fg = colors.comment, bg = utils.get_bg_color("NONE", config) },
		NvimTreeRootFolder = { fg = colors.type, bg = utils.get_bg_color("NONE", config) },
		NvimTreeSymlink = { fg = colors.string, bg = utils.get_bg_color("NONE", config) },
		NvimTreeSpecialFile = { fg = colors.operator, bg = utils.get_bg_color("NONE", config), gui = "bold" },
		NvimTreeWindowPicker = { fg = colors.bg, bg = colors.search_highlight, gui = "bold" },
		NvimTreeLineNr = { fg = colors.line_nr, bg = utils.get_bg_color("NONE", config) },
		NvimTreeCursorLineNr = { fg = colors.cursor, bg = utils.get_bg_color("NONE", config), gui = "bold" },
	}

	utils.apply_highlights(highlight_groups, colors, config)
end

return M
