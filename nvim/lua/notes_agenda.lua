local M = {}

local agenda_ns = vim.api.nvim_create_namespace("notes-agenda-entries")
local agendas = {}
local calendar_buf
local calendar_win
local calendar_state

local function notify(message, level)
    vim.notify(message, level or vim.log.levels.INFO, { title = "Notes" })
end

local function date_for_offset(offset)
    local today = os.date("*t")
    local time = os.time({ year = today.year, month = today.month, day = today.day + offset, hour = 12 })
    return os.date("%Y-%m-%d", time)
end

local function valid_date(date)
    if not date or not date:match("^%d%d%d%d%-%d%d%-%d%d$") then
        return false
    end
    local year, month, day = date:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
    local stamp = os.time({ year = tonumber(year), month = tonumber(month), day = tonumber(day), hour = 12 })
    return os.date("%Y-%m-%d", stamp) == date
end

local function trim(text)
    return (text:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function parse_task(line)
    local before, state, after, body = line:match("^(%s*[-+*]%s+%[)([^%]])(%]%s*)(.*)$")
    if not before then
        return nil
    end
    return { before = before, state = state, after = after, body = body }
end

local function dates_in(body)
    local scheduled = body:match("⏳%s*(%d%d%d%d%-%d%d%-%d%d)")
    local done = body:match("✅%s*(%d%d%d%d%-%d%d%-%d%d)")
    return scheduled, done
end

local function remove_date(body, marker)
    body = body:gsub(marker .. "%s*%d%d%d%d%-%d%d%-%d%d", "")
    return trim(body)
end

local function set_date(body, marker, date)
    body = remove_date(body, marker)
    if body == "" then
        return marker .. " " .. date
    end
    return body .. " " .. marker .. " " .. date
end

local function replace_task_status(line, state, today)
    local task = parse_task(line)
    if not task then
        return nil
    end
    local body = task.body
    if state == "x" then
        local _, done_date = dates_in(body)
        if not done_date then
            body = set_date(body, "✅", today)
        end
    else
        body = remove_date(body, "✅")
    end
    return task.before .. state .. task.after .. body
end

local function path_is_hidden(path, root)
    local relative = vim.fs.relpath(root, path):gsub("\\", "/")
    return relative:match("^%.obsidian/") ~= nil
end

local function markdown_paths(root)
    local paths = {}
    local seen = {}
    local candidates = vim.fn.globpath(root, "*.md", false, true)
    vim.list_extend(candidates, vim.fn.globpath(root, "**/*.md", false, true))
    for _, path in ipairs(candidates) do
        path = vim.fs.normalize(path)
        if not seen[path] and not path_is_hidden(path, root) then
            seen[path] = true
            paths[#paths + 1] = path
        end
    end
    table.sort(paths)
    return paths
end

local function get_buffer_for_path(path)
    local buf = vim.fn.bufnr(path)
    if buf == -1 then
        buf = vim.fn.bufadd(path)
    end
    if not vim.api.nvim_buf_is_loaded(buf) then
        vim.fn.bufload(buf)
    end
    return buf
end

local function lines_for_path(path)
    local buf = vim.fn.bufnr(path)
    if buf ~= -1 and vim.api.nvim_buf_is_loaded(buf) then
        return vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    end
    return vim.fn.readfile(path)
end

local function collect_tasks(opts, date)
    local results = { agenda = {}, overdue = {}, done = {} }
    local today = os.date("%Y-%m-%d")

    for _, path in ipairs(markdown_paths(opts.vault)) do
        local lines = lines_for_path(path)
        local filename = vim.fn.fnamemodify(path, ":t:r")
        for lnum, line in ipairs(lines) do
            local task = parse_task(line)
            if task then
                local scheduled, done_date = dates_in(task.body)
                local is_open = task.state ~= "x" and task.state ~= "-"
                local section
                if is_open and scheduled == date then
                    section = "agenda"
                elseif is_open and scheduled and scheduled < today then
                    section = "overdue"
                elseif task.state == "x" and done_date == date then
                    section = "done"
                end

                if section then
                    results[section][#results[section] + 1] = {
                        path = path,
                        lnum = lnum,
                        filename = filename,
                        source_line = line,
                        source_state = task.state,
                        line = line,
                    }
                end
            end
        end
    end

    for _, tasks in pairs(results) do
        table.sort(tasks, function(a, b)
            if a.filename == b.filename then
                if a.path == b.path then
                    return a.lnum < b.lnum
                end
                return a.path < b.path
            end
            return a.filename:lower() < b.filename:lower()
        end)
    end
    return results
end

local function append_section(lines, entries, title)
    if #lines > 0 and lines[#lines] ~= "" then
        lines[#lines + 1] = ""
    end
    lines[#lines + 1] = "## " .. title
    lines[#lines + 1] = ""
    if #entries == 0 then
        lines[#lines + 1] = "_No tasks._"
        return
    end

    local current_file
    for _, entry in ipairs(entries) do
        if entry.filename ~= current_file then
            if #lines > 0 and lines[#lines] ~= "" then
                lines[#lines + 1] = ""
            end
            current_file = entry.filename
            lines[#lines + 1] = "### " .. current_file
            lines[#lines + 1] = ""
        end
        entry.agenda_row = #lines + 1
        lines[#lines + 1] = entry.line
    end
end

local function refresh_agenda(buf, opts, date)
    local matches = collect_tasks(opts, date)
    local lines = { "" }
    append_section(lines, matches.agenda, "📅 Agenda")
    append_section(lines, matches.overdue, "⏰ Overdue")
    append_section(lines, matches.done, "✅ Completed")

    vim.api.nvim_buf_clear_namespace(buf, agenda_ns, 0, -1)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    local entries = {}
    local task_rows = {}
    for _, group in ipairs({ matches.agenda, matches.overdue, matches.done }) do
        for _, entry in ipairs(group) do
            local row = entry.agenda_row - 1
            task_rows[row] = true
            entries[#entries + 1] = entry
        end
    end
    local fixed_lines = {}
    for row, line in ipairs(lines) do
        if not task_rows[row - 1] then
            fixed_lines[row - 1] = line
        end
    end
    agendas[buf] = { date = date, opts = opts, entries = entries, line_count = #lines, fixed_lines = fixed_lines }
    vim.bo[buf].modified = false
end

local function refresh_open_agendas(current_buf)
    local skipped = 0
    for agenda_buf, state in pairs(agendas) do
        if not vim.api.nvim_buf_is_valid(agenda_buf) then
            agendas[agenda_buf] = nil
        elseif agenda_buf ~= current_buf and vim.bo[agenda_buf].modified then
            skipped = skipped + 1
        else
            if not vim.api.nvim_buf_is_loaded(agenda_buf) then
                vim.fn.bufload(agenda_buf)
            end
            refresh_agenda(agenda_buf, state.opts, state.date)
        end
    end
    return skipped
end

local function jump_to_source_task()
    local agenda_buf = vim.api.nvim_get_current_buf()
    local state = agendas[agenda_buf]
    if not state then
        return notify("Run this from an Agenda buffer.", vim.log.levels.WARN)
    end

    local row = vim.api.nvim_win_get_cursor(0)[1] - 1
    local current_line = vim.api.nvim_buf_get_lines(agenda_buf, row, row + 1, false)[1] or ""
    local filename_heading = current_line:match("^###%s+(.+)$")
    local entry
    for _, candidate in ipairs(state.entries) do
        if (filename_heading and candidate.filename == filename_heading)
            or (not filename_heading and candidate.agenda_row - 1 == row)
        then
            entry = candidate
            break
        end
    end
    if not entry then
        return notify("Place the cursor on a task or file heading in the agenda.", vim.log.levels.WARN)
    end

    local source_buf = get_buffer_for_path(entry.path)
    local source_lines = vim.api.nvim_buf_get_lines(source_buf, 0, -1, false)
    local target_lnum = entry.lnum
    if source_lines[target_lnum] ~= entry.source_line then
        local nearest_lnum
        local nearest_distance
        for lnum, line in ipairs(source_lines) do
            if line == entry.source_line then
                local distance = math.abs(lnum - entry.lnum)
                if not nearest_distance or distance < nearest_distance then
                    nearest_lnum = lnum
                    nearest_distance = distance
                end
            end
        end
        target_lnum = nearest_lnum or math.max(1, math.min(entry.lnum, #source_lines))
    end

    vim.bo[source_buf].buflisted = true
    vim.api.nvim_set_current_buf(source_buf)
    vim.api.nvim_win_set_cursor(0, { target_lnum, 0 })
    vim.cmd.normal({ args = { "zz" }, bang = true })
end

local function apply_source_edits(buf, state)
    local pending = {}
    local conflicts = {}
    local mapped_rows = {}

    if vim.api.nvim_buf_line_count(buf) ~= state.line_count then
        conflicts[#conflicts + 1] = "Agenda layout changed; restore its section and blank lines before saving"
    else
        for row, expected in pairs(state.fixed_lines) do
            local current = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
            if current ~= expected then
                conflicts[#conflicts + 1] = "Agenda layout changed; restore its section headings before saving"
                break
            end
        end
    end
    if #conflicts > 0 then
        notify("Agenda not saved; resolve these conflicts first:\n" .. table.concat(conflicts, "\n"), vim.log.levels.ERROR)
        return false
    end

    for _, entry in ipairs(state.entries) do
        local row = entry.agenda_row - 1
        if mapped_rows[row] then
            conflicts[#conflicts + 1] = entry.path .. ": multiple source tasks mapped to the same agenda line"
        else
            mapped_rows[row] = true
            local current = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
            local task = parse_task(current or "")
            if not task then
                conflicts[#conflicts + 1] = entry.path .. ": an agenda task line is no longer a task"
            else
                local source_buf = get_buffer_for_path(entry.path)
                local source_line = vim.api.nvim_buf_get_lines(source_buf, entry.lnum - 1, entry.lnum, false)[1]
                if source_line ~= entry.source_line then
                    conflicts[#conflicts + 1] = string.format("%s:%d changed since the agenda was opened", entry.path, entry.lnum)
                else
                    local source_task = parse_task(entry.source_line)
                    local body = task.body
                    if task.state == "x" and source_task and source_task.state ~= "x" then
                        local _, done_date = dates_in(body)
                        if not done_date then
                            body = set_date(body, "✅", date_for_offset(0))
                        end
                    elseif task.state ~= "x" and source_task and source_task.state == "x" then
                        body = remove_date(body, "✅")
                    end

                    local replacement = source_task.before .. task.state .. source_task.after .. body
                    pending[#pending + 1] = {
                        entry = entry,
                        buf = source_buf,
                        line_index = entry.lnum - 1,
                        original = source_line,
                        replacement = replacement,
                    }
                end
            end
        end
    end

    if #conflicts > 0 then
        notify("Agenda not saved; resolve these conflicts first:\n" .. table.concat(conflicts, "\n"), vim.log.levels.ERROR)
        return false
    end

    local changed_buffers = {}
    for _, item in ipairs(pending) do
        if item.original ~= item.replacement then
            vim.api.nvim_buf_set_lines(item.buf, item.line_index, item.line_index + 1, false, { item.replacement })
            item.entry.source_line = item.replacement
            item.entry.source_state = item.replacement:match("%[([^%]])%]")
            changed_buffers[item.buf] = true
        end
    end

    local written = 0
    for source_buf in pairs(changed_buffers) do
        local ok, err = pcall(vim.api.nvim_buf_call, source_buf, function()
            vim.cmd.write()
        end)
        if not ok then
            notify("Could not save a source note: " .. tostring(err), vim.log.levels.ERROR)
            return false
        end
        written = written + 1
    end

    local skipped = refresh_open_agendas(buf)
    notify(string.format("Agenda saved (%d source note%s updated).", written, written == 1 and "" or "s"))
    if skipped > 0 then
        notify(string.format("Skipped refreshing %d other Agenda buffer%s with unsaved edits.", skipped, skipped == 1 and "" or "s"), vim.log.levels.WARN)
    end
    return true
end

local function agenda_command(opts, date)
    date = date or os.date("%Y-%m-%d")
    if not valid_date(date) then
        return notify("Use a date in YYYY-MM-DD format.", vim.log.levels.ERROR)
    end

    local name = "NotesAgenda://" .. date
    local existing = vim.fn.bufnr(name)
    local buf
    if existing ~= -1 and vim.api.nvim_buf_is_valid(existing) then
        buf = existing
        if agendas[buf] and vim.bo[buf].modified then
            vim.api.nvim_set_current_buf(buf)
            return
        end
        if not vim.api.nvim_buf_is_loaded(buf) then
            vim.bo[buf].buftype = "acwrite"
            vim.fn.bufload(buf)
        end
    else
        buf = vim.api.nvim_create_buf(true, false)
        vim.api.nvim_buf_set_name(buf, name)
    end

    vim.bo[buf].buftype = "acwrite"
    vim.bo[buf].bufhidden = "hide"
    vim.bo[buf].buflisted = true
    vim.bo[buf].swapfile = false
    vim.bo[buf].filetype = "markdown"
    vim.bo[buf].modifiable = true
    refresh_agenda(buf, opts, date)

    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true, desc = "Close agenda" })
    vim.keymap.set("n", "gd", jump_to_source_task, { buffer = buf, silent = true, desc = "Go to task source" })
    vim.api.nvim_set_current_buf(buf)
end

local function current_agenda_entry()
    local buf = vim.api.nvim_get_current_buf()
    local state = agendas[buf]
    if not state then
        notify("Run this command from an Agenda buffer.", vim.log.levels.WARN)
        return nil
    end
    local row = vim.api.nvim_win_get_cursor(0)[1] - 1
    for _, entry in ipairs(state.entries) do
        if entry.agenda_row - 1 == row then
            return entry, row, buf, state
        end
    end
    notify("Place the cursor on a task in the agenda.", vim.log.levels.WARN)
    return nil
end

local function complete_task()
    local entry, row, buf = current_agenda_entry()
    if not entry then
        return
    end
    local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
    local updated = replace_task_status(line, "x", date_for_offset(0))
    if updated then
        vim.api.nvim_buf_set_lines(buf, row, row + 1, false, { updated })
        vim.bo[buf].modified = true
    end
end

local function complete_current_task()
    local buf = vim.api.nvim_get_current_buf()
    local row
    local entry
    if agendas[buf] then
        entry, row, buf = current_agenda_entry()
        if not entry then
            return
        end
    else
        row = vim.api.nvim_win_get_cursor(0)[1] - 1
    end
    local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
    local task = parse_task(line or "")
    if not task then
        return notify("Place the cursor on a task.", vim.log.levels.WARN)
    end
    local next_state = task.state == "x" and " " or "x"
    local updated = replace_task_status(line, next_state, date_for_offset(0))
    if updated then
        vim.api.nvim_buf_set_lines(buf, row, row + 1, false, { updated })
        vim.bo[buf].modified = true
    end
end

local function schedule_task(date_arg)
    local buf = vim.api.nvim_get_current_buf()
    local row
    local state = agendas[buf]
    local agenda_entry
    if state then
        agenda_entry, row, buf = current_agenda_entry()
        if not agenda_entry then
            return
        end
    else
        row = vim.api.nvim_win_get_cursor(0)[1] - 1
    end

    local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
    local task = parse_task(line)
    if not task then
        return notify("Place the cursor on a task.", vim.log.levels.WARN)
    end
    local scheduled = dates_in(task.body)
    local function apply_schedule(input)
        if not input then
            return
        end
        input = trim(input)
        local fresh = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
        local parsed = parse_task(fresh)
        if not parsed then
            return notify("The task line changed before scheduling.", vim.log.levels.ERROR)
        end
        local body
        if input == "" then
            body = remove_date(parsed.body, "⏳")
        else
            if not valid_date(input) then
                return notify("Use a valid date in YYYY-MM-DD format, or leave it empty to clear.", vim.log.levels.ERROR)
            end
            body = set_date(parsed.body, "⏳", input)
        end
        local replacement = parsed.before .. parsed.state .. parsed.after .. body
        vim.api.nvim_buf_set_lines(buf, row, row + 1, false, { replacement })
        vim.bo[buf].modified = true
    end

    if date_arg and date_arg ~= "" then
        apply_schedule(date_arg)
    else
        local default_date = scheduled or (state and state.date) or os.date("%Y-%m-%d")
        vim.ui.input({ prompt = "Schedule for (YYYY-MM-DD): ", default = default_date }, apply_schedule)
    end
end

local function days_in_month(year, month)
    local next_month = os.time({ year = year, month = month + 1, day = 1, hour = 12 })
    return tonumber(os.date("%d", next_month - 86400))
end

local function calendar_render()
    if not calendar_buf or not vim.api.nvim_buf_is_valid(calendar_buf) then
        return
    end
    local selected = calendar_state.selected
    local year, month, day = selected:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
    year, month, day = tonumber(year), tonumber(month), tonumber(day)
    local first = os.time({ year = year, month = month, day = 1, hour = 12 })
    local sunday_zero = tonumber(os.date("%w", first))
    local offset = (sunday_zero + 6) % 7
    local month_names = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
    local lines = {
        string.format("%s %d", month_names[month], year),
        "h/l day   j/k week",
        "[/] month   Enter open   q close",
        "Mo Tu We Th Fr Sa Su",
    }
    local highlights = {}
    local days = days_in_month(year, month)
    for week = 0, 5 do
        local cells = {}
        for weekday = 0, 6 do
            local index = week * 7 + weekday
            local current_day = index - offset + 1
            if current_day >= 1 and current_day <= days then
                cells[#cells + 1] = string.format("%2d", current_day)
                if current_day == day then
                    highlights[#highlights + 1] = { row = #lines, col = weekday * 3, len = 2, group = "Visual" }
                elseif string.format("%04d-%02d-%02d", year, month, current_day) == os.date("%Y-%m-%d") then
                    highlights[#highlights + 1] = { row = #lines, col = weekday * 3, len = 2, group = "DiagnosticInfo" }
                end
            else
                cells[#cells + 1] = "  "
            end
        end
        lines[#lines + 1] = table.concat(cells, " ")
    end

    vim.bo[calendar_buf].modifiable = true
    vim.api.nvim_buf_set_lines(calendar_buf, 0, -1, false, lines)
    vim.bo[calendar_buf].modifiable = false
    vim.api.nvim_buf_clear_namespace(calendar_buf, agenda_ns, 0, -1)
    for _, item in ipairs(highlights) do
        vim.api.nvim_buf_add_highlight(calendar_buf, agenda_ns, item.group, item.row, item.col, item.col + item.len)
    end
    if calendar_win and vim.api.nvim_win_is_valid(calendar_win) then
        local row = 4 + math.floor((day + offset - 1) / 7)
        local col = ((day + offset - 1) % 7) * 3
        vim.api.nvim_win_set_cursor(calendar_win, { row + 1, col })
        vim.api.nvim_win_set_config(calendar_win, { title = "Calendar", title_pos = "center" })
    end
end

local function open_agenda_from_calendar(opts, date)
    if calendar_win and vim.api.nvim_win_is_valid(calendar_win) then
        vim.api.nvim_win_close(calendar_win, true)
    end
    calendar_win = nil
    calendar_buf = nil
    agenda_command(opts, date)
end

local function open_calendar(opts)
    calendar_state = { selected = os.date("%Y-%m-%d") }
    calendar_buf = vim.api.nvim_create_buf(false, true)
    vim.bo[calendar_buf].buftype = "nofile"
    vim.bo[calendar_buf].bufhidden = "wipe"
    vim.bo[calendar_buf].modifiable = false
    vim.bo[calendar_buf].filetype = "calendar"
    local width, height = 34, 10
    calendar_win = vim.api.nvim_open_win(calendar_buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.max(0, math.floor((vim.o.lines - height) / 2) - 1),
        col = math.max(0, math.floor((vim.o.columns - width) / 2)),
        style = "minimal",
        border = "rounded",
        title = "Calendar",
        title_pos = "center",
    })
    calendar_render()

    local function shift_day(amount)
        local y, m, d = calendar_state.selected:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
        local stamp = os.time({ year = tonumber(y), month = tonumber(m), day = tonumber(d) + amount, hour = 12 })
        calendar_state.selected = os.date("%Y-%m-%d", stamp)
        calendar_render()
    end
    local function shift_month(amount)
        local y, m, d = calendar_state.selected:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
        y, m, d = tonumber(y), tonumber(m), tonumber(d)
        local stamp = os.time({ year = y, month = m + amount, day = 1, hour = 12 })
        y, m = tonumber(os.date("%Y", stamp)), tonumber(os.date("%m", stamp))
        d = math.min(d, days_in_month(y, m))
        calendar_state.selected = string.format("%04d-%02d-%02d", y, m, d)
        calendar_render()
    end

    local mappings = {
        h = function() shift_day(-1) end,
        l = function() shift_day(1) end,
        k = function() shift_day(-7) end,
        j = function() shift_day(7) end,
        ["["] = function() shift_month(-1) end,
        ["]"] = function() shift_month(1) end,
        ["<CR>"] = function() open_agenda_from_calendar(opts, calendar_state.selected) end,
        q = function()
            if calendar_win and vim.api.nvim_win_is_valid(calendar_win) then
                vim.api.nvim_win_close(calendar_win, true)
            end
        end,
    }
    for key, callback in pairs(mappings) do
        vim.keymap.set("n", key, callback, { buffer = calendar_buf, silent = true })
    end
end

function M.setup(opts)
    local agenda_group = vim.api.nvim_create_augroup("NotesAgendaBuffers", { clear = true })
    vim.api.nvim_create_autocmd("BufWriteCmd", {
        group = agenda_group,
        pattern = "NotesAgenda://*",
        callback = function(event)
            local state = agendas[event.buf]
            if state then
                apply_source_edits(event.buf, state)
            else
                notify("Agenda state was lost; run :Agenda to rebuild this buffer before saving.", vim.log.levels.ERROR)
            end
        end,
    })
    vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
        group = agenda_group,
        pattern = "NotesAgenda://*",
        callback = function(event)
            agendas[event.buf] = nil
        end,
    })

    vim.api.nvim_create_user_command("Agenda", function(command)
        local arg = trim(command.args)
        local date
        if arg == "" then
            date = nil
        elseif arg:match("^[+-]%d+$") then
            date = date_for_offset(tonumber(arg))
        else
            date = arg
        end
        agenda_command(opts, date)
    end, { nargs = "?", complete = function() return {} end, desc = "Open an editable agenda" })
    vim.api.nvim_create_user_command("AgendaCompleteTask", complete_task, { desc = "Complete the agenda task under the cursor" })
    vim.api.nvim_create_user_command("NotesCompleteTask", complete_current_task, { desc = "Toggle task completion and date" })
    vim.api.nvim_create_user_command("AgendaScheduleTask", function(command)
        schedule_task(command.args)
    end, { nargs = "?", desc = "Schedule the agenda task under the cursor" })
    vim.api.nvim_create_user_command("NotesScheduleTask", function(command)
        schedule_task(command.args)
    end, { nargs = "?", desc = "Schedule the task under the cursor" })
    vim.api.nvim_create_user_command("Calendar", function()
        open_calendar(opts)
    end, { desc = "Open the daily-note calendar" })
end

return M
