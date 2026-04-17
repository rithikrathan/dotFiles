local notepad = {}

local notes_dir = vim.fn.stdpath("config") .. "/lua/Ephemera/notes"
local note_buf = nil
local prev_buf = nil
local last_note_buf = nil

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

function notepad.open(name)
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

function notepad.open_global()
	notepad.open("global")
end

function notepad.toggle()
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
			notepad.open("global")
		end
	end
end

function notepad.picker()
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

function notepad.setup()
	vim.keymap.set("n", "<leader>gn", function() notepad.open_global() end)
	vim.keymap.set("n", "<leader>nn", function() notepad.toggle() end)
	vim.keymap.set("n", "<leader>np", function() notepad.picker() end)
end

return notepad
