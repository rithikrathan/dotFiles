-- Insert Mode Cursor Movement (Alt + hjkl)
vim.keymap.set("i", "<A-h>", "<Left>", { desc = "Move cursor left" })
vim.keymap.set("i", "<A-l>", "<Right>", { desc = "Move cursor right" })
vim.keymap.set("i", "<A-j>", "<Down>", { desc = "Move cursor down" })
vim.keymap.set("i", "<A-k>", "<Up>", { desc = "Move cursor up" })

-- some vertical navigation in insert mode
vim.keymap.set("i", "<A-o>", '<Esc>o')
vim.keymap.set("i", "<A-O>", '<Esc>O')

-- treesitter conftext
vim.keymap.set("n", "[c", function()
	require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true })

-- Undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Basic Mappings
vim.keymap.set({ "n", "v", "t", "i" }, "<A-n>", '<CR>', { remap = true })

-- copy and paste with system clipboard
vim.keymap.set("v", "<leader>y", '"+ygv', { remap = true })
vim.keymap.set("n", "<leader>p", '"+p', { remap = true })

vim.keymap.set({ "n", "v", "t", "i" }, "<F5>", ':w | nohl | make<CR>', { remap = true })
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set({ "n", "i" }, "<A-[>", "zt")
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set({ "v", "i" }, "<leader><Tab>", "<Esc>", { noremap = true, silent = true })
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
	else
		print("Canceled.")
	end
end)

vim.keymap.set('n', '<leader>x', function() os.execute('xdg-open ' .. vim.fn.expand('%:p:h')) end)

vim.keymap.set('n', '<leader>xx', function()
	local app = vim.fn.input("Open with: ")
	if app ~= "" then os.execute(app .. " " .. vim.fn.shellescape(vim.fn.expand('%:p')) .. " &") end
end)

-- vim.opt.path:append("**")
-- vim.opt.wildmenu = true
-- vim.keymap.set("n", "<leader>pf", ":find *")
-- vim.keymap.set("n", "<leader>fb", ":ls<CR>:b<Space>")
--
-- vim.keymap.set("n", "<leader>ff", function()
--     local path = vim.fn.input("Find file: ", "", "file")
--     if path ~= "" then vim.cmd("edit " .. path) end
-- end)

vim.keymap.set("n", "<leader>fg", function()
	local pattern = vim.fn.input("Grep > ")
	if pattern ~= "" then
		vim.cmd("grep! -r " .. pattern .. " ."); vim.cmd("copen")
	end
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

--LSP-zero keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		local opts = { buffer = event.buf }
		-- > change these in the future
		vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
		vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
		vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
		vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
		vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
		vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
		vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
		vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
		vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
		vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
	end,
})

-- find files and dirs
vim.keymap.set('n', '<leader>jdf', function()
	vim.cmd("Files")
end)

--Harpoon with telescope setup and keymaps
local harpoon = require("harpoon")

vim.keymap.set("n", "<A-h>", function()
	harpoon:list():add()
end)
vim.keymap.set("n", "<A-g>", function()
	harpoon:list():remove()
end)
vim.keymap.set("n", "<leader>1", function()
	harpoon:list():select(1)
end)
vim.keymap.set("n", "<leader>2", function()
	harpoon:list():select(2)
end)
vim.keymap.set("n", "<leader>3", function()
	harpoon:list():select(3)
end)
vim.keymap.set("n", "<leader>4", function()
	harpoon:list():select(4)
end)
vim.keymap.set("n", "<A-[>", function()
	harpoon:list():prev() -- go to previous buffer
end)
vim.keymap.set("n", "<A-]>", function()
	harpoon:list():next() -- go to previous buffer
end)

--Telescope keymaps
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fgi", builtin.git_files, { desc = "Telescope git file search" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

vim.keymap.set({ "n", "v" }, "<leader>va", vim.lsp.buf.code_action)

vim.keymap.set("n", "<leader>gr", function()
	builtin.grep_string({ search = vim.fn.input("Grep >") })
end, { desc = "Telescope grep" })

vim.keymap.set("n", "<leader>gq", function()
	require("telescope.builtin").grep_string({
		search = vim.fn.input("Grep > "),
		attach_mappings = function(_, map)
			map("i", "<CR>", function(prompt_bufnr)
				require("telescope.actions").send_to_qflist(prompt_bufnr)
				require("telescope.actions").open_qflist(prompt_bufnr)
			end)
			return true
		end,
	})
end, { desc = "Grep → quickfix" })



