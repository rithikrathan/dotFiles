local M = {}

-- Apply highlight groups consistently across all plugins
function M.apply_highlights(highlight_groups, colors, config)
	for group_name, hl_config in pairs(highlight_groups) do
		local cmd = "highlight " .. group_name

		if hl_config.fg then
			cmd = cmd .. " guifg=" .. hl_config.fg
		end
		if hl_config.bg then
			cmd = cmd .. " guibg=" .. hl_config.bg
		end
		if hl_config.sp then
			cmd = cmd .. " guisp=" .. hl_config.sp
		end

		-- Handle GUI attributes
		local gui_attrs = {}
		if hl_config.gui then table.insert(gui_attrs, hl_config.gui) end
		if hl_config.bold then table.insert(gui_attrs, "bold") end
		if hl_config.italic then table.insert(gui_attrs, "italic") end
		if hl_config.underline then table.insert(gui_attrs, "underline") end
		if hl_config.strikethrough then table.insert(gui_attrs, "strikethrough") end

		if #gui_attrs > 0 then
			cmd = cmd .. " gui=" .. table.concat(gui_attrs, ",")
		end

		pcall(vim.cmd, cmd)
	end
end

-- Get background color based on transparency setting
function M.get_bg_color(base_bg, config)
	return config.transparent and "NONE" or base_bg
end

return M