local M = {}

-- Plugin support loading
local function load_plugins(colors, config)
	local plugins = {
		"gitsigns",
		"treesitter",
		"nvimtree",
		"telescope",
		"lualine",
		"bufferline",
		"oil",
		"nvim-cmp",
		"whichkey",
		"nvim_notify",
		-- more plugins can be added here
	}

	for _, plugin in ipairs(plugins) do
		local ok, plugin_config = pcall(require, "Ephemera.theme.plugins." .. plugin)
		if ok then
			plugin_config.setup(colors, config)
		else
			print("Failed to load " .. plugin .. " configuration")
		end
	end
end

-- Apply colorscheme
function M.setup(user_config)
	-- Load the colors and config from colors.lua
	local colors_module = require("Ephemera.theme.colors")
	local colors = colors_module.config.colors
	local config = colors_module.config

	-- Merge user configuration with default (optional)
	config = vim.tbl_deep_extend("force", config, user_config or {})

	-- Load plugin configurations
	load_plugins(colors, config)
end

return M
