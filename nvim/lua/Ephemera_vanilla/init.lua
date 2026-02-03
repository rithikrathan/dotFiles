-- =============================================================================
--  EPHEMERA VANILLA: 
-- =============================================================================

-- Global Mapleader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- =============================================================================
--  1. OPTIONS & GLOBALS
-- =============================================================================
vim.g.have_nerd_font = true
vim.opt.mouse = "a"
vim.opt.timeoutlen = 273
vim.opt.laststatus = 3 

-- Netrw Setup
vim.g.netrw_winsize = 25
vim.g.netrw_banner = 1
vim.g.netrw_localcopydircmd = 'cp -r'
vim.g.netrw_keepdir = true 
vim.opt.expandtab = false
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.scrolloff = 5
vim.opt.cursorline = true
vim.opt.undofile = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.updatetime = 400
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.autoread = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "┊ ", trail = ".", nbsp = "␣" }
vim.opt.path:append("**") 

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "1"
vim.opt.fillchars = { foldopen = "▾", foldclose = "▸", foldsep = "┊", fold = " " }

function _G.foldText()
    local fs, fe = vim.v.foldstart, vim.v.foldend
    local line = vim.fn.getline(fs)
    local line_count = fe - fs + 1
    local total_lines = vim.api.nvim_buf_line_count(0)
    local percentage = math.floor((line_count / total_lines) * 100)
    return string.format("╰┈➤  %s ... %d lines (%d%%)", line, line_count, percentage)
end
vim.opt.foldtext = "v:lua.foldText()"

-- Helper: Create Floating Window
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

-- Diagnostics Signs
vim.fn.sign_define("DiagnosticSignError", { text = "❖", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "⚑", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignHint", { text = "✯", texthl = "DiagnosticSignHint" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "⧐", texthl = "DiagnosticSignInfo" })

-- =============================================================================
--  2. KEYBINDS
-- =============================================================================
vim.keymap.set("i", "<A-h>", "<Left>",  { desc = "Move cursor left" })
vim.keymap.set("i", "<A-l>", "<Right>", { desc = "Move cursor right" })
vim.keymap.set("i", "<A-j>", "<Down>",  { desc = "Move cursor down" })
vim.keymap.set("i", "<A-k>", "<Up>",    { desc = "Move cursor up" })
vim.keymap.set("i", "<A-o>", '<Esc>o') 
vim.keymap.set("i", "<A-O>", '<Esc>O')

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

-- Native Helpers
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
vim.keymap.set("n", "<leader>rw", function()
    local word = vim.fn.expand("<cword>")
    local replacement = vim.fn.input("Replace '" .. word .. "' with: ")
    if replacement ~= "" then vim.cmd("%s/\\<" .. word .. "\\>/" .. replacement .. "/gc") end
end)
vim.keymap.set('n', '<leader>t', function()
    local file_dir = vim.fn.expand('%:p:h')
    local buf, win = _G.create_floating_window()
    vim.keymap.set({ "n", "t" }, "<esc>", function() vim.api.nvim_win_close(win, true) end, { buffer = buf })
    vim.fn.termopen(vim.o.shell, { cwd = file_dir })
    vim.cmd('startinsert')
end)
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
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = { "*.sv" }, command = "set filetype=systemverilog" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = { "*.v" }, command = "set filetype=verilog" })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, { pattern = "*.pyde", callback = function() vim.bo.filetype = "python" end })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, { pattern = "*.pde", callback = function() vim.bo.filetype = "processing" end })
vim.api.nvim_create_autocmd("TextYankPost", { callback = function() vim.highlight.on_yank { higroup = "IncSearch", timeout = 120 } end })

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
--  4. THEME & COLORS (EXACT EPHEMERA)
-- =============================================================================
local theme_config = {
    transparent = true,
    glow = true,
    colors = {
        fg = "#ffeeee", bg = "#04040d", cursor = "#ffa0a0", cursorLine = "#121212",
        glow_color = "#ffeeee", line_nr = "#ff1010", visual = "#690f0f", comment = "#696969",
        string = "#e4b2ab", func = "#ff6347", kw = "#ff2828", identifier = "#d2d2d2",
        type = "#ff420f", type_builtin = "#ff420f", search_highlight = "#ffaa00",
        operator = "#d63e3e", bracket = "#ff6969", preprocessor = "#4b8902",
        bool = "#ffa07a", constant = "#f59064", added = "#baffc9", changed = "#ffffba",
        removed = "#ffb3ba", pmenu_bg = "#17171d", pmenu_sel_bg = "#fa3e19", pmenu_fg = "#fc6142",
        bgl = "#090909", eob = "#3c3c3c", border = "#ff1e00", title = "#ff1e00",
        bufferline_selection = "#fd1b1b", error = "#ff0000", warning = "#ffee00", hint = "#00ffee", info = "#14ff6a",
    },
}

