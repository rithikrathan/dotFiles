-- -- Git Logic (Defined early so statusline can find it)
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

function _G.MyStatusLine()
    -- 1. WINDOW WIDTH CHECKS
    local width = vim.api.nvim_win_get_width(0)

    -- Thresholds
    local show_right  = width >= 70
    local show_full   = width >= 90 

    local m = vim.fn.mode()
    local state = "Norm"
    local label = "NORMAL"

    if m == 'i' then
        state = "Ins"
        label = "INSERT"
    elseif m:match("^[vV\22]") then
        state = "Vis"
        label = "VISUAL"
    elseif m == 'c' then
        label = "COMMAND"
    elseif m == 'R' then
        label = "REPLACE"
    elseif m == 't' then
        label = "TERMINAL"
    end

    -- Check if branch exists
    local has_branch = _G.git_branch and _G.git_branch ~= ""
    local branch = has_branch and _G.git_branch or ""
    
    -- local mod = vim.bo.modified and " ᯓ ★" or ""
    local mod = vim.bo.modified and " ˖᯽ ݁˖·" or ""

    -- Format: Thu Jan 29 10:02:45 PM
    -- %a=Day, %b=Month, %d=Date, %I=Hour(12), %M=Min, %S=Sec, %p=AM/PM
    local time = os.date("| %a %b %d %I:%M %p")

    -- --- COMPONENT DEFINITIONS ---
    -- 1. LEFT CORE (Sections 1 & 2) -> Always Visible
    local left_core_list = {
        -- Section 1: Mode
        "%#Mode" .. state .. "# " .. label .. " ",
        "%#Sep" .. state .. "A# "
    }

    -- Section 2: Branch | Filename (Combined in one color section)
    local info_content = ""
    if has_branch then
        info_content = branch .. " ┆ %t"
    else
        info_content = " %t"
    end
    table.insert(left_core_list, "%#Info" .. state .. "#" .. info_content .. mod .. "%r ")
    
    table.insert(left_core_list, "%#Sep" .. state .. "B# ")
    
    table.insert(left_core_list, "%#StatusBody#")

    local left_core = table.concat(left_core_list)

    local left_extra = "%#StatusBody# hello idiots! "

    -- 3. MIDDLE SIDE
    local middle_part = "────୨ৎ────"

    -- 4. RIGHT SIDE
    local right_part = table.concat({
        "%#StatusBody#", 
        " %y %l:%c %p%%  ",
        time,
        " "
    })

    -- --- RENDER LOGIC ---
    if not show_right then
        return left_core
    end

    if not show_full then
        return left_core .. "%=" .. right_part
    end

    return left_core .. left_extra .. "%=" .. middle_part .. "%=" .. right_part
end

vim.opt.statusline = "%!v:lua.MyStatusLine()"
