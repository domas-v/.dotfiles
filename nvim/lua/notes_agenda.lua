-- Notes agenda: this week's scheduled (⏳) / due (📅) tasks, inbox, and active projects.
local D = require("notes_date")

local M = {}

local ns = vim.api.nvim_create_namespace("notes_agenda")
local ACTIVE_TAG = "status/active"
local OPEN_TASK = "^%s*[-+*]%s+%[[^xX%-]%]"
local DATE = "(%d%d%d%d%-%d%d%-%d%d)"

local config

local function set_highlights()
    vim.api.nvim_set_hl(0, "NotesAgendaToday", { link = "Special", default = true })
    vim.api.nvim_set_hl(0, "NotesAgendaTodayBadge", { link = "IncSearch", default = true })
    vim.api.nvim_set_hl(0, "NotesAgendaMeta", { link = "Comment", default = true })
    vim.api.nvim_set_hl(0, "NotesAgendaOverdue", { link = "DiagnosticWarn", default = true })
end

local function frontmatter_tags(lines)
    local tags = {}
    if lines[1] ~= "---" then
        return tags, 0
    end
    local function add(tag)
        tag = vim.trim(tag):gsub("^[\"']", ""):gsub("[\"']$", ""):gsub("^#", "")
        if tag ~= "" then
            tags[tag:lower()] = true
        end
    end
    local in_tags = false
    for i = 2, #lines do
        local line = lines[i]
        if line == "---" then
            return tags, i
        end
        local inline = line:match("^tags:%s*(.*)$")
        if inline then
            in_tags = inline == ""
            for tag in inline:gsub("[%[%]]", ""):gmatch("[^,%s]+") do
                add(tag)
            end
        elseif in_tags and line:match("^%s+%-") then
            add(line:match("^%s+%-%s*(.*)$"))
        else
            in_tags = false
        end
    end
    return tags, 0
end

local function to_date(s)
    local y, m, d = (s or ""):match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
    return y and D.valid(tonumber(y), tonumber(m), tonumber(d)) or nil
end

--- Task text without the list marker, checkbox, date fields and block id.
local function clean(line)
    local text = line:gsub("^%s*[-+*]%s+", ""):gsub("^%[.%]%s*", "")
    for _, emoji in ipairs({ "⏳", "📅", "✅", "➕", "🛫", "❌" }) do
        text = text:gsub("%s*" .. emoji .. "%s*%d%d%d%d%-%d%d%-%d%d", "")
    end
    text = text:gsub("%s+%^[%w-]+%s*$", "")
    return vim.trim(text)
end

local function note_name(rel)
    return vim.fn.fnamemodify(rel, ":t:r")
end

local function by_location(a, b)
    if a.rel ~= b.rel then return a.rel < b.rel end
    return a.lnum < b.lnum
end

--- Active projects (frontmatter tag status/active) and all open tasks with a ⏳ or 📅 date.
local function scan()
    local active, tasks = {}, {}
    for name, kind in vim.fs.dir(config.vault, { depth = 10 }) do
        if kind == "file" and name:match("%.md$") and not name:match("^templates/") and not name:match("^%.") then
            local path = vim.fs.joinpath(config.vault, name)
            local ok, lines = pcall(vim.fn.readfile, path)
            if ok then
                local tags, body_start = frontmatter_tags(lines)
                if tags[ACTIVE_TAG] then
                    local title
                    for lnum = body_start + 1, #lines do
                        title = lines[lnum]:match("^#%s+(.+)$")
                        if title then break end
                    end
                    table.insert(active, { path = path, rel = name, lnum = 1, text = title or note_name(name) })
                end
                for lnum = body_start + 1, #lines do
                    local line = lines[lnum]
                    if line:match(OPEN_TASK) then
                        local scheduled = to_date(line:match("⏳%s*" .. DATE))
                        local due = to_date(line:match("📅%s*" .. DATE))
                        if scheduled or due then
                            table.insert(tasks, {
                                path = path, rel = name, lnum = lnum, text = clean(line), raw = line,
                                scheduled = scheduled, due = due,
                            })
                        end
                    end
                end
            end
        end
    end
    table.sort(active, by_location)
    table.sort(tasks, by_location)
    return active, tasks
end

local function inbox()
    local list = {}
    local ok, lines = pcall(vim.fn.readfile, config.inbox)
    if not ok then
        return list
    end
    local _, body_start = frontmatter_tags(lines)
    for lnum = body_start + 1, #lines do
        local line = lines[lnum]
        if line:match("^[-+*]%s+") and not line:match("^[-+*]%s+%[[xX%-]%]") then
            table.insert(list, { path = config.inbox, lnum = lnum, text = clean(line), raw = line })
        end
    end
    return list
end

local function ago(days)
    return days == 1 and "yesterday" or (days .. " days ago")
