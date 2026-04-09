-- so adding this speeds up loading time??? ig
if vim.loader then
	vim.loader.enable()
end

require("Ephemera.options")                               -- General vim.opt settings
require("Ephemera.lazy")                                  -- Plugin manager
require("Ephemera.keybinds")                              -- Global keybindings
local current_theme = require("Ephemera.themes.current")
require("Ephemera.themes." .. current_theme.name).setup() -- color schemes set your theme here
require("Ephemera.custom.welcome").setup()                -- Local welcomeScreen
require("Ephemera.statusLine")                            -- Local statusline
require("Ephemera.pluginConfig")                          -- Global pluginConfigs
require("Ephemera.commands")                              -- Autocommands and user defined commands
require("Ephemera.custom.scratchpad").setup()             -- Scratchpad setup
require("Ephemera.custom.notepad").setup()                -- Notepad setup
require("Ephemera.custom.man").setup()                    -- manual lookup buffer setup

-- global variables
vim.g.use_git_plugins = false
vim.g.is_transparent = false

-- some variables
_G.statusMessage = "@rathan"
-- _G.statusMessage = "She's catfishing you bro beware"

--godot stuffs
--
-- [ [  --server ./godothost --remote-send "<C-\><C-N>:e {file}<CR>:call cursor({line}, {col})<CR>" ] ]
--
-- Automatically start Godot server if we are in a Godot project
if vim.fn.filereadable(vim.fn.getcwd() .. '/project.godot') == 1 then
	local server_name = './godothost'

	-- Only start it if it isn't already running
	local is_running = false
	for _, name in ipairs(vim.fn.serverlist()) do
		if name == server_name then
			is_running = true
			break
		end
	end

	if not is_running then
		vim.fn.serverstart(server_name)
	end
end


_G.create_floating_window = function()
	local stats = vim.api.nvim_list_uis()[1]

	-- 1. Define Size (Large, but leaves room)
	local width = math.floor(stats.width * 0.8)
	local height = math.floor(stats.height * 0.8) -- 70% of screen height

	-- 2. Define the Gap
	-- Increase this number to move the window HIGHER up away from the status line
	local gap_from_bottom = 5

	-- 3. Calculate Position
	local col = math.floor((stats.width - width) / 2)
	local row = stats.height - height - gap_from_bottom

	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = 'editor',
		width = width,
		height = height,
		row = row,
		col = col,
		style = 'minimal',
		border = 'rounded'
	})

	return buf, win
end

vim.schedule(function()
	print("Rathan's Config (Ephemera) Loaded.")
end)