local function setup_colors()
    local colors = theme_config.colors
    local bg_color = theme_config.transparent and "NONE" or colors.bg
    local float_bg = theme_config.transparent and "NONE" or colors.pmenu_bg

    local highlight_groups = {
        Normal = { fg = colors.fg, bg = bg_color },
        Cursor = { fg = colors.cursor, bg = bg_color },
        CursorLine = { bg = colors.cursorLine },
        LineNr = { fg = colors.line_nr },
        Visual = { bg = colors.visual },
		MsgArea = { fg = colors.constant, bg = bg_color, italic = true, bold = true },
		ModeMsg = { fg = colors.constant, bold = true },

        -- Comments (Bold & Italic)
        Comment = { fg = colors.comment, italic = true, bold = true },
        
        String = { fg = colors.string },
        Function = { fg = colors.func },
        Keyword = { fg = colors.kw },
        Identifier = { fg = colors.identifier },
        Type = { fg = colors.type },
        PreProc = { fg = colors.preprocessor },
        Boolean = { fg = colors.bool },
        Constant = { fg = colors.constant },

        -- Search Highlighting (Crucial fixes here)
        Search = { bg = "#5631a6", fg = "#ffffff", bold = true },
        CurSearch = { bg = "#ff5555", fg = "#090909", bold = true },
        IncSearch = { bg = "#ff3e0b", fg = "#440000", bold = true },

        Operator = { fg = colors.operator },
        Delimiter = { fg = colors.bracket },

        -- POPUP MENUS
        Pmenu = { fg = colors.pmenu_fg, bg = colors.pmenu_bg },
        PmenuSel = { fg = colors.pmenu_bg, bg = colors.pmenu_sel_bg, bold = true },
        NormalFloat = { fg = colors.fg, bg = float_bg },
        FloatBorder = { fg = colors.border, bg = float_bg },

        -- STATUSLINE HIGHLIGHTS 
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

        -- WELCOME SCREEN
        WelcomeRose =  { fg = "#ff5555", bold = true },
        WelcomeStem =  { fg = "#50fa7b", bold = true },
        WelcomeQuote = { fg = "#a1a1a1", italic = true },
        
        -- Treesitter
        ["@function"] = { fg = colors.func },
        ["@keyword"] = { fg = colors.kw },
        ["@identifier"] = { fg = colors.identifier },
        ["@operator"] = { fg = colors.operator },

        -- EndOfBuffer
        EndOfBuffer = { fg = colors.bg, bg = bg_color }, -- Defaults to invisible if no show_eob flag

        -- Custom Highlights
        Folded = { fg = "#eb7659", bg = theme_config.transparent and "NONE" or "#201010", bold = true, italic = true },
        FoldColumn = { fg = colors.kw, bg = colors.bgl },
        LineNrFold = { fg = colors.kw, bg = colors.bgl },

        -- Flash.nvim & MultiCursor
        FlashLabel = { bg = "#FF9E64", fg = "#000000", bold = true },
        MultipleCursorsCursor = { bg = "#00FFFF", fg = "#000000" },
        MultipleCursorsVisual = { bg = "#b294bb", fg = "#000000" },

        CmpBorder = { fg = "#ff5555" },

        -- LSP Diagnostics
        DiagnosticError = { fg = colors.error },
        DiagnosticWarn = { fg = colors.warning },
        DiagnosticHint = { fg = colors.hint },
        DiagnosticInfo = { fg = colors.info },
        DiagnosticVirtualTextError = { fg = colors.error },
        DiagnosticVirtualTextWarn = { fg = colors.warning },
        DiagnosticVirtualTextHint = { fg = colors.hint },
        DiagnosticVirtualTextInfo = { fg = colors.info },
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
        if config.gui then table.insert(gui_attrs, config.gui) end
        if config.bold then table.insert(gui_attrs, "bold") end
        if config.italic then table.insert(gui_attrs, "italic") end
        if config.underline then table.insert(gui_attrs, "underline") end
        if #gui_attrs > 0 then cmd = cmd .. " gui=" .. table.concat(gui_attrs, ",") end

        -- Glow Logic (restored)
        if theme_config.glow and (
                group_name == "Function" or group_name == "Keyword" 
                or group_name == "Identifier" or group_name == "Operator"
                or group_name == "@function" or group_name == "@keyword"
                or group_name == "@identifier" or group_name == "@operator"
            ) then
            cmd = cmd .. " gui=bold guisp=" .. colors.glow_color
        end

        vim.cmd(cmd)
    end

    for group_name, conf in pairs(highlight_groups) do apply_highlight(group_name, conf) end
end
setup_colors()

-- =============================================================================
--  5. STATUSLINE
-- =============================================================================
_G.git_branch = ""
local function update_git()
    vim.system({ "git", "branch", "--show-current" }, { text = true }, function(out)
        vim.schedule(function()
            if out.code == 0 then
                local b = vim.trim(out.stdout)
                _G.git_branch = (b ~= "") and ("  " .. b .. " ") or ""
            else
                _G.git_branch = ""
            end
            vim.cmd("redrawstatus")
        end)
    end)
end
vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, { callback = update_git })

