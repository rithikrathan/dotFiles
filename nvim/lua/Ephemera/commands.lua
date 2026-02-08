-- ============================================================================
--  AUTOCOMMANDS
-- ============================================================================

-- 1. FILETYPE DETECTION (Single Autocommand Table)
local ft_map = {
	sv   = "systemverilog",
	v    = "verilog",
	pyde = "python",
	pde  = "processing",
}

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = vim.tbl_map(function(ext) return "*." .. ext end, vim.tbl_keys(ft_map)),
	callback = function(opts)
		local ext = vim.fn.fnamemodify(opts.file, ":e")
		if ft_map[ext] then
			vim.bo.filetype = ft_map[ext]
		end
	end,
})

-- vennvim
vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "*:[vV]",
	callback = function()
		if vim.b.venn_enabled then
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-v>", true, false, true), "n", false)
		end
	end,
})

-- 2. GENERAL UTILITIES (Yank, Reload, Netrw)
vim.api.nvim_create_user_command("ReloadConfig", function()
	vim.cmd("source $MYVIMRC")
	print("Configuration Reloaded.")
end, {})

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank { higroup = "IncSearch", timeout = 120 }
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",
	callback = function()
		-- Backup Keybind
		vim.keymap.set("n", "<leader>d", function()
			local dir = vim.b.netrw_curdir
			local target = vim.fn.expand("<cfile>")
			if target ~= "" then
				vim.fn.system({ "cp", "-r", dir .. "/" .. target, dir .. "/" .. target .. ".bak" })
				vim.cmd("edit " .. vim.fn.fnameescape(dir))
				print("Backup created.")
			end
		end, { buffer = true, remap = false })

		-- Copy Path Keybind
		vim.keymap.set('n', '<C-P>', function()
			local path = vim.fn.fnamemodify(vim.b.netrw_curdir .. "/" .. vim.fn.expand('<cfile>'), ':.')
			print(path)
			vim.fn.setreg('+', path)
		end, { buffer = true })
	end
})

-- 3. STATUSLINE RESTORATION (Fixes "White Bar" & Missing Statusline)
local window_fixes = {
	["FileType"] = { "qf", "help", "man" },
	["TermOpen"] = { "*" },
	["User"]     = { "FzfStatusLine" },
}

for event, patterns in pairs(window_fixes) do
	vim.api.nvim_create_autocmd(event, {
		pattern = patterns,
		callback = function()
			vim.opt_local.statusline = "%!v:lua.EphemeraStatusLine()"
		end,
	})
end

-- ============================================================================
--  USER DEFINED COMMANDS:
-- ============================================================================
-- Setstatus
-- ============================================================================
--  STATUS MESSAGE & AERIAL LOGIC (DO NOT SKIP)
-- ============================================================================

_G.statusMessage = ""
local last_recorded_symbol = ""

local status_lookup = {
	wtf = "what the fuck mate",
	ok = "All systems operational",
	error = "Critical failure detected",
	busy = "Working on it..."
}

local function useAerial()
	local has_aerial, aerial = pcall(require, "aerial")
	if not has_aerial then return end

	local output = ""

	if aerial.get_location then
		local symbols = aerial.get_location(true)
		if symbols and #symbols > 0 then
			local s = symbols[#symbols]
			local icon = s.icon or s.kind

			-- Bridged to your AerialSymbolsl group
			-- output = "%#AerialSymbolsl#" .. icon .. "%#StatusBody# " .. s.name
			output = string.format("%%#AerialSymbolsl#%s%%#StatusBody# %s", icon, s.name)
		end
		-- elseif aerial.get_status then
		--     output = aerial.get_status() or ""
	end

	if output == last_recorded_symbol then return end

	_G.statusMessage = output
	last_recorded_symbol = output
	vim.cmd("redrawstatus")
end

vim.api.nvim_create_user_command('SetStatus', function(opts)
	local mode, payload = opts.args:match("^(%S+)%s*(.*)$")

	pcall(vim.api.nvim_del_augroup_by_name, "StatusSmartUpdate")

	if mode == "text" then
		_G.statusMessage = payload
		vim.cmd("redrawstatus")
	elseif mode == "msg" then
		local msg = status_lookup[payload]
		if msg then
			_G.statusMessage = msg
			vim.cmd("redrawstatus")
		end
	elseif mode == "aerial" then
		last_recorded_symbol = ""
		useAerial()

		local group = vim.api.nvim_create_augroup("StatusSmartUpdate", { clear = true })
		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorHold", "BufEnter", "InsertLeave" }, {
			group = group,
			callback = useAerial
		})
	end
end, {
	nargs = '+',
	complete = function(ArgLead, CmdLine)
		local args = vim.split(CmdLine, "%s+")
		if #args == 2 then return { "text", "msg", "aerial" } end
		if #args == 3 and args[2] == "msg" then return vim.tbl_keys(status_lookup) end
	end
})

-- clear buffers in the harpoon list
vim.api.nvim_create_user_command('HarpoonClr', function()
	local has_harpoon, harpoon = pcall(require, "harpoon")
	if not has_harpoon then
		print("Harpoon not found")
		return
	end
	harpoon:list():clear()
	print("󰀱 Harpoon list nuked.")
end, { desc = "Clear all buffers from Harpoon list" })

-- close all buffers that are open and not in harpoon list

vim.api.nvim_create_user_command('HarpoonOnly', function()
	local has_harpoon, harpoon = pcall(require, "harpoon")
	if not has_harpoon then
		print("Harpoon not found")
		return
	end

	local harpoon_list = harpoon:list()
	local harpoon_files = {}

	-- 1. Create a lookup table of files in Harpoon
	for _, item in ipairs(harpoon_list.items) do
		-- Store the absolute path to ensure accurate comparison
		local full_path = vim.fn.fnamemodify(item.value, ":p")
		harpoon_files[full_path] = true
	end

	local current_buf = vim.api.nvim_get_current_buf()
	local buffers = vim.api.nvim_list_bufs()
	local closed_count = 0

	-- 2. Iterate and compare
	for _, bufnr in ipairs(buffers) do
		if vim.api.nvim_buf_is_loaded(bufnr) and bufnr ~= current_buf then
			local buf_path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p")

			-- If the buffer is NOT in Harpoon and NOT modified
			if not harpoon_files[buf_path] then
				if not vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
					vim.api.nvim_buf_delete(bufnr, { force = false })
					closed_count = closed_count + 1
				end
			end
		end
	end

	print(string.format("󰀱 Kept Harpoon buffers. Closed %d others.", closed_count))
end, { desc = "Close all buffers not marked in Harpoon" })
