local M = {}

local stack = {}

function M.write(filepath, new_lines)
    local old_lines = vim.fn.readfile(filepath)
    if old_lines then
        table.insert(stack, { filepath = filepath, lines = old_lines })
    end
    vim.fn.writefile(new_lines, filepath)
end

function M.undo(refresh_fn)
    if #stack == 0 then
        vim.notify("Nothing to undo", vim.log.levels.WARN)
        return
    end
    local entry = table.remove(stack)
    vim.fn.writefile(entry.lines, entry.filepath)
    local buf = vim.fn.bufnr(entry.filepath)
    if buf ~= -1 then
        vim.api.nvim_buf_call(buf, function() vim.cmd("edit!") end)
    end
    if refresh_fn then refresh_fn() end
end

return M

