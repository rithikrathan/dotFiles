local M = {}

M.scratchpad = {}
M.notepad = {}
M.reference = {}

local scratch_buf = nil
local notes_dir = vim.fn.stdpath("config") .. "/lua/Ephemera/notes"
local note_buf = nil
local last_note_buf = nil
local man_buf = nil
local prev_buf = nil
local lookup_history = {}

local builtin_commands = {
    { name = "man",       desc = "Manual pages",            cmd = "man %s 2>/dev/null || tldr %s 2>/dev/null || echo '%s: not found'" },
    { name = "tldr",      desc = "Simplified manual",       cmd = "tldr %s" },
    { name = "cheat.sh",  desc = "Quick code examples",      cmd = "curl -s cheat.sh/%s" },
    { name = "dict",      desc = "Dictionary definition",    cmd = "dict %s 2>/dev/null || echo '%s: not found in dict'" },
    { name = "weather",   desc = "Weather (if available)",   cmd = "curl -s wttr.in/%s 2>/dev/null || echo 'weather not available'" },
}

local function ensure_notes_dir()
	local dir = vim.fn.expand(notes_dir)
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p")
	end
	return dir
end

local function get_note_path(name)
	if not name:match("%.gnote$") then
		name = name .. ".gnote"
	end
	return ensure_notes_dir() .. "/" .. name
end

local function is_note_buffer(bufnr)
	if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
		return false
	end
	local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
	return ft == "gnote"
end

local function get_cmd_output(cmd)
    local handle = io.popen(cmd .. " 2>&1")
    if not handle then
        return "Error: could not execute command"
    end
    local result = handle:read("*a")
    handle:close()
    return result ~= "" and result or "(no output)"
end

local function create_man_buf(name, content)
    if man_buf and vim.api.nvim_buf_is_valid(man_buf) then
        vim.cmd("bwipeout! " .. man_buf)
    end

    man_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value("buftype", "nofile", { buf = man_buf })
    vim.api.nvim_set_option_value("bufhidden", "hide", { buf = man_buf })
    vim.api.nvim_set_option_value("swapfile", false, { buf = man_buf })
    vim.api.nvim_buf_set_lines(man_buf, 0, -1, false, vim.split(content, "\n", { plain = true }))
    vim.api.nvim_buf_set_name(man_buf, "ref:" .. name)

    return man_buf
end

local function display_content(name, content)
    if prev_buf == nil or not vim.api.nvim_buf_is_valid(prev_buf) then
        prev_buf = vim.api.nvim_get_current_buf()
    end

    local buf = create_man_buf(name, content)
    vim.cmd("enew")
    vim.api.nvim_set_current_buf(buf)
    vim.bo.filetype = "ref"
    vim.bo.buflisted = false
    vim.bo.modifiable = false

    vim.keymap.set("n", "q", function()
        M.reference.close()
    end, { buffer = true, silent = true, desc = "Close reference buffer" })
end

function M.scratchpad.open()
	if scratch_buf and vim.api.nvim_buf_is_valid(scratch_buf) then
		if vim.api.nvim_get_current_buf() == scratch_buf then
			if prev_buf and vim.api.nvim_buf_is_valid(prev_buf) then
				vim.cmd("buffer " .. prev_buf)
			else
				vim.cmd("b#")
			end
			return
		end
		vim.cmd("buffer " .. scratch_buf)
		return
	end

	prev_buf = vim.api.nvim_get_current_buf()
	vim.cmd("enew")
	local buf = vim.api.nvim_get_current_buf()
	vim.bo.filetype = "scratch"
	vim.bo.buflisted = true
	scratch_buf = buf
end

function M.scratchpad.close()
	if scratch_buf and vim.api.nvim_buf_is_valid(scratch_buf) then
		vim.cmd("bwipeout! " .. scratch_buf)
		scratch_buf = nil
	end
end

