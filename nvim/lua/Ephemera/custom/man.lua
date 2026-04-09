local Reference = {}

--TODO: fix all bugs this has this is an unfinished program
-- will have a lot of bug on of which needed to be tested
-- is that when ther is already an man ubffer and we try to create a nw one
-- what happens will it break idk bro
local manBuffer = nil
local prev_buf = nil

function Reference.open()
    Reference.close()
    prev_buf = vim.api.nvim_get_current_buf()
    local inputString = vim.fn.input("Refer: ")
    if inputString then
        manBuffer = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_set_option_value('buftype', 'nofile', { buf = manBuffer })
        vim.api.nvim_set_option_value('bufhidden', 'hide', { buf = manBuffer })
        vim.api.nvim_set_option_value('swapfile', false, { buf = manBuffer })
        vim.cmd("enew")
        vim.api.nvim_set_current_buf(manBuffer)
        vim.cmd("r !" .. inputString)
        vim.cmd("normal! gg")
        vim.api.nvim_set_option_value('modifiable', false, { buf = manBuffer })
        vim.bo.filetype = "Reference"
        vim.bo.buflisted = false
    end
end

function Reference.look()
    if manBuffer and vim.api.nvim_buf_is_valid(manBuffer) then
        if vim.api.nvim_get_current_buf() == manBuffer then
            if prev_buf and vim.api.nvim_buf_is_valid(prev_buf) then
                vim.cmd("buffer " .. prev_buf)
            else
                vim.cmd("b#")
            end
            return
        end
        vim.cmd("buffer " .. manBuffer)
        return
    end
    Reference.open()
end

function Reference.close()
    if manBuffer and vim.api.nvim_buf_is_valid(manBuffer) then
        vim.cmd("bwipeout! " .. manBuffer)
        manBuffer = nil
    end
end

function Reference.setup()
    vim.keymap.set("n", "<leader>mn", function() Reference.open() end)
    vim.keymap.set("n", "<leader>mm", function() Reference.look() end)
    vim.keymap.set("n", "<leader>mx", function() Reference.close() end)

    vim.api.nvim_create_autocmd("BufWriteCmd", {
        pattern = "Reference",
        callback = function()
            print("This is a mannual bro")
            return true
        end,
    })
end

return Reference
