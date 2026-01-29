-- =============================================================================
--  RATHAN'S VANILLA CONFIG (Ra* Edition - Fixed)
-- =============================================================================

-- 1. EDITOR OPTIONS
-- =============================================================================
vim.g.mapleader = " "

vim.opt.termguicolors = true
vim.opt.expandtab = false
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.scrolloff = 5
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.mouse = "a"
vim.opt.timeoutlen = 300
vim.opt.list = true
vim.opt.listchars = { tab = "┊ ", trail = "·", nbsp = "␣" }
vim.opt.laststatus = 3 -- Global statusline

-- 2. CUSTOM THEME & COLORS
-- =============================================================================
local istransparent = false -- Default state

local palette = {
    fg         = "#ffeeee",
    bg         = "#040409",
    bgl         = "#090909",
    cursor     = "#ffa0a0",
    line_nr    = "#ff1010",
    visual     = "#690f0f",     -- Deep saturated red
    comment    = "#696969",
    string     = "#e4b2ab",
    func       = "#ff6347",     -- Bright Orange-Red
    kw         = "#ff2222",     -- Saturated Bright Red
    identifier = "#d2d2d2",
    type       = "#ff420f",
    search     = "#ffaa00",
    operator   = "#d63e3e",
    bracket    = "#ff6969",
    preproc    = "#4b8902",
    bool       = "#ffa07a",
    constant   = "#f59064",
    -- UI Specifics
    pmenu_bg   = "#101015",     -- Slightly lighter than BG
    pmenu_sel  = "#fa3e19",
    border     = "#ff1e00",
    error      = "#ff0000",
    warning    = "#ffee00",
    hint       = "#00ffee",
    info       = "#14ff6a",
}

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