end

--- Tasks scheduled or due on `day`. Today also collects everything overdue from before this week
--- (earlier days of this week show their own leftovers).
local function day_entries(tasks, day, today, week_start)
    local entries = {}
    local is_today = D.equal(day, today)
    for _, task in ipairs(tasks) do
        for _, field in ipairs({ "scheduled", "due" }) do
            local date = task[field]
            local same_as_scheduled = field == "due" and D.equal(date, task.scheduled)
            if date and not same_as_scheduled then
                local on_day = D.equal(date, day)
                local overdue = is_today and D.ordinal(date) < D.ordinal(week_start)
                if on_day or overdue then
                    local label
                    if overdue then
                        label = (field == "due" and "due " or "scheduled ") .. ago(D.days_between(date, today))
                    elseif field == "due" then
                        label = "due"
                    end
                    table.insert(entries, vim.tbl_extend("force", task, { label = label, overdue = overdue }))
                end
            end
        end
    end
    -- overdue first, then the day's own items
    table.sort(entries, function(a, b)
        if a.overdue ~= b.overdue then return a.overdue end
        return by_location(a, b)
    end)
    return entries
end

--- Headings whose folds are closed in any window showing buf.
local function closed_headings(buf)
    local closed = {}
    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
        vim.api.nvim_win_call(win, function()
            for row, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
                if line:match("^##+ ") and vim.fn.foldclosed(row) == row then
                    closed[line] = true
                end
            end
        end)
    end
    return closed
end

local function restore_folds(buf, closed)
    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
        vim.api.nvim_win_call(win, function()
            vim.cmd("normal! zR")
            for row, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
                if closed[line] then
                    pcall(vim.cmd, row .. "foldclose")
                end
            end
        end)
    end
end

function M.foldexpr(lnum)
    local line = vim.fn.getline(lnum)
    if line:match("^### ") then return ">2" end
    if line:match("^## ") then return ">1" end
    if line:match("^# ") then return "0" end
    return "="
end

function M.foldtext()
    local count = 0
    for lnum = vim.v.foldstart + 1, vim.v.foldend do
        if vim.fn.getline(lnum):match("^%- ") then
            count = count + 1
        end
    end
    return {
        { vim.fn.getline(vim.v.foldstart), "Title" },
        { "  " .. count .. (count == 1 and " item" or " items"), "NotesAgendaMeta" },
    }
end

local FOLDEXPR = "v:lua.require'notes_agenda'.foldexpr(v:lnum)"

local function setup_window(win)
    if vim.wo[win].foldexpr == FOLDEXPR then
        return -- already set up; keep the user's open/closed folds
    end
    local function set(name, value)
        vim.api.nvim_set_option_value(name, value, { win = win, scope = "local" })
    end
    set("foldmethod", "expr")
    set("foldexpr", FOLDEXPR)
    set("foldtext", "v:lua.require'notes_agenda'.foldtext()")
    set("foldenable", true)
    set("foldlevel", 99)
end

-- closed headings saved when leaving the agenda (expr folds are recomputed on return)
local saved_closed = {}