local frames_set = { " ₍^. .^₎⟆ ", " ₍^. .^₎  ", " ⟅₍^. .^₎ ", " ₍^. .^₎  " }
local static_texts = { "꧁  ✧ 🌹✧ ꧂", " ꧁  ⎝𓆩༺  ✧ ༻  𓆪⎠꧂  ", " ˗ˏˋ 💤 ˎˊ˗ ", "────୨ৎ────", " ─── ★ ─── ", "  ( ˘ ³˘)♥ ", "· · ─ ·𖥸· ─ · ·", "ﮩ٨ـﮩﮩ٨ـ 🌹 ﮩ٨ـﮩﮩﮩ٨ـ" }

_G.AnimState = { output = static_texts[1], idx = 1, timer = vim.loop.new_timer(), interval = 200, augroup = vim.api.nvim_create_augroup("StatusAnimGroup", { clear = true }) }

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
        state.timer:start(0, state.interval, vim.schedule_wrap(advance_frame))
    elseif mode == "input" then
        state.output = frames_set[1]
        vim.cmd("redrawstatus")
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertCharPre" }, { group = state.augroup, callback = advance_frame })
    elseif mode == "static" then
        local text_idx = (arg and static_texts[arg]) and arg or 1
        state.output = static_texts[text_idx]
        vim.cmd("redrawstatus")
    end
end
_G.SetAnimMode("static 1")
vim.api.nvim_create_user_command("SlAnimMode", function(opts) _G.SetAnimMode(opts.args) end, { nargs = 1 })