-- FUNCTION: Apply Colors (Handles EVERYTHING including Statusline)
local function apply_colors()
    vim.cmd("hi clear")
    if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end
    vim.g.colors_name = "custom_void"

    local bg_color = istransparent and "NONE" or palette.bg
    local pmenu_bg = istransparent and "NONE" or palette.pmenu_bg

    -- 1. EDITOR HIGHLIGHTS
    local groups = {
        Normal        = { fg = palette.fg, bg = bg_color },
        NormalNC      = { fg = palette.fg, bg = bg_color },
        NormalFloat   = { fg = palette.fg, bg = pmenu_bg },
        SignColumn    = { bg = bg_color },
        ColorColumn   = { bg = palette.visual },
        Cursor        = { fg = palette.bg, bg = palette.cursor },
        CursorLine    = { bg = "#121212" },
        LineNr        = { fg = palette.line_nr, bg = bg_color },
        CursorLineNr  = { fg = palette.kw, bold = true, bg = bg_color },
        Visual        = { bg = palette.visual },
        Pmenu         = { fg = palette.fg, bg = palette.pmenu_bg },
        PmenuSel      = { fg = "#ffffff", bg = palette.pmenu_sel },
        VertSplit     = { fg = palette.border },
        WinSeparator  = { fg = palette.border },
        -- Syntax
        Comment       = { fg = palette.comment, italic = true },
        String        = { fg = palette.string },
        Function      = { fg = palette.func, bold = true },
        Keyword       = { fg = palette.kw, bold = true },
        Statement     = { fg = palette.kw },
        Conditional   = { fg = palette.kw },
        Repeat        = { fg = palette.kw },
        Operator      = { fg = palette.operator },
        Type          = { fg = palette.type },
        Identifier    = { fg = palette.identifier },
        Constant      = { fg = palette.constant },
        Boolean       = { fg = palette.bool },
        PreProc       = { fg = palette.preproc },
        Special       = { fg = palette.bracket },
        -- Diagnostics
        DiagnosticError = { fg = palette.error },
        DiagnosticWarn  = { fg = palette.warning },
        DiagnosticInfo  = { fg = palette.info },
        DiagnosticHint  = { fg = palette.hint },
        -- Search
        Search        = { fg = "#000000", bg = palette.search },
        IncSearch     = { fg = "#000000", bg = palette.search },
    }

    for group, opts in pairs(groups) do
        vim.api.nvim_set_hl(0, group, opts)
    end

    -- 2. STATUSLINE HIGHLIGHTS (High Contrast & Saturated)
    -- Backgrounds
    local sl_bg = palette.bgl         -- The Void
    local sl_mid = palette.pmenu_bg  -- The Middle Step (Dark Grey)

    -- NORMAL: Bright Red Background -> Dark Text (Max Readability)
    vim.api.nvim_set_hl(0, 'ModeNorm',   { fg = palette.bg,    bg = palette.kw,italic = true,   bold = true })
    vim.api.nvim_set_hl(0, 'SepNormA',   { fg = palette.kw,    bg = sl_mid })
    vim.api.nvim_set_hl(0, 'InfoNorm',   { fg = palette.fg,    bg = sl_mid })
    vim.api.nvim_set_hl(0, 'SepNormB',   { fg = sl_mid,        bg = sl_bg })

    -- INSERT: Bright Orange Background -> Dark Text
    vim.api.nvim_set_hl(0, 'ModeIns',    { fg = palette.bg,    bg = palette.func,italic = true, bold = true })
    vim.api.nvim_set_hl(0, 'SepInsA',    { fg = palette.func,  bg = sl_mid })
    vim.api.nvim_set_hl(0, 'InfoIns',    { fg = palette.fg,  bg = sl_mid })
    vim.api.nvim_set_hl(0, 'SepInsB',    { fg = sl_mid,        bg = sl_bg })

    -- VISUAL: Deep Dark Red Background -> White Text
    vim.api.nvim_set_hl(0, 'ModeVis',    { fg = palette.bg,    bg = palette.type,italic = true, bold = true })
    vim.api.nvim_set_hl(0, 'SepVisA',    { fg = palette.type,bg = sl_mid })
    vim.api.nvim_set_hl(0, 'InfoVis',    { fg = palette.fg,bg = sl_mid })
    vim.api.nvim_set_hl(0, 'SepVisB',    { fg = sl_mid,        bg = sl_bg })

    -- BODY: Blends into void
    vim.api.nvim_set_hl(0, 'StatusBody', { fg = palette.comment, bg = sl_bg })
end


-- 3. STATUSLINE CONSTRUCTION
-- =============================================================================
function _G.MyStatusLine()
    local m = vim.fn.mode()
    local state = "Norm"
    local label = "NORMAL"

    if m == 'i' then
        state = "Ins"; label = "INSERT"
    elseif m:match("^[vV\22]") then
        state = "Vis"; label = "VISUAL"
    elseif m == 'c' then
        label = "COMMAND" 
    elseif m == 'R' then
        label = "REPLACE" 
    end

    -- Format: Thu Jan 29 10:02:45 PM
    -- %a=Day, %b=Month, %d=Date, %I=Hour(12), %M=Min, %S=Sec, %p=AM/PM
    local time = os.date("| %a %b %d %I:%M %p")

    return table.concat({
        -- LEFT: Mode -> Arrow -> Info -> Arrow
        "%#Mode" .. state .. "# " .. label .. " ",
        "%#Sep" .. state .. "A# ",
        "%#Info" .. state .. "#" .. _G.git_branch .. "%f %m%r ",
        "%#Sep" .. state .. "B# ",
        
        -- MIDDLE: Void
        "%#StatusBody#",
        "%=",
        
        " %y %l:%c %p%%  ",
        time,
        " "
    })
end

vim.opt.statusline = "%!v:lua.MyStatusLine()"


-- Init Colors & Autocommands
apply_colors()
vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_colors })
vim.api.nvim_create_autocmd({"BufEnter", "FocusGained"}, { callback = update_git })