local function render(buf, closed)
    set_highlights()
    closed = closed or closed_headings(buf)
    local active, tasks = scan()
    local today = D.today()
    local week_start = D.add_days(today, 1 - D.weekday(today))

    local lines, targets, marks = { "# Agenda" }, {}, {}
    local today_row
    local function add(line, entry)
        table.insert(lines, line)
        if entry then
            targets[#lines] = entry
        end
    end

    add("")
    add(string.format("## Week %s · %s – %s", D.format(today, "%V"),
        D.format(week_start, "%d %b"), D.format(D.add_days(week_start, 6), "%d %b")))
    for i = 0, 6 do
        local day = D.add_days(week_start, i)
        local is_today = D.equal(day, today)
        local entries = day_entries(tasks, day, today, week_start)
        if is_today or #entries > 0 then
            add("")
            add("### " .. D.format(day, "%a %d %b"))
            if is_today then
                today_row = #lines
            end
            add("")
            if #entries == 0 then
                add("_nothing scheduled_")
            end
            for _, entry in ipairs(entries) do
                add("- " .. entry.text, entry)
                local meta = { { "  " .. note_name(entry.rel), "NotesAgendaMeta" } }
                if entry.label then
                    table.insert(meta, { " · " .. entry.label, entry.overdue and "NotesAgendaOverdue" or "NotesAgendaMeta" })
                end
                table.insert(marks, { row = #lines, virt_text = meta })
            end
        end
    end

    add("")
    add("## Inbox")
    add("")
    local inbox_list = inbox()
    if #inbox_list == 0 then
        add("_nothing_")
    end
    for _, entry in ipairs(inbox_list) do
        add("- " .. entry.text, entry)
    end

    add("")
    add("## Active projects")
    add("")
    if #active == 0 then
        add("_nothing_")
    end
    for _, entry in ipairs(active) do
        add("- " .. entry.text, entry)
    end

    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.b[buf].agenda_targets = targets
    restore_folds(buf, closed)

    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    for _, mark in ipairs(marks) do
        vim.api.nvim_buf_set_extmark(buf, ns, mark.row - 1, 0, { virt_text = mark.virt_text, virt_text_pos = "eol" })
    end
    if today_row then
        vim.api.nvim_buf_set_extmark(buf, ns, today_row - 1, 0, {
            end_col = #lines[today_row],
            hl_group = "NotesAgendaToday",
            priority = 5000,
            virt_text = { { "  " }, { " TODAY ", "NotesAgendaTodayBadge" } },
            virt_text_pos = "eol",
        })
    end
    return today_row
end

local function jump(buf)
    local entry = vim.b[buf].agenda_targets[vim.api.nvim_win_get_cursor(0)[1]]
    if not entry then
        return
    end
    vim.cmd.edit(vim.fn.fnameescape(entry.path))
    vim.api.nvim_win_set_cursor(0, { entry.lnum, 0 })
    vim.cmd("normal! zv")
end

--- Schedule the task under the cursor in its source file, save it, and refresh.
local function schedule(buf)
    local entry = vim.b[buf].agenda_targets[vim.api.nvim_win_get_cursor(0)[1]]
    if not entry or not entry.raw then
        vim.notify("No task on this line", vim.log.levels.WARN, { title = "Agenda" })
        return
    end
    local src = vim.fn.bufadd(entry.path)
    vim.fn.bufload(src)
    if vim.api.nvim_buf_get_lines(src, entry.lnum - 1, entry.lnum, false)[1] ~= entry.raw then
        vim.notify("Task changed since the agenda was built; refreshed", vim.log.levels.WARN, { title = "Agenda" })
        render(buf)
        return
    end
    local had_changes = vim.bo[src].modified
    require("notes_tasks").schedule_lines(src, entry.lnum, entry.lnum, function()
        if had_changes then
            vim.notify(note_name(entry.path) .. " has other unsaved changes; not written", vim.log.levels.WARN, { title = "Agenda" })
        else
            vim.api.nvim_buf_call(src, function() vim.cmd("silent write") end)
        end
        if vim.api.nvim_buf_is_valid(buf) then
            render(buf)
        end
    end)
end

function M.open()
    local buf = vim.fn.bufnr("notes://agenda")
    -- bdelete (e.g. Snacks.bufdelete) leaves an unloaded buffer without its maps and filetype
    if buf ~= -1 and not vim.api.nvim_buf_is_loaded(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
        buf = -1
    end
    if buf == -1 then
        buf = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_buf_set_name(buf, "notes://agenda")
        vim.bo[buf].bufhidden = "hide"
        vim.bo[buf].filetype = "markdown"
        vim.keymap.set("n", "<cr>", function() jump(buf) end, { buffer = buf, desc = "Open agenda item" })
        vim.keymap.set("n", "r", function() render(buf) end, { buffer = buf, desc = "Refresh agenda" })
        vim.keymap.set("n", "q", "<cmd>bwipeout<cr>", { buffer = buf, desc = "Close agenda" })
        vim.keymap.set("n", "s", function() schedule(buf) end, { buffer = buf, desc = "Schedule task" })
        vim.keymap.set("n", "<Tab>", "za", { buffer = buf, desc = "Toggle fold" })
        -- ufo's zR/zM only handle ufo-managed buffers
        vim.keymap.set("n", "zR", "zR", { buffer = buf, noremap = true })
        vim.keymap.set("n", "zM", "zM", { buffer = buf, noremap = true })
        vim.api.nvim_create_autocmd("BufWinEnter", {
            buffer = buf,
            callback = function()
                -- other BufWinEnter handlers (e.g. loadview) can reset the window's fold options
                setup_window(vim.api.nvim_get_current_win())
                restore_folds(buf, saved_closed[buf] or {})
            end,
        })
        -- refresh when coming back after editing a task, keeping folded sections folded
        vim.api.nvim_create_autocmd("BufLeave", {
            buffer = buf,
            callback = function() saved_closed[buf] = closed_headings(buf) end,
        })
        vim.api.nvim_create_autocmd("BufEnter", {
            buffer = buf,
            callback = function() render(buf, saved_closed[buf]) end,
        })
    end
    local today_row = render(buf)
    vim.api.nvim_win_set_buf(0, buf)
    if today_row then
        vim.api.nvim_win_set_cursor(0, { today_row, 0 })
    end
end

function M.setup(opts)
    config = opts
    vim.api.nvim_create_user_command("Agenda", M.open, { desc = "Open notes agenda" })
end

return M
