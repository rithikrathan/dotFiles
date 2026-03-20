local M = {}

local function get_available_themes()
	local themes_dir = vim.fn.stdpath("config") .. "/lua/Ephemera/themes/"
	local themes = {}
	local exclude = {
		current = true,
		test = true,
		preview_sample = true,
	}

	for _, file in ipairs(vim.fn.readdir(themes_dir)) do
		if file:match("%.lua$") then
			local name = file:gsub("%.lua$", "")
			local is_backup = name:match("%.bak$") or name:match("%.bakbak$")
			if not exclude[name] and not is_backup then
				table.insert(themes, name)
			end
		end
	end

	table.sort(themes)
	return themes
end

function M.open()
	local themes = get_available_themes()
	local current = require("Ephemera.themes.current")

	local picker = require("telescope.pickers")
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	picker.new({}, {
		prompt_title = "Ephemera Themes",
		finder = require("telescope.finders").new_table({
			results = themes,
			entry_maker = function(entry)
				return {
					value = entry,
					display = entry .. (entry == current.name and " ●" or ""),
					ordinal = entry,
				}
			end,
		}),
		sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
		layout_strategy = "center",
		layout_config = {
			width = 0.6,
			height = 0.6,
			prompt_position = "top",
		},
		attach_mappings = function(prompt_bufnr, _)
			local last_theme = current.name

			local function apply_theme_on_navigate()
				local selection = action_state.get_selected_entry()
				if selection and selection.value ~= last_theme then
					last_theme = selection.value
					vim.schedule(function()
						local ok, theme = pcall(require, "Ephemera.themes." .. last_theme)
						if ok then
							pcall(theme.setup)
						end
					end)
				end
			end

			vim.keymap.set("n", "<Down>", function()
				actions.move_selection_next(prompt_bufnr)
				apply_theme_on_navigate()
			end, { buffer = prompt_bufnr })

			vim.keymap.set("n", "<Up>", function()
				actions.move_selection_previous(prompt_bufnr)
				apply_theme_on_navigate()
			end, { buffer = prompt_bufnr })

			vim.keymap.set("i", "<C-n>", function()
				actions.move_selection_next(prompt_bufnr)
				apply_theme_on_navigate()
			end, { buffer = prompt_bufnr })

			vim.keymap.set("i", "<C-p>", function()
				actions.move_selection_previous(prompt_bufnr)
				apply_theme_on_navigate()
			end, { buffer = prompt_bufnr })

			vim.keymap.set("i", "<Down>", function()
				actions.move_selection_next(prompt_bufnr)
				apply_theme_on_navigate()
			end, { buffer = prompt_bufnr })

			vim.keymap.set("i", "<Up>", function()
				actions.move_selection_previous(prompt_bufnr)
				apply_theme_on_navigate()
			end, { buffer = prompt_bufnr })

			actions.select_default:replace(function()
				local selection = action_state.get_selected_entry()
				if selection then
					M.apply_theme(selection.value)
				end
			end)

			vim.keymap.set("i", "<CR>", function()
				local selection = action_state.get_selected_entry()
				if selection then
					M.apply_theme(selection.value)
				end
			end, { buffer = prompt_bufnr })

			return true
		end,
	}):find()

	vim.cmd("stopinsert")
end

function M.apply_theme(theme_name)
	local ok, err = pcall(require, "Ephemera.themes." .. theme_name)
	if not ok then
		vim.notify("Failed to load theme: " .. theme_name .. "\n" .. err, vim.log.levels.ERROR)
		return
	end

	ok = pcall(require("Ephemera.themes." .. theme_name).setup)
	if not ok then
		vim.notify("Failed to setup theme: " .. theme_name, vim.log.levels.ERROR)
		return
	end

	local current_file = vim.fn.stdpath("config") .. "/lua/Ephemera/themes/current.lua"
	local content = string.format("return {\n  name = %q,\n}\n", theme_name)
	vim.fn.writefile(vim.split(content, "\n"), current_file)

	require("Ephemera.themes." .. theme_name).setup()
	print("Theme applied: " .. theme_name)
end

return M
