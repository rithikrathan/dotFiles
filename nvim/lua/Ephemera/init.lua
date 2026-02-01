require("Ephemera.options")      -- General vim.opt settings
-- require("Ephemera.remaps")       -- Global keybindings
require("Ephemera.keybinds")       -- Global keybindings
require("Ephemera.pluginConfig") -- Global pluginConfigs
require("Ephemera.theme.colors").setup() -- Local colorScheme
require("Ephemera.statusLine")   -- Local statusline
require("Ephemera.lazy")         -- Plugin manager
require("Ephemera.autoCmd")      -- Autocommands


-- Git Logic (Defined early so statusline can find it)
_G.git_branch = ""
local function update_git()
    local h = io.popen("git branch --show-current 2> /dev/null")
    if h then
        local b = h:read("*a")
        h:close()
        _G.git_branch = (b and b ~= "") and ("  " .. b:gsub("\n", "") .. " ") or ""
    end
end
