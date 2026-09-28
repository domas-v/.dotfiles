local M = {}

local function notify(message, level)
    vim.notify(message, level or vim.log.levels.INFO, { title = "Obsidian" })
end

local function is_within(path, root)
    path = vim.fs.normalize(path)
    root = vim.fs.normalize(root)
    return path == root or path:sub(1, #root + 1) == root .. "/"
end

local function date_for_offset(offset)
    local today = os.date("*t")
    local time = os.time({ year = today.year, month = today.month, day = today.day + offset, hour = 12 })
    return os.date("%Y-%m-%d", time)
end

local function task_block(buf, row)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local root_line = lines[row]
    local indent, marker, state, body = root_line:match("^(%s*)([-+*])%s+%[([^%]])%]%s*(.*)$")
    if not indent then
        return nil, "Place the cursor on a Markdown task checkbox first."
    end

    local base_indent = #indent
    local last = row
    local i = row + 1
    while i <= #lines do
        local line = lines[i]
        if line:match("^%s*$") then
            local next_nonblank = i + 1
            while next_nonblank <= #lines and lines[next_nonblank]:match("^%s*$") do
                next_nonblank = next_nonblank + 1
            end
            if next_nonblank <= #lines and #(lines[next_nonblank]:match("^(%s*)") or "") > base_indent then
                last = next_nonblank
                i = next_nonblank + 1
            else
                break
            end
        elseif #(line:match("^(%s*)") or "") > base_indent then
            last = i
            i = i + 1
        else
            break
        end
    end

    local block = {}
    for line_nr = row, last do
        local line = lines[line_nr]
        if line_nr == row then
            block[#block + 1] = {
                indent = indent,
                marker = marker,
                state = state,
                body = body,
            }
        else
            block[#block + 1] = { text = line }
        end
    end
    return { first = row, last = last, items = block }
end

local function template_lines(template_path, date)
    if vim.fn.filereadable(template_path) ~= 1 then
        return nil, "Could not read daily note template: " .. template_path
    end
    local lines = vim.fn.readfile(template_path)
    for i, line in ipairs(lines) do
        lines[i] = line:gsub("{{date:YYYY%-MM%-DD}}", date):gsub("{{date}}", date)
    end
    return lines
end

local function get_daily_buffer(path, date, template_path)
    local exists = vim.fn.filereadable(path) == 1
    if not exists then
        local lines, err = template_lines(template_path, date)
        if not lines then
            return nil, err
        end
        vim.fn.mkdir(vim.fs.dirname(path), "p")
        local ok = vim.fn.writefile(lines, path) == 0
        if not ok then
            return nil, "Could not create daily note: " .. path
        end
    end

    local buf = vim.fn.bufadd(path)
    vim.fn.bufload(buf)
    return buf
end

-- local function add_to_today_section(buf, block, source_link)
--     local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
--     local heading
--     for i, line in ipairs(lines) do
--         if line:match("^##%s+Today%s*$") then
--             heading = i
--             break
--         end
--     end
--
--     if not heading then
--         if #lines > 0 and lines[#lines] ~= "" then
--             lines[#lines + 1] = ""
--         end
--         lines[#lines + 1] = "## Today"
--         heading = #lines
--         lines[#lines + 1] = ""
--     end
--
--     local section_end = #lines + 1
--     for i = heading + 1, #lines do
--         if lines[i]:match("^##%s+") then
--             section_end = i
--             break
--         end
--     end
--
--     local inserted = {}
--     local root_indent = #block.items[1].indent
--     for i, item in ipairs(block.items) do
--         if item.text ~= nil then
--             local text = item.text
--             if text ~= "" then
--                 text = text:sub(math.min(root_indent + 1, #text + 1))
--             end
--             inserted[#inserted + 1] = text
--         else
--             local task_text = item.body ~= "" and (" — " .. item.body) or ""
--             inserted[#inserted + 1] = string.format("- [%s] [[%s]]%s", item.state, source_link, task_text)
--         end
--     end
--
--     local insert_at = section_end - 1
--     while insert_at > heading and lines[insert_at] == "" do
--         insert_at = insert_at - 1
--     end
--     local payload = {}
--     for _, line in ipairs(inserted) do
--         payload[#payload + 1] = line
--     end
--     vim.api.nvim_buf_set_lines(buf, insert_at, insert_at, false, payload)
-- end


local function append_task_block(buf, block, source_link)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local inserted = {}
    local root_indent = #block.items[1].indent

    for _, item in ipairs(block.items) do
        if item.text ~= nil then
            local text = item.text
            if text ~= "" then
                text = text:sub(math.min(root_indent + 1, #text + 1))
            end
            inserted[#inserted + 1] = text
        else
            local task_text = item.body ~= "" and (" — " .. item.body) or ""
            inserted[#inserted + 1] =
                string.format("- [%s] [[%s]]%s", item.state, source_link, task_text)
        end
    end

    local title_heading
    for i, line in ipairs(lines) do
        if line:match("^#%s+") then
            title_heading = i
            break
        end
    end

    local section_end = #lines + 1
    if title_heading then
        for i = title_heading + 1, #lines do
            if lines[i]:match("^#+%s+") then
                section_end = i
                break
            end
        end
    end

    local insert_at = section_end - 1
    while insert_at > (title_heading or 0) and lines[insert_at] == "" do
        insert_at = insert_at - 1
    end

    vim.api.nvim_buf_set_lines(buf, insert_at, insert_at, false, inserted)
end

local function shortest_alias(path)
    local lines = vim.fn.readfile(path)
    if lines[1] ~= "---" then
        return nil
    end

    local in_aliases = false
    local shortest

    for i = 2, #lines do
        local line = lines[i]
        if line == "---" then
            break
        elseif line:match("^aliases:%s*$") then
            in_aliases = true
        elseif in_aliases then
            local alias = line:match("^%s+%-%s*(.-)%s*$")
            if alias and alias ~= "" then
                if not shortest or vim.fn.strchars(alias) < vim.fn.strchars(shortest) then
                    shortest = alias
                end
            elseif not line:match("^%s") then
                in_aliases = false
            end
        end
    end

    return shortest
end

local function move_task(opts, offset)
    local source_buf = vim.api.nvim_get_current_buf()
    local source_path = vim.api.nvim_buf_get_name(source_buf)
    if source_path == "" or not source_path:match("%.md$") or not is_within(source_path, opts.vault) then
        return notify("Open a Markdown note inside your Obsidian vault first.", vim.log.levels.WARN)
    end

    local relative = vim.fs.relpath(opts.vault, source_path)
    if relative:sub(1, #opts.daily_folder + 1) == opts.daily_folder .. "/" then
        return notify("Move tasks from their project note, not from a daily note.", vim.log.levels.WARN)
    end

    local row = vim.api.nvim_win_get_cursor(0)[1]
    local block, err = task_block(source_buf, row)
    if not block then
        return notify(err, vim.log.levels.WARN)
    end

    local date = date_for_offset(offset)
    local destination = vim.fs.joinpath(opts.vault, opts.daily_folder, date .. ".md")
    local daily_buf, daily_err = get_daily_buffer(destination, date, opts.template)
    if not daily_buf then
        return notify(daily_err, vim.log.levels.ERROR)
    end

    local source_link = relative:gsub("\\", "/"):gsub("%.md$", "")
    local alias = shortest_alias(source_path)
    local note_name = vim.fn.fnamemodify(source_path, ":t:r")

    if alias and alias ~= note_name then
        source_link = source_link .. "|" .. alias
    end
    append_task_block(daily_buf, block, source_link)
    local daily_ok = vim.api.nvim_buf_call(daily_buf, function()
        return pcall(vim.cmd, "write")
    end)
    if not daily_ok then
        return notify("Could not save the daily note; the project task was left in place.", vim.log.levels.ERROR)
    end

    vim.api.nvim_buf_set_lines(source_buf, block.first - 1, block.last, false, {})
    local source_ok = vim.api.nvim_buf_call(source_buf, function()
        return pcall(vim.cmd, "write")
    end)
    if not source_ok then
        return notify(
            "Task was added to the daily note, but saving the project note failed. Please remove the source task manually.",
            vim.log.levels.ERROR)
    end

    notify("Moved task to " .. date .. " and linked it back to [[" .. source_link .. "]].")
end

function M.setup(opts)
    vim.api.nvim_create_user_command("NotesMoveTaskToday", function()
        move_task(opts, 0)
    end, { desc = "Move task under cursor to today's daily note" })

    vim.api.nvim_create_user_command("NotesMoveTaskTomorrow", function()
        move_task(opts, 1)
    end, { desc = "Move task under cursor to tomorrow's daily note" })
end

return M
