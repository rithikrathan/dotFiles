local M = {}

M.config = {
    transparent = true,
    glow = true,
    show_end_of_buffer = false,
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

function M.setup(user_config)
    M.config = vim.tbl_deep_extend("force", M.config, user_config or {})
    local colors = M.config.colors
    local bg_color = M.config.transparent and "NONE" or colors.bg
    local float_bg = M.config.transparent and "NONE" or colors.pmenu_bg

    local highlight_groups = {
        -- BASE UI
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
        Operator = { fg = colors.operator },
        Delimiter = { fg = colors.bracket },
        Search = { bg = "#5631a6", fg = "#ffffff", bold = true },
        CurSearch = { bg = "#ff5555", fg = "#090909", bold = true },
        Pmenu = { fg = colors.pmenu_fg, bg = colors.pmenu_bg },
        PmenuSel = { fg = colors.pmenu_bg, bg = colors.pmenu_sel_bg, bold = true },
        NormalFloat = { fg = colors.fg, bg = float_bg },
        FloatBorder = { fg = colors.border, bg = float_bg },

        -- TREESITTER (Full list)
        ["@function"] = { fg = colors.func },
        ["@method"] = { fg = colors.func },
        ["@keyword"] = { fg = colors.kw },
        ["@variable"] = { fg = colors.identifier },
        ["@type"] = { fg = colors.type },
        ["@string"] = { fg = colors.string },
        ["@constant"] = { fg = colors.constant },
        ["@operator"] = { fg = colors.operator },
        ["@punctuation.bracket"] = { fg = colors.bracket },
        ["@punctuation.delimiter"] = { fg = colors.bracket },
        ["@comment"] = { fg = colors.comment },
        ["@tag"] = { fg = colors.func },

        -- TELESCOPE (All missing groups added)
        TelescopeNormal = { fg = colors.fg, bg = "NONE" },
        TelescopeBorder = { fg = colors.border, bg = "NONE" },
        TelescopePromptNormal = { fg = colors.pmenu_fg, bg = "NONE" },
        TelescopePromptBorder = { fg = colors.border, bg = "NONE" },
        TelescopePromptTitle = { fg = colors.title, bg = "NONE", bold = true },
        TelescopePromptCounter = { fg = colors.cursor, bg = "NONE" },
        TelescopeSelectionCaret = { fg = colors.operator, bg = colors.visual },
        TelescopeSelection = { fg = colors.fg, bg = colors.visual, bold = true },
        TelescopeMatching = { fg = colors.operator, bg = "NONE", bold = true },

        -- BUFFERLINE
        BufferLineFill = { bg = "NONE", fg = colors.fg },
        BufferLineBackground = { bg = "NONE", fg = colors.fg },
        BufferLineBufferSelected = { bg = "NONE", fg = colors.bufferline_selection, bold = true },
        BufferLineSeparator = { bg = "NONE", fg = colors.line_nr },
        BufferLineIndicatorSelected = { bg = colors.bg, fg = colors.bufferline_selection },

        -- GITSIGNS
        GitSignsAdd = { fg = colors.added, bg = "NONE" },
        GitSignsChange = { fg = colors.changed, bg = "NONE" },
        GitSignsDelete = { fg = colors.removed, bg = "NONE" },

        -- NVIM-CMP
        CmpItemAbbr = { fg = colors.fg, bg = "NONE" },
        CmpItemAbbrMatch = { fg = colors.cursor, bg = "NONE", bold = true },
        CmpItemMenu = { fg = colors.comment, bg = "NONE" },
        CmpBorder = { fg = "#ff5555" },

        -- NVIM-TREE
        NvimTreeFolderName = { fg = colors.func },
        NvimTreeOpenedFolderName = { fg = colors.kw },
        NvimTreeRootFolder = { fg = colors.type },
        NvimTreeWindowPicker = { fg = colors.bg, bg = colors.search_highlight, bold = true },

        -- OIL
        OilDir = { fg = colors.identifier, bold = true, italic = true },
        OilFile = { fg = colors.string, italic = true, bold = true },
        OilSocket = { fg = colors.type },
        OilFloatBorder = { fg = colors.border },

        -- WHICH-KEY
        WhichKey = { fg = colors.func, bg = bg_color },
        WhichKeyGroup = { fg = colors.kw, bg = bg_color, bold = true },
        WhichKeyDesc = { fg = colors.func, bg = bg_color },
        WhichKeyTitle = { fg = colors.kw, bg = bg_color, bold = true },

        -- NOTIFY
        NotifyERRORBorder = { fg = colors.error },
        NotifyWARNBorder = { fg = colors.warning },
        NotifyINFOBorder = { fg = colors.info },
        NotifyERRORTitle = { fg = colors.error },
        NotifyWARNTitle = { fg = colors.warning },
        NotifyINFOTitle = { fg = colors.info },

        -- WELCOME SCREEN
        WelcomeRose = { fg = "#ff5555", bold = true },
        WelcomeStem = { fg = "#50fa7b", bold = true },
        WelcomeQuote = { fg = "#a1a1a1", italic = true },
    }

    -- Apply CMP Kind highlights
    local kinds = { "Text", "Method", "Function", "Variable", "Class", "Interface", "Module", "Property", "Keyword", "Snippet", "Constant", "Folder" }
    for _, kind in ipairs(kinds) do highlight_groups["CmpItemKind" .. kind] = { fg = colors.kw } end

    -- Helper to apply highlights
    for name, conf in pairs(highlight_groups) do
        local cmd = string.format("highlight %s guifg=%s guibg=%s", name, conf.fg or "NONE", conf.bg or "NONE")
        local gui = {}
        if conf.bold then table.insert(gui, "bold") end
        if conf.italic then table.insert(gui, "italic") end
        if conf.gui then table.insert(gui, conf.gui) end
        
        -- Glow Logic
        if M.config.glow and (name == "Function" or name == "Keyword" or name == "@function" or name == "@keyword") then
            table.insert(gui, "bold")
            cmd = cmd .. " guisp=" .. colors.glow_color
        end

        if #gui > 0 then cmd = cmd .. " gui=" .. table.concat(gui, ",") end
        vim.cmd(cmd)
    end

    -- LUALINE (Consolidated setup)
    local ok, lualine = pcall(require, "lualine")
    if ok then
        lualine.setup({
            options = {
                theme = {
                    normal = {
                        a = { bg = colors.bool, fg = colors.bg },
                        b = { bg = bg_color, fg = colors.bool },
                        c = { bg = colors.line_nr, fg = colors.bracket }
                    },
                    insert = {
                        a = { bg = bg_color, fg = colors.search_highlight, gui = "bold" },
                        b = { bg = colors.bg, fg = colors.type }
                    },
                }
            }
        })
    end
end

M.toggle_transparency = function()
    M.config.transparent = not M.config.transparent
    M.setup()
    print("Transparency: " .. (M.config.transparent and "ON" or "OFF"))
end

vim.api.nvim_create_user_command("ToggleTransparency", M.toggle_transparency, {})

return M
