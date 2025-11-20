local indices = { row_start = 3 }
local separators = { dadbod = "%s+|", csv = ",", }

local function convert_line(line)
    line = string.sub(line, indices.row_start)
    local stripped_line, num_matched = string.gsub(line, separators.dadbod, separators.csv)
    if num_matched > 1 then
        return stripped_line, num_matched ~= 0
    elseif num_matched == 1 then
        stripped_line = string.gsub(line, separators.dadbod, "")
        return stripped_line, true
    end

    return stripped_line, false
end


local csv_bufnr = nil
local csv_winid = nil

vim.api.nvim_create_user_command("ConvertToCsv", function(_)
    local current_buffer = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(current_buffer, 0, -1, false)

    local body = {}
    for _, line in ipairs(lines) do
        local converted_line, was_removed = convert_line(line)
        if was_removed then
            table.insert(body, converted_line)
        end
    end

    if #body == 0 then
        vim.notify("No lines to convert")
        return
    end

    if not csv_bufnr or not vim.api.nvim_buf_is_valid(csv_bufnr) then
        csv_bufnr = vim.api.nvim_create_buf(true, true)
        if csv_bufnr == 0 then
            vim.notify("Failed to create buffer for CSV", vim.log.levels.ERROR)
            return
        end
        vim.api.nvim_set_option_value("filetype", "csv", { buf = csv_bufnr })
    end

    vim.api.nvim_set_option_value("modifiable", true, { buf = csv_bufnr })
    vim.api.nvim_set_option_value("buftype", "", { buf = csv_bufnr })
    vim.api.nvim_buf_set_lines(csv_bufnr, 0, -1, false, body)

    if csv_winid and vim.api.nvim_win_is_valid(csv_winid) then
        vim.api.nvim_win_set_buf(csv_winid, csv_bufnr)
        vim.api.nvim_set_current_win(csv_winid)
    else
        vim.cmd("vsplit")
        csv_winid = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(0, csv_bufnr)
    end
end, {
    desc = "Converts the current dadbbod buffer to csv",
})