-- 4. HELPER FUNCTIONS (Floating Windows)
-- =============================================================================
_G.create_floating_window = function()
    local width = math.floor(vim.o.columns * 0.80)
    local height = math.floor(vim.o.lines * 0.80)
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor', width = width, height = height,
        row = row, col = col, style = 'minimal', border = 'rounded',
    })
    
    vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#ff3322' })
    return buf, win
end


-- 5. KEYMAPPINGS
-- =============================================================================

-- Insert Mode Cursor Movement (Alt + hjkl)
vim.keymap.set("i", "<A-h>", "<Left>",  { desc = "Move cursor left" })
vim.keymap.set("i", "<A-l>", "<Right>", { desc = "Move cursor right" })
vim.keymap.set("i", "<A-j>", "<Down>",  { desc = "Move cursor down" })
vim.keymap.set("i", "<A-k>", "<Up>",    { desc = "Move cursor up" })
vim.keymap.set("i", "<A-o>", '<Esc>o') 
vim.keymap.set("i", "<A-O>", '<Esc>O')

-- Basic Mappings
vim.keymap.set({ "n", "v", "t", "i" }, "<A-n>", '<CR>', { remap = true })
vim.keymap.set({ "n", "v", "t", "i" }, "<F5>", ':w | nohl | make<CR>', { remap = true })
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set({ "n", "i" }, "<A-[>", "zt")
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set({"v", "i"}, "<leader><Tab>", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("t", "<leader><Tab>", "<C-\\><C-n>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>d", "yyp", { desc = "Duplicate current line" })
vim.keymap.set("i", "<leader>tn", "<C-o>", { desc = "Temporary normal mode" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "L", "g_")
vim.keymap.set("v", "<leader>dd", "y'>p")

-- Wraps
vim.keymap.set("v", "<leader>wp", ":s/\\%V.*\\%V/(&)/ | nohl<CR>")
vim.keymap.set("v", "<leader>wpp", ":s/\\%V.*\\%V/{&}/ | nohl<CR>")
vim.keymap.set("v", "<leader>wqq", ':s/\\%V.*\\%V/"&"/ | nohl<CR>')
vim.keymap.set("v", "<leader>wq", ":s/\\%V.*\\%V/'&'/ | nohl<CR>")
vim.keymap.set("v", "<leader>wb", ":s/\\%V.*\\%V/`&`/ | nohl<CR>")

-- Misc Insert helpers
vim.keymap.set("i", "<leader>fjk", "<><left>")
vim.keymap.set("n", "ct", 'vitc')
vim.keymap.set("i", "<A-=>", ' := ')
vim.keymap.set("n", "vt", 'vit')

-- Splits & Windows
vim.keymap.set("n", "<leader>h", ":split<CR>")
vim.keymap.set("n", "<leader>v", ":vsplit<CR>")
vim.keymap.set("n", "<A-h>", "<C-w><C-h>")
vim.keymap.set("n", "<A-l>", "<C-w><C-l>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>")
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>")
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>")

-- Files & Finder (Native)
vim.keymap.set("n", "<leader>nf", function()
    local netrw_dir = vim.fn.expand("%:p:h")
    local filename = vim.fn.input("New file: ")
    if filename ~= "" then
        local filepath = netrw_dir .. "/" .. filename
        vim.fn.system("touch " .. vim.fn.shellescape(filepath))
        print("Created: " .. filepath)
    else print("Canceled.") end
end)

vim.keymap.set('n', '<leader>x', function() os.execute('xdg-open ' .. vim.fn.expand('%:p:h')) end)
vim.keymap.set('n', '<leader>xx', function() 
    local app = vim.fn.input("Open with: ")
    if app ~= "" then os.execute(app .. " " .. vim.fn.shellescape(vim.fn.expand('%:p')) .. " &") end
end)

vim.opt.path:append("**")
vim.opt.wildmenu = true
vim.keymap.set("n", "<leader>pf", ":find *")
vim.keymap.set("n", "<leader>fb", ":ls<CR>:b<Space>")
vim.keymap.set("n", "<leader>ff", function()
    local path = vim.fn.input("Find file: ", "", "file")
    if path ~= "" then vim.cmd("edit " .. path) end
end)
vim.keymap.set("n", "<leader>fg", function()
    local pattern = vim.fn.input("Grep > ")
    if pattern ~= "" then vim.cmd("grep! -r " .. pattern .. " ."); vim.cmd("copen") end
end)

-- Replace Word
vim.keymap.set("n", "<leader>rw", function()
    local word = vim.fn.expand("<cword>")
    local replacement = vim.fn.input("Replace '" .. word .. "' with: ")
    if replacement ~= "" then vim.cmd("%s/\\<" .. word .. "\\>/" .. replacement .. "/gc") end
end)


-- 6. TERMINAL & MAKE COMMANDS
-- =============================================================================

-- Floating Terminal
vim.keymap.set('n', '<leader>t', function()
    local file_dir = vim.fn.expand('%:p:h')
    local buf, win = _G.create_floating_window()
    
    vim.keymap.set({ "n", "t" }, "<esc>", function() vim.api.nvim_win_close(win, true) end, { buffer = buf })
    vim.fn.termopen(vim.o.shell, { cwd = file_dir })
    vim.cmd('startinsert')
end)

-- Make Run
vim.keymap.set("n", "<leader>r", function()
    local arg = vim.fn.input("Arg: ")
    local buf, win = _G.create_floating_window()
    vim.keymap.set("t", "<esc>", function() vim.api.nvim_win_close(win, true) end, { buffer = buf })
    local job = vim.fn.termopen(vim.o.shell)
    vim.fn.chansend(job, "make run " .. arg .. "\n")
    vim.cmd("startinsert")
end)


-- 7. AUTOCOMMANDS & EXTRAS
-- =============================================================================

-- Transparency Toggle
vim.api.nvim_create_user_command("ToggleTransparency", function()
    istransparent = not istransparent
    apply_colors() -- This now correctly re-applies statusline colors too
    print("Transparency: " .. (istransparent and "ON" or "OFF"))
end, {})

-- Auto-Pairs
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        local function map_pair(c, p) vim.keymap.set('i', c, c .. p .. '<Left>', { buffer = true }) end
        map_pair('(', ')'); map_pair('[', ']'); map_pair('{', '}'); map_pair('"', '"'); map_pair("'", "'")
    end
})