function _G.MyStatusLine()
	local width = vim.o.columns
    -- local width = vim.api.nvim_win_get_width(0)
    local show_right = width >= 70
    local show_full = width >= 90 
    local m = vim.fn.mode()
    local state, label = "Norm", "NORMAL"
    if m == 'i' then state, label = "Ins", "INSERT" elseif m:match("^[vV\22]") then state, label = "Vis", "VISUAL" elseif m == 'c' then label = "COMMAND" elseif m == 't' then label = "TERMINAL" end

    local has_branch = _G.git_branch and _G.git_branch ~= ""
    local branch = has_branch and _G.git_branch or ""
    local mod = vim.bo.modified and " 𔒝 " or ""
    local time = os.date("| %a %b %d %I:%M %p")

    local left_core = table.concat({
        "%#Mode" .. state .. "# " .. label .. " ",
        "%#Sep" .. state .. "A# ",
        "%#Info" .. state .. "#" .. (has_branch and branch .. " ┆ %t" or " %t") .. mod .. "%r ",
        "%#Sep" .. state .. "B# ",
        "%#StatusBody#"
    })
    local left_extra = "%#SlRef# hello idiots! "
    local middle_part = "" .. _G.AnimState.output .. ""
    local right_part = table.concat({ "%#StatusBody#", " %y %l:%c %p%%  ", time, " " })

    if not show_right then return left_core end
    if not show_full then return left_core .. "%=" .. right_part end
    return left_core .. left_extra .. "%=" .. middle_part .. "%=" .. right_part
end
vim.opt.statusline = "%!v:lua.MyStatusLine()"

