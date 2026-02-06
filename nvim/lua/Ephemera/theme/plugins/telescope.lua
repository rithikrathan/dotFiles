local M = {}

function M.setup(colors)
	local enabled = require("Ephemera.theme.colors").config.colors.plugins.telescope

	if not enabled then
		return
	end

	-- Define Telescope highlight groups
	local telescope_highlight_groups = {
		TelescopeNormal = { fg = colors.kw, bg = "NONE" },
		TelescopeBorder = { fg = colors.comment, bg = "NONE" },
		TelescopePromptNormal = { fg = colors.pmenu_fg, bg = "NONE" },
		TelescopePromptBorder = { fg = colors.border, bg = "NONE" },
		TelescopePromptTitle = { fg = colors.fg, bg = "NONE", gui = "bold" },
		TelescopePromptCounter = { fg = colors.cursor, bg = "NONE" },
		TelescopeSelectionCaret = { fg = colors.operator, bg = colors.visual },
		TelescopeSelection = { fg = colors.bool, bg = colors.visual, gui = "bold" },
		TelescopeMatching = { fg = colors.operator, bg = "NONE", gui = "bold" },
	}

	-- Apply Telescope highlight groups
	for group_name, config in pairs(telescope_highlight_groups) do
		local cmd = "highlight " .. group_name
		if config.fg then
			cmd = cmd .. " guifg=" .. config.fg
		end
		if config.bg then
			cmd = cmd .. " guibg=" .. config.bg
		end
		if config.gui then
			cmd = cmd .. " gui=" .. config.gui
		end
		vim.cmd(cmd)
	end
end

return M
