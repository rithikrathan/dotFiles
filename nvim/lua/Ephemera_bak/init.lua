-- this mostly ai genreated helper functions need a lot or refactor bro
require("Ephemera.options")              -- General vim.opt settings
require("Ephemera.lazy")                 -- Plugin manager
require("Ephemera.welcome").setup()      -- Local welcomeScreen
require("Ephemera.theme.colors").setup() -- Local colorScheme
require("Ephemera.statusLine")           -- Local statusline
-- require("Ephemera.remaps")       -- Global keybindings
require("Ephemera.keybinds")             -- Global keybindings
require("Ephemera.pluginConfig")         -- Global pluginConfigs
require("Ephemera.commands")              -- Autocommands and user defined commands


-- global variables 
vim.g.use_git_plugins = false
vim.g.is_transparent = false

-- some variables
_G.statusMessage = "She's catfishing you bro beware" 
-- _G.statusMessage = "@rathan"
_G.git_branch = ""

-- Git Logic (Defined early so statusline can find it)
local function update_git()
	local h = io.popen("git branch --show-current 2> /dev/null")
	if h then
		local b = h:read("*a")
		h:close()
		_G.git_branch = (b and b ~= "") and ("  " .. b:gsub("\n", "") .. " ") or ""
	end
end

vim.schedule(function()
	print("Rathan's Config (Ephemera) Loaded.")
end)