--Plugin specific keymaps
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)                                                                --open a Git window
vim.keymap.set("n", "<leader>gg", vim.cmd.GitGutterToggle)                                                    --Toggle gitgutter
vim.keymap.set("n", "<leader>gt", "<cmd>GitGutterLineHighlightsToggle | GitGutterLineNrHighlightsToggle<CR>") --toggle git line highlights
vim.keymap.set("n", "<leader>m", vim.cmd.MinimapToggle)
vim.keymap.set("n", "<leader>tt", "<cmd>sp | term<CR>")

-- Relative path copy of a buffer
vim.keymap.set('n', '<C-P>', function()
	local path = vim.api.nvim_buf_get_name(0)
	if path == "" then return end
	local rel = vim.fn.fnamemodify(path, ':.')
	print(rel)
	vim.fn.setreg('+', vim.fn.shellescape(rel))
end)

vim.keymap.set('n', '<leader>X', function()
	local dir = vim.fn.expand('%:p:h')   -- directory of current file
	local app = vim.fn.input("Open with: ") -- prompt for application
	if app ~= "" then
		os.execute(vim.fn.shellescape(app) .. " " .. vim.fn.shellescape(dir) .. " &")
	end
end, { desc = 'Open current directory with custom application' })

-- toggle boolean and inverses
local function toggle_logic()
	local toggle_map = {
		-- Logic & Booleans
		["true"] = "false",
		["0"] = "1",
		["True"] = "False",
		["TRUE"] = "FALSE",
		["yes"] = "no",
		["Yes"] = "No",
		["YES"] = "NO",
		["on"] = "off",
		["On"] = "Off",
		["ON"] = "OFF",

		-- Comparisons & Operators
		["=="] = "!=",
		["==="] = "!==",
		["&&"] = "||",
		["and"] = "or",
		[">"] = "<",
		[">="] = "<=",
		["+"] = "-",
		["++"] = "--",
		["+="] = "-=",

		-- Visibility & Access
		["public"] = "private",
		["protected"] = "private",
		["static"] = "dynamic",
		["const"] = "let",
		["readonly"] = "readwrite",

		-- State & Actions
		["enable"] = "disable",
		["enabled"] = "disabled",
		["start"] = "stop",
		["open"] = "close",
		["opened"] = "closed",
		["show"] = "hide",
		["visible"] = "hidden",
		["valid"] = "invalid",
		["success"] = "failure",
		["attach"] = "detach",
		["lock"] = "unlock",
		["bind"] = "unbind",

		-- Directions & UI Layout
		["top"] = "bottom",
		["left"] = "right",
		["up"] = "down",
		["high"] = "low",
		["height"] = "width",
		["inner"] = "outer",
		["inside"] = "outside",
		["min"] = "max",
		["minimum"] = "maximum",
		["horizontal"] = "vertical",
		["row"] = "column",
		["inline"] = "block",

		-- Flex & Grid
		["flex"] = "grid",
		["around"] = "between",
		["relative"] = "absolute",

		-- Order & Position
		["first"] = "last",
		["prev"] = "next",
		["previous"] = "next",
		["head"] = "tail",
		["push"] = "pop",
		["shift"] = "unshift",

		-- HTTP & DevOps
		["get"] = "post",
		["put"] = "delete",
		["master"] = "main",
		["stage"] = "unstage",
		["pull"] = "push",
		["define"] = "undefine",
	}

	local lookup = {}
	for k, v in pairs(toggle_map) do
		lookup[k] = v
		lookup[v] = k
	end

	-- Use <cWORD> to get the full string including symbols
	local full_word = vim.fn.expand("<cWORD>")

	-- This pattern splits the string into: [Leading Symbols][The Word][Trailing Symbols]
	-- %W* = Non-word characters (brackets, dots, etc.)
	-- [%w_!=<>%&%|%+%-%*%/^%%#]+ = The "Core" (letters, numbers, and common operators)
	local lead, core, trail = full_word:match("^(%W*)([%w_!=<>%&%|%+%-%*%/^%%#]+)(%W*)$")

	if core and lookup[core] then
		local inverse = lookup[core]
		-- Reassemble the word with its original surrounding characters
		local replacement = lead .. inverse .. trail

		-- Use 'set_current_line' for a surgical strike that won't trigger unwanted motions
		local line = vim.api.nvim_get_current_line()
		local col = vim.api.nvim_win_get_cursor(0)[2]

		-- Replace the <cWORD> at the cursor position
		-- We use vim.fn.setline to make sure undo history is preserved nicely
		vim.cmd("normal! ciW" .. replacement)
	else
		print("No toggle found for core: " .. (core or "nil"))
	end
end

vim.keymap.set("n", "<leader>i", toggle_logic, { desc = "Smart Toggle Inverse" })

-- testing new keymaps

--use this keybind to test some function
vim.keymap.set("n", "]]]", function()
	-- print(vim.fn.getcwd())
	print(vim.fn.expand('%:p:h'))
end)