function M.scratchpad.clone()
	local current_buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)

	if not scratch_buf or not vim.api.nvim_buf_is_valid(scratch_buf) then
		vim.cmd("enew")
		scratch_buf = vim.api.nvim_get_current_buf()
		vim.bo.filetype = "scratch"
		vim.bo.buflisted = true
	else
		vim.api.nvim_set_current_buf(scratch_buf)
	end

	vim.api.nvim_buf_set_lines(scratch_buf, 0, -1, false, lines)
end

function M.scratchpad.yank()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	vim.fn.setreg('"', table.concat(lines, "\n"))
end

function M.scratchpad.setup()
	vim.keymap.set("n", "<leader>ss", function() M.scratchpad.open() end)
	vim.keymap.set("n", "<leader>sq", function() M.scratchpad.close() end)
	vim.keymap.set("n", "<leader>sp", function() M.scratchpad.clone() end)
	vim.keymap.set("n", "<leader>sy", function() M.scratchpad.yank() end)
end

function M.notepad.open(name)
	name = name or "global"
	local note_path = get_note_path(name)

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) then
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			if bufname == note_path then
				if vim.api.nvim_get_current_buf() == bufnr then
					if prev_buf and vim.api.nvim_buf_is_valid(prev_buf) then
						vim.cmd("buffer " .. prev_buf)
					else
						vim.cmd("b#")
					end
				else
					vim.cmd("buffer " .. bufnr)
				end
				return
			end
		end
	end

	prev_buf = vim.api.nvim_get_current_buf()
	vim.cmd("edit " .. vim.fn.fnameescape(note_path))
	note_buf = vim.api.nvim_get_current_buf()
	last_note_buf = note_buf
	vim.bo.filetype = "gnote"
	vim.bo.buflisted = true
end

function M.notepad.open_global()
	M.notepad.open("global")
end

function M.notepad.toggle()
	local current_buf = vim.api.nvim_get_current_buf()

	if is_note_buffer(current_buf) then
		if prev_buf and vim.api.nvim_buf_is_valid(prev_buf) then
			vim.cmd("buffer " .. prev_buf)
		else
			vim.cmd("b#")
		end
	else
		if last_note_buf and vim.api.nvim_buf_is_valid(last_note_buf) then
			prev_buf = current_buf
			vim.cmd("buffer " .. last_note_buf)
		else
			M.notepad.open("global")
		end
	end
end

function M.notepad.picker()
	local has_telescope, telescope = pcall(require, "telescope")
	if not has_telescope then
		vim.notify("Telescope not found", vim.log.levels.ERROR)
		return
	end

	ensure_notes_dir()

	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local sorters = require("telescope.sorters")
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local opts = {
		prompt_title = "~ Notes ~",
		finder = finders.find_dir({
			path = notes_dir,
			entry_maker = function(entry)
				if entry:match("%.gnote$") then
					return {
						value = entry,
						display = entry:gsub("%.gnote$", ""),
						ordinal = entry,
						path = notes_dir .. "/" .. entry,
					}
				end
			end,
		}),
		sorter = sorters.get_fuzzy_file(),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				local selection = action_state.get_selected_entry()
				if selection then
					actions.close(prompt_bufnr)
					prev_buf = vim.api.nvim_get_current_buf()
					vim.cmd("edit " .. vim.fn.fnameescape(selection.path))
					local new_buf = vim.api.nvim_get_current_buf()
					vim.bo.filetype = "gnote"
					last_note_buf = new_buf
				end
			end)
			return true
		end,
	}

	pickers.new({}, opts):find()
end

function M.notepad.setup()
	vim.keymap.set("n", "<leader>gn", function() M.notepad.open_global() end)
	vim.keymap.set("n", "<leader>nn", function() M.notepad.toggle() end)
	vim.keymap.set("n", "<leader>np", function() M.notepad.picker() end)
end

