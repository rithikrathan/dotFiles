--==-=-=-=-=-=-=-=-=-==[AUTOCOMMANDS]==--=-=-=-=-=-=-=-=--

-- Setting the filetype for SystemVerilog and Verilog
vim.api.nvim_create_autocmd(
	{ "BufNewFile", "BufRead" }, {
		pattern = { "*.sv" },
		command = "set filetype=systemverilog",
	}
)
vim.api.nvim_create_autocmd(
	{ "BufNewFile", "BufRead" }, {
		pattern = { "*.v" },
		command = "set filetype=verilog",
	}
)

-- file type of processing5 python
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.pyde",
	callback = function()
		vim.bo.filetype = "python"
	end,
})

-- file type of processing java
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.pde",
	callback = function()
		vim.bo.filetype = "processing"
	end,
})

-- Yank highlight
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



--==-=-=-=-=-=-=-=-=-==[USER DEFINED COMMANDS]==--=-=-=-=-=-=-=-=--

