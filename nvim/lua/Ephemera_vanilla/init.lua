-- =============================================================================
--  EPHEMERA: Single File Vanilla Config
--  Combined: Options, Keybinds, AutoCmds, Colorscheme, Statusline
-- =============================================================================

-- Global Settings
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- =============================================================================
--  1. OPTIONS
-- =============================================================================
vim.opt.mouse = "a"
vim.opt.timeoutlen = 273

-- Netrw Settings
vim.g.netrw_winsize = 25
vim.g.netrw_banner = 1
vim.g.netrw_localcopydircmd = 'cp -r'
vim.g.netrw_keepdir = true

-- Editor UI
vim.opt.signcolumn = "yes"
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.scrolloff = 5
vim.opt.cursorline = true
vim.g.have_nerd_font = false
vim.opt.undofile = true
vim.opt.termguicolors = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "┊ ", trail = ".", nbsp = "␣" }

-- Indentation
vim.opt.expandtab = false
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Search & Update
vim.opt.updatetime = 400
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.autoread = true

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "1"
vim.opt.fillchars = {
    foldopen = "▾",
    foldclose = "▸",
    foldsep = "┊",
    fold = " "
}

function _G.foldText()
    local fs, fe = vim.v.foldstart, vim.v.foldend
    local line = vim.fn.getline(fs)
    local line_count = fe - fs + 1
    local total_lines = vim.api.nvim_buf_line_count(0)
    local percentage = math.floor((line_count / total_lines) * 100)
    return string.format("╰┈➤  %s ... %d lines (%d%%)", line, line_count, percentage)
end
vim.opt.foldtext = "v:lua.foldText()"

-- Helper for floating windows
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

-- Diagnostic Signs
vim.fn.sign_define("DiagnosticSignError", { text = "❖", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "⚑", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignHint", { text = "✯", texthl = "DiagnosticSignHint" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "⧐", texthl = "DiagnosticSignInfo" })

-- =============================================================================
--  2. KEYBINDS
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

-- =============================================================================
--  3. AUTOCOMMANDS
-- =============================================================================
-- SystemVerilog / Verilog
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.sv" },
    command = "set filetype=systemverilog",
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.v" },
    command = "set filetype=verilog",
})

-- Processing (Python & Java)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.pyde",
    callback = function() vim.bo.filetype = "python" end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.pde",
    callback = function() vim.bo.filetype = "processing" end,
})

-- Highlight on Yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank { higroup = "IncSearch", timeout = 120 }
    end,
})

-- Netrw Tweaks
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

-- =============================================================================
--  4. COLORSCHEME (Vanilla-Filtered)
-- =============================================================================
local Theme = {}

Theme.config = {
    transparent = true,
    glow = true,
    colors = {
        fg = "#ffeeee", bg = "#04040d", cursor = "#ffa0a0", cursorLine = "#121212",
        glow_color = "#ffeeee", line_nr = "#ff1010", visual = "#690f0f",
        comment = "#696969", string = "#e4b2ab", func = "#ff6347", kw = "#ff2828",
        identifier = "#d2d2d2", type = "#ff420f", type_builtin = "#ff420f",
        search_highlight = "#ffaa00", operator = "#d63e3e", bracket = "#ff6969",
        preprocessor = "#4b8902", bool = "#ffa07a", constant = "#f59064",
        added = "#baffc9", changed = "#ffffba", removed = "#ffb3ba",
        pmenu_bg = "#17171d", pmenu_sel_bg = "#fa3e19", pmenu_fg = "#fc6142",
        bgl = "#090909", eob = "#3c3c3c", border = "#ff1e00", title = "#ff1e00",
        bufferline_selection = "#fd1b1b", error = "#ff0000", warning = "#ffee00",
        hint = "#00ffee", info = "#14ff6a",
    },
}