function M.reference.picker()
    local has_telescope, telescope = pcall(require, "telescope")
    if not has_telescope then
        M.reference.picker_builtin()
        return
    end

    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    pickers.new({}, {
        prompt_title = "~ Reference Lookup ~",
        finder = finders.new_table({
            results = builtin_commands,
            entry_maker = function(entry)
                return {
                    value = entry.name,
                    display = entry.name .. "  (" .. entry.desc .. ")",
                    ordinal = entry.name .. " " .. entry.desc,
                }
            end,
        }),
        sorter = require("telescope.sorters").get_fuzzy_file(),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                if selection then
                    actions.close(prompt_bufnr)
                    vim.defer_fn(function()
                        M.reference.lookup(selection.value)
                    end, 10)
                end
            end)
            return true
        end,
    }):find()
end

function M.reference.picker_builtin()
    vim.ui.select(builtin_commands, {
        prompt = "Select reference type:",
        format_item = function(item)
            return item.name .. " - " .. item.desc
        end,
    }, function(choice)
        if choice then
            local term = vim.fn.input(choice.name .. " lookup: ")
            if term and term ~= "" then
                M.reference.lookup(choice.name, term)
            end
        end
    end)
end

function M.reference.lookup(name, term)
    if not term then
        term = name
        name = "man"
    end

    local cmd = nil
    for _, c in ipairs(builtin_commands) do
        if c.name == name then
            cmd = c.cmd:format(term)
            break
        end
    end

    if not cmd then
        cmd = "man " .. term .. " 2>/dev/null || tldr " .. term .. " 2>/dev/null || echo 'not found'"
    end

    local content = get_cmd_output(cmd)

    if content:match("not found") and name == "man" then
        content = get_cmd_output("curl -s cheat.sh/" .. term)
    end

    local header = "=== " .. name:upper() .. ": " .. term .. " ===\n\n"
    display_content(name .. ":" .. term, header .. content)

    table.insert(lookup_history, 1, { name = name, term = term })
    if #lookup_history > 20 then
        table.remove(lookup_history)
    end
end

function M.reference.toggle()
    if man_buf and vim.api.nvim_buf_is_valid(man_buf) then
        if vim.api.nvim_get_current_buf() == man_buf then
            if prev_buf and vim.api.nvim_buf_is_valid(prev_buf) then
                vim.cmd("buffer " .. prev_buf)
            else
                vim.cmd("b#")
            end
        else
            vim.cmd("buffer " .. man_buf)
        end
    else
        vim.defer_fn(function()
            M.reference.picker()
        end, 10)
    end
end

function M.reference.history()
    if #lookup_history == 0 then
        vim.notify("No lookup history", vim.log.levels.INFO)
        return
    end

    vim.ui.select(lookup_history, {
        prompt = "Lookup history:",
        format_item = function(item)
            return item.name .. ": " .. item.term
        end,
    }, function(choice)
        if choice then
            M.reference.lookup(choice.name, choice.term)
        end
    end)
end

function M.reference.close()
    if man_buf and vim.api.nvim_buf_is_valid(man_buf) then
        vim.cmd("bwipeout! " .. man_buf)
        man_buf = nil
    end
end

function M.reference.setup()
    vim.keymap.set("n", "<leader>mn", function() M.reference.picker() end, { desc = "Reference picker" })
    vim.keymap.set("n", "<leader>mm", function() M.reference.toggle() end, { desc = "Toggle reference" })
    vim.keymap.set("n", "<leader>mx", function() M.reference.close() end, { desc = "Close reference" })
    vim.keymap.set("n", "<leader>mh", function() M.reference.history() end, { desc = "Lookup history" })
    vim.keymap.set("n", "<leader>ml", function() M.reference.lookup("man", vim.fn.expand("<cword>")) end, { desc = "Lookup word under cursor" })
end

function M.setup()
	M.scratchpad.setup()
	M.notepad.setup()
	M.reference.setup()
end

return M
