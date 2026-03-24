local scratchpad = {}

local scratch_buf = nil
local prev_buf = nil

function scratchpad.open()
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

function scratchpad.close()
	if scratch_buf and vim.api.nvim_buf_is_valid(scratch_buf) then
		vim.cmd("bwipeout! " .. scratch_buf)
		scratch_buf = nil
	end
end

function scratchpad.clone()
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

function scratchpad.yank()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	vim.fn.setreg('"', table.concat(lines, "\n"))
end

function scratchpad.setup()
	vim.keymap.set("n", "<leader>ss", function() scratchpad.open() end)
	vim.keymap.set("n", "<leader>sq", function() scratchpad.close() end)
	vim.keymap.set("n", "<leader>sp", function() scratchpad.clone() end)
	vim.keymap.set("n", "<leader>sy", function() scratchpad.yank() end)

	vim.api.nvim_create_autocmd("BufWriteCmd", {
		pattern = "scratchpad",
		callback = function()
			print("Cannot write scratchpad buffer")
			return true
		end,
	})
end

return scratchpad