Theme.setup = function()
    local colors = Theme.config.colors
    local bg_color = Theme.config.transparent and "NONE" or colors.bg
    local float_bg = Theme.config.transparent and "NONE" or colors.pmenu_bg

    local highlight_groups = {
        Normal = { fg = colors.fg, bg = bg_color },
        Cursor = { fg = colors.cursor, bg = bg_color },
        CursorLine = { bg = colors.cursorLine },
        LineNr = { fg = colors.line_nr },
        Visual = { bg = colors.visual },
        Comment = { fg = colors.comment, italic = true, bold = true },
        String = { fg = colors.string },
        Function = { fg = colors.func },
        Keyword = { fg = colors.kw },
        Identifier = { fg = colors.identifier },
        Type = { fg = colors.type },
        PreProc = { fg = colors.preprocessor },
        Boolean = { fg = colors.bool },
        Constant = { fg = colors.constant },
        
        -- Standard Search (from bottom of colors.lua)
        Search = { bg = "#5631a6", fg = "#ffffff", bold = true },
        CurSearch = { bg = "#ff5555", fg = "#090909", bold = true },
        IncSearch = { bg = "#ff3e0b", fg = "#440000", bold = true },
        
        Operator = { fg = colors.operator },
        Delimiter = { fg = colors.bracket },
        Pmenu = { fg = colors.pmenu_fg, bg = colors.pmenu_bg },
        PmenuSel = { fg = colors.pmenu_bg, bg = colors.pmenu_sel_bg, bold = true },
        NormalFloat = { fg = colors.fg, bg = float_bg },
        FloatBorder = { fg = colors.border, bg = float_bg },
        
        -- Statusline Groups
        ModeNorm = { fg = colors.bg, bg = colors.kw, italic = true, bold = true },
        SepNormA = { fg = colors.kw, bg = colors.pmenu_bg },
        InfoNorm = { fg = colors.fg, bg = colors.pmenu_bg },
        SepNormB = { fg = colors.pmenu_bg, bg = colors.bgl },
        ModeIns = { fg = colors.bg, bg = colors.func, italic = true, bold = true },
        SepInsA = { fg = colors.func, bg = colors.pmenu_bg },
        InfoIns = { fg = colors.fg, bg = colors.pmenu_bg },
        SepInsB = { fg = colors.pmenu_bg, bg = colors.bgl },
        ModeVis = { fg = colors.bg, bg = colors.type, italic = true, bold = true },
        SepVisA = { fg = colors.type, bg = colors.pmenu_bg },
        InfoVis = { fg = colors.fg, bg = colors.pmenu_bg },
        SepVisB = { fg = colors.pmenu_bg, bg = colors.bgl },
        StatusBody = { fg = colors.comment, bg = colors.bgl },
        SlRef = { fg = colors.comment, bg = colors.bgl , bold = true, italic = true },
        
        -- Extra Custom Highlights
        Folded = { fg = "#eb7659", bg = Theme.config.transparent and "NONE" or "#201010", bold = true, italic = true },
        FoldColumn = { fg = colors.kw, bg = colors.bgl },
        LineNrFold = { fg = colors.kw, bg = colors.bgl },
        EndOfBuffer = { fg = colors.eob, bg = bg_color },

        -- Diagnostics
        DiagnosticError = { fg = colors.error },
        DiagnosticWarn = { fg = colors.warning },
        DiagnosticHint = { fg = colors.hint },
        DiagnosticInfo = { fg = colors.info },
        DiagnosticUnderlineError = { gui = "underline", sp = colors.error },
        DiagnosticUnderlineWarn = { gui = "underline", sp = colors.warning },
        DiagnosticUnderlineHint = { gui = "underline", sp = colors.hint },
        DiagnosticUnderlineInfo = { gui = "underline", sp = colors.info },
    }

    local function apply_highlight(group_name, config)
        local cmd = "highlight " .. group_name
        if config.fg then cmd = cmd .. " guifg=" .. config.fg end
        if config.bg then cmd = cmd .. " guibg=" .. config.bg end
        if config.sp then cmd = cmd .. " guisp=" .. config.sp end
        local gui_attrs = {}
        if config.bold then table.insert(gui_attrs, "bold") end
        if config.italic then table.insert(gui_attrs, "italic") end
        if config.underline then table.insert(gui_attrs, "underline") end
        if #gui_attrs > 0 then cmd = cmd .. " gui=" .. table.concat(gui_attrs, ",") end
        
        if Theme.config.glow and (
            group_name == "Function" or group_name == "Keyword" 
            or group_name == "Identifier" or group_name == "Operator"
        ) then
            cmd = cmd .. " gui=bold guisp=" .. colors.glow_color
        end
        vim.cmd(cmd)
    end

    for group, conf in pairs(highlight_groups) do apply_highlight(group, conf) end
end

-- Initialize Theme
Theme.setup()
vim.api.nvim_create_user_command("ToggleTransparency", function()
    Theme.config.transparent = not Theme.config.transparent
    Theme.setup()
    print("Transparency: " .. (Theme.config.transparent and "ON" or "OFF"))
end, {})

-- =============================================================================
--  5. STATUSLINE
-- =============================================================================
_G.git_branch = ""
local function update_git()
    local h = io.popen("git branch --show-current 2> /dev/null")
    if h then
        local b = h:read("*a")
        h:close()
        _G.git_branch = (b and b ~= "") and ("  " .. b:gsub("\n", "") .. " ") or ""
    end