-- =============================================================================
--  6. WELCOME SCREEN (Native Buttons)
-- =============================================================================
local welcome = {}
welcome.config = {
    header_text = {
        [[ '||''''|         '||                                      ]],
        [[  ||    .          ||                                      ]],
        [[  ||'''|  '||''|,  ||''|, .|''|, '||),,(|,  .|''|, '||''|  '''|.  ]],
        [[  ||       ||  ||  ||  || ||..||  || || ||  ||..||  ||    .|''||  ]],
        [[ .||....|  ||..|' .||  || `|...  .||    ||. `|...  .||.   `|..||. ]],
        [[           ||                                              ]],
        [[          .||                                              ]],
    },
    quote = "It is only with the heart that one can see rightly; what is essential is invisible to the eye.",
    buttons = {
        { "e", "  New File",      ":ene <BAR> startinsert  " },
        { "f", "  Find File",     ":find * " },
        { "r", "  Recent",        ":oldfiles " },
        { "g", "  Grep Text",     ":grep  " },
        { "c", "  Config",        ":e $MYVIMRC  " },
        { "q", "  Quit",          ":qa  " },
    },
    flower_art = {
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠖⠋⠉⠉⠳⡴⠒⠒⠒⠲⠤⢤⣀ ]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠊⠀⠀⡴⠚⡩⠟⠓⠒⡖⠲⡄⠀⠀⠈⡆ ]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡞⠁⢠⠒⠾⢥⣀⣇⣚⣹⡤⡟⠀⡇⢠⠀⢠⠇ ]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣄⣀⠀⡇⠀⠀⠀⠀⠀⢀⡜⠁⣸⢠⠎⣰⣃ ]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡍⠀⠉⠉⠛⠦⣄⠀⢀⡴⣫⠴⠋⢹⡏⡼⠁⠈⠙⢦⡀ ]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡽⣄⠀⠀⠀⠀⠈⠙⠻⣎⡁⠀⠀⣸⡾⠀⠀⠀⠀⣀⡹⠂ ]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡞⠁⠀⠈⢣⡀⠀⠀⠀⠀⠀⠀⠉⠓⠶⢟⠀⢀⡤⠖⠋⠁ ]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠒⠦⡀⠙⠦⣀⠀⠀⠀⠀⠀⠀⢀⣴⡷⠋⠀⠀ ]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢦⣀⠈⠓⣦⣤⣤⣤⢶⡟⠁⠀⠀ ]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢤⣤⣤⡤⠤⠤⠤⠤⣌⡉⠉⠁⠀⠀⢸⢸⠁⡠⠖⠒⠒⢒⣒⡶⣶⠤ ]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠲⣍⠓⠦⣄⠀⠀⠙⣆⠀⠀⠀⡞⡼⡼⢀⣠⠴⠊⢉⡤⠚⠁ ]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⣄⠈⠙⢦⡀⢸⡀⠀⢰⢣⡧⠷⣯⣤⠤⠚⠉ ]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠑⣲⠤⠬⠿⠧⣠⢏⡞⠀⠀⠀ ]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠚⠉⠉⢉⣳⣄⣠⠏⡞⠀⠀⠀ ]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣟⣒⣋⣉⣉⡭⠟⢡⠏⡼⠀⠀⠀ ]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⢀⠏⣸⠁⠀⠀⠀ ]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡞⢠⠇⠀⠀⠀ ]],
        [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠓⠚⠀⠀⠀ ]],
    },
    highlights = {
        header = "Keyword", quote = "WelcomeQuote", quotemark = "Keyword", key = "DiagnosticHint",
        label = "Comment", flower = "WelcomeRose", stem = "WelcomeStem", bracket = "Delimiter", sep = "NonText",
    }
}
function welcome.draw()
    local buf = vim.api.nvim_get_current_buf()
    local ns_id = vim.api.nvim_create_namespace("Ephemera_welcome")
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'swapfile', false)
    vim.api.nvim_buf_set_option(buf, 'filetype', 'dashboard')
    vim.opt_local.number, vim.opt_local.relativenumber = false, false
    vim.opt_local.list, vim.opt_local.cursorline, vim.opt_local.wrap = false, false, false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.statusline = " "
    vim.opt_local.fillchars = { eob = " " }
    vim.opt_local.winhighlight = "StatusLine:Normal,StatusLineNC:Normal,EndOfBuffer:Normal"

    local block_keys = { 'h', 'j', 'k', 'l', '<Up>', '<Down>', '<Left>', '<Right>', 'w', 'b', 'e', 'ge', '0', '$', '^', '<C-u>', '<C-d>', '<C-f>', '<C-b>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb', '<PageUp>', '<PageDown>', 'gg', 'G', 'H', 'M', 'L', '{', '}', '(', ')', '%', '<ScrollWheelUp>', '<ScrollWheelDown>', '<ScrollWheelLeft>', '<ScrollWheelRight>', '<LeftMouse>', '<RightMouse>', '<MiddleMouse>', '<2-LeftMouse>', '<3-LeftMouse>', '<4-LeftMouse>', 'i', 'I', 'a', 'A', 'o', 'O', 'v', 'V', '<C-v>', 'r', 'R', 's', 'S', 'c', 'C', 'x', 'X', 'd', 'D', 'y', 'Y', 'p', 'P', 'u', '<C-r>', '/', '?', 'n', 'N', '*', '#', '<CR>', '<kEnter>' }
    for _, key in ipairs(block_keys) do vim.keymap.set({ 'n', 'v', 'o' }, key, '<nop>', { buffer = buf, silent = true }) end

    local win_w, win_h = vim.api.nvim_win_get_width(0), vim.api.nvim_win_get_height(0)
    local draw_queue = {}
    local function queue(row, col, text, hl_group, extra_meta)
        if row >= 0 and row < win_h then table.insert(draw_queue, { row = row, col = math.max(0, col), text = text, group = hl_group, meta = extra_meta }) end
    end
    local function get_str_width(str) return vim.fn.strdisplaywidth(str) end
    local header_w = 0; for _, l in ipairs(welcome.config.header_text) do header_w = math.max(header_w, get_str_width(l)) end
    local rose_w = 0; for _, l in ipairs(welcome.config.flower_art) do rose_w = math.max(rose_w, get_str_width(l)) end
    local max_btn_w = 0; for _, btn in ipairs(welcome.config.buttons) do max_btn_w = math.max(max_btn_w, get_str_width(string.format("[ %s ]  %s", btn[1], btn[2]))) end
    
    local quote_lines = {}
    local current_line = ""; for word in welcome.config.quote:gmatch("%S+") do if get_str_width(current_line .. " " .. word) > header_w then table.insert(quote_lines, current_line); current_line = word else current_line = (#current_line > 0) and (current_line .. " " .. word) or word end end; if #current_line > 0 then table.insert(quote_lines, current_line) end
    if #quote_lines > 0 then quote_lines[1] = '"' .. quote_lines[1]; quote_lines[#quote_lines] = quote_lines[#quote_lines] .. '"' end

    local gap = 4; local total_dual_w = header_w + gap + 1 + gap + rose_w; local show_rose = (win_w >= total_dual_w + 4)
    local left_col_x, right_col_x, sep_col_x
    if show_rose then local origin = math.floor((win_w - total_dual_w) / 2); left_col_x = math.max(2, origin); sep_col_x = left_col_x + header_w + gap; right_col_x = sep_col_x + gap + 1
    else left_col_x = math.max(2, math.floor((win_w - header_w) / 2)); right_col_x, sep_col_x = -1, -1 end

    local header_y = 3; local quote_y = header_y + #welcome.config.header_text + 1; local btn_start_y = quote_y + #quote_lines + 2; local btn_end_y = btn_start_y + #welcome.config.buttons - 1
    for i, line in ipairs(welcome.config.header_text) do queue(header_y + i - 1, left_col_x, line, welcome.config.highlights.header) end
    for i, line in ipairs(quote_lines) do local pad = math.max(0, math.floor((header_w - get_str_width(line)) / 2)); queue(quote_y + i - 1, left_col_x + pad, line, nil, { type = "quote", has_start = (i == 1), has_end = (i == #quote_lines) }) end
    local btn_pad = math.max(0, math.floor((header_w - max_btn_w) / 2))
    for i, btn in ipairs(welcome.config.buttons) do queue(btn_start_y + i - 1, left_col_x + btn_pad, string.format("[ %s ]  %s", btn[1], btn[2]), nil, { is_btn = true, key = btn[1] }) end
    if show_rose then
        for i = header_y, math.max(btn_end_y, header_y + #welcome.config.flower_art) do queue(i, sep_col_x, "│", welcome.config.highlights.sep) end
        for i, line in ipairs(welcome.config.flower_art) do queue(header_y + i - 1, right_col_x, line, (i < 11) and welcome.config.highlights.flower or welcome.config.highlights.stem) end
    end

    vim.api.nvim_buf_set_option(buf, 'modifiable', true)
    local empty_lines = {}; for i = 1, win_h do empty_lines[i] = string.rep(" ", win_w) end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, empty_lines)
    table.sort(draw_queue, function(a, b) if a.row ~= b.row then return a.row < b.row else return a.col > b.col end end)

    for _, item in ipairs(draw_queue) do
        local row, col, text = item.row, item.col, item.text
        pcall(vim.api.nvim_buf_set_text, buf, row, col, row, col + get_str_width(text), { text })
        local end_byte = col + #text
        if item.meta and item.meta.is_btn then
            local k_len = #item.meta.key
            vim.api.nvim_buf_add_highlight(buf, ns_id, welcome.config.highlights.bracket, row, col, col+1); vim.api.nvim_buf_add_highlight(buf, ns_id, welcome.config.highlights.key, row, col+2, col+2+k_len)
            vim.api.nvim_buf_add_highlight(buf, ns_id, welcome.config.highlights.bracket, row, col+3+k_len, col+4+k_len); vim.api.nvim_buf_add_highlight(buf, ns_id, welcome.config.highlights.label, row, col+4+k_len+2, end_byte)
        elseif item.meta and item.meta.type == "quote" then
            local s, e = col, end_byte; if item.meta.has_start then vim.api.nvim_buf_add_highlight(buf, ns_id, welcome.config.highlights.quotemark, row, s, s+1); s=s+1 end
            if item.meta.has_end then vim.api.nvim_buf_add_highlight(buf, ns_id, welcome.config.highlights.quotemark, row, e-1, e); e=e-1 end
            if s < e then vim.api.nvim_buf_add_highlight(buf, ns_id, welcome.config.highlights.quote, row, s, e) end
        elseif item.group then vim.api.nvim_buf_add_highlight(buf, ns_id, item.group, row, col, end_byte) end
    end
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    for _, btn in ipairs(welcome.config.buttons) do vim.api.nvim_buf_set_keymap(buf, 'n', btn[1], btn[3] .. "<CR>", { noremap = true, silent = true }) end
end

vim.api.nvim_create_autocmd("VimEnter", { callback = function() if vim.fn.argc() == 0 then welcome.draw() end end })
vim.api.nvim_create_autocmd("VimResized", { callback = function() if vim.bo.filetype == "dashboard" then welcome.draw() end end })

vim.schedule(function()
	print("Rathan's Vanilla Config (Ephemera_vanilla) Loaded.")
end)