-- Boolean Toggler (<leader>i)
vim.keymap.set("n", "<leader>i", function()
    local word = vim.fn.expand("<cword>")
    local opposites = {
        ["true"] = "false", ["false"] = "true",
        ["True"] = "False", ["False"] = "True",
        ["on"] = "off", ["off"] = "on",
        ["HIGH"] = "LOW", ["LOW"] = "HIGH",
        ["+"] = "-", ["-"] = "+"
    }
    if opposites[word] then vim.cmd("normal! ciw" .. opposites[word]) end
end)

-- Netrw Tweaks
vim.g.netrw_keepdir = 0
vim.g.netrw_winsize = 25
vim.g.netrw_banner = 1
vim.g.netrw_localcopydircmd = 'cp -r'

vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
        vim.keymap.set("n", "<leader>d", function()
            local dir = vim.b.netrw_curdir
            local target = vim.fn.expand("<cfile>")
            if target ~= "" then
                vim.fn.system({ "cp", "-r", dir .. "/" .. target, dir .. "/" .. target .. ".bak" })
                vim.cmd("edit " .. vim.fn.fnameescape(dir))
                print("Backup created.")
            end
        end, { buffer = true, remap = false })

        vim.keymap.set('n', '<C-P>', function()
            local path = vim.fn.fnamemodify(vim.b.netrw_curdir .. "/" .. vim.fn.expand('<cfile>'), ':.')
            print(path)
            vim.fn.setreg('+', path)
        end, { buffer = true })
    end
})

print("Rathan's Vannila Config (Ra* Edition - Fixed) Loaded.")
