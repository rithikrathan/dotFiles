-- so adding this speeds up loading time??? ig
if vim.loader then
	vim.loader.enable()
end

require("Ephemera.options")         -- General vim.opt settings
require("Ephemera.lazy")            -- Plugin manager
require("Ephemera.theme").setup()   -- color schemes
require("Ephemera.welcome").setup() -- Local welcomeScreen
require("Ephemera.statusLine")      -- Local statusline
require("Ephemera.keybinds")        -- Global keybindings
require("Ephemera.pluginConfig")    -- Global pluginConfigs
require("Ephemera.commands")        -- Autocommands and user defined commands


--Godot stuffs
local pipepath = vim.fn.stdpath("cache") .. "/server.pipe"
if not vim.loop.fs_stat(pipepath) then
	vim.fn.serverstart(pipepath)
end

-- global variables
vim.g.use_git_plugins = false
vim.g.is_transparent = false

-- some variables
-- _G.statusMessage = "She's catfishing you bro beware"
_G.statusMessage = "@rathan"


vim.schedule(function()
	print("Rathan's Config (Ephemera) Loaded.")
end)
