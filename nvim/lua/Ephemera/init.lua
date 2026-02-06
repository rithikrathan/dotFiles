-- this mostly ai genreated helper functions need a lot or refactor bro
require("Ephemera.options")              -- General vim.opt settings
require("Ephemera.lazy")                 -- Plugin manager
require("Ephemera.theme").setup()                 -- color schemes
require("Ephemera.welcome").setup()      -- Local welcomeScreen
-- require("Ephemera.theme.colors").setup() -- Local colorScheme
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


vim.schedule(function()
	print("Rathan's Config (Ephemera) Loaded.")
end)