end
vim.api.nvim_create_autocmd({"BufEnter", "DirChanged"}, { callback = update_git })

local frames_set = { " ₍^. .^₎⟆ ", " ₍^. .^₎  ", " ⟅₍^. .^₎ ", " ₍^. .^₎  " }
local static_texts = { "꧁  ✧ 🌹✧ ꧂", " ꧁  ⎝𓆩༺  ✧ ༻  𓆪⎠꧂  ", " ˗ˏˋ 💤 ˎˊ˗ ", "────୨ৎ────", " ─── ★ ─── ", "  ( ˘ ³˘)♥ ", "· · ─ ·𖥸· ─ · ·", "ﮩ٨ـﮩﮩ٨ـ 🌹 ﮩ٨ـﮩﮩﮩ٨ـ" }

_G.AnimState = {
    output = static_texts[1],
    idx = 1,
    timer = vim.loop.new_timer(),
    interval = 200,
    augroup = vim.api.nvim_create_augroup("StatusAnimGroup", { clear = true }),
}

local function advance_frame()
    _G.AnimState.idx = (_G.AnimState.idx % #frames_set) + 1
    _G.AnimState.output = frames_set[_G.AnimState.idx]
    vim.cmd("redrawstatus")
end

function _G.SetAnimMode(input_str)
    local split_data = vim.split(input_str or "", " ", { trimempty = true })
    local mode = split_data[1] or "static"
    local arg = tonumber(split_data[2])
    local state = _G.AnimState

    state.timer:stop()
    vim.api.nvim_clear_autocmds({ group = state.augroup })

    if mode == "time" then
        state.interval = arg or 200
        state.timer:start(0, state.interval, vim.schedule_wrap(function() advance_frame() end))
        print("Animation Mode: TIME (".. state.interval .."ms)")
    elseif mode == "input" then
        state.output = frames_set[1]
        vim.cmd("redrawstatus")
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertCharPre" }, {
            group = state.augroup, callback = advance_frame,
        })
        print("Animation Mode: INPUT")
    elseif mode == "static" then
        local text_idx = (arg and static_texts[arg]) and arg or 1
        state.output = static_texts[text_idx]
        vim.cmd("redrawstatus")
        print("Animation Mode: STATIC (Index: " .. text_idx .. ")")
    end
end

_G.SetAnimMode("static 1")

vim.api.nvim_create_user_command("SlAnimMode", function(opts)
    _G.SetAnimMode(opts.args)
end, { nargs = 1, complete = function() return { "time", "input", "static" } end })

function _G.MyStatusLine()
    local width = vim.api.nvim_win_get_width(0)
    local show_right = width >= 70
    local show_full = width >= 90 
    local m = vim.fn.mode()
    local state = "Norm"
    local label = "NORMAL"

    if m == 'i' then state = "Ins"; label = "INSERT"
    elseif m:match("^[vV\22]") then state = "Vis"; label = "VISUAL"
    elseif m == 'c' then label = "COMMAND"
    elseif m == 'R' then label = "REPLACE"
    elseif m == 't' then label = "TERMINAL" end

    local has_branch = _G.git_branch and _G.git_branch ~= ""
    local branch = has_branch and _G.git_branch or ""
    local mod = vim.bo.modified and " 𔒝 " or ""
    local time = os.date("| %a %b %d %I:%M %p")

    local left_core_list = {
        "%#Mode" .. state .. "# " .. label .. " ",
        "%#Sep" .. state .. "A# ",
    }
    
    local info_content = has_branch and (branch .. " ┆ %t") or " %t"
    table.insert(left_core_list, "%#Info" .. state .. "#" .. info_content .. mod .. "%r ")
    table.insert(left_core_list, "%#Sep" .. state .. "B# ")
    table.insert(left_core_list, "%#StatusBody#")

    local left_core = table.concat(left_core_list)
    local left_extra = "%#SlRef# hello idiots! "
    local middle_part = "" .. _G.AnimState.output .. ""
    local right_part = table.concat({ "%#StatusBody#", " %y %l:%c %p%%  ", time, " " })

    if not show_right then return left_core end
    if not show_full then return left_core .. "%=" .. right_part end
    return left_core .. left_extra .. "%=" .. middle_part .. "%=" .. right_part
end

vim.opt.statusline = "%!v:lua.MyStatusLine()"

vim.schedule(function()
    print("Rathan's Vannila Config (Ephemera_vanilla) Loaded.")
end)
