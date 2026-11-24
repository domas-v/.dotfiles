-- Obsidian Tasks-compatible helpers: scheduled dates (⏳) and done dates (✅) on task lines.
local D = require("notes_date")

local M = {}

local SCHEDULED = "⏳"
local TASK_PATTERN = "^%s*[-+*]%s+%[.%]"
local DONE_PATTERN = "^%s*[-+*]%s+%[[xX-]%]"
local DONE = "✅"
local CANCELLED = "❌"

local DATE = "%d%d%d%d%-%d%d%-%d%d"

local function remove_field(line, emoji)
    return (line:gsub("%s*" .. emoji .. "%s*" .. DATE, ""))
end

--- Set "<emoji> <date>" on a line: replace in place if present, else append
--- (before a trailing block id like ^abc123, which Obsidian requires to be last).
local function set_field(line, emoji, date)
    local field = emoji .. " " .. date
    if line:match(emoji .. "%s*" .. DATE) then
        return (line:gsub(emoji .. "%s*" .. DATE, field, 1))
    end
    local body, block = line:match("^(.-)%s+(%^[%w-]+)%s*$")
    if body then
        return body .. " " .. field .. " " .. block
    end
    return (line:gsub("%s+$", "")) .. " " .. field
end

local function set_on_line(line, date)
    if not line:match(TASK_PATTERN) or line:match(DONE_PATTERN) then
        return nil
    end
    if date == false then
        return remove_field(line, SCHEDULED)
    end
    return set_field(line, SCHEDULED, date)
end

local function current_date(line)
    return line:match(SCHEDULED .. "%s*(" .. DATE .. ")")
end

--- Line range of the visual selection (leaving visual mode), or the cursor line.
local function cursor_range()
    local mode = vim.fn.mode()
    if mode == "v" or mode == "V" or mode == "\22" then
        local first, last = vim.fn.line("v"), vim.fn.line(".")
        if first > last then first, last = last, first end
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "nx", false)
        return first, last
    end
    local row = vim.fn.line(".")
    return row, row
end

--- Toggle a task like Obsidian Tasks: "[ ]" -> "[x] ... ✅ today", "[x]" -> "[ ]" without the ✅ date.
--- Lines that aren't tasks fall back to obsidian.nvim's toggle (e.g. turning a list item into a task).
function M.toggle(first, last)
    if not first then
        first, last = cursor_range()
    end
    local today_str = os.date("%Y-%m-%d")
    for lnum = first, last do
        local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1]
        local prefix, state, rest = line:match("^(%s*[-+*]%s+%[)(.)(%].*)$")
        if prefix then
            local new
            if state == "x" or state == "X" then
                new = remove_field(prefix .. " " .. rest, DONE)
            else
                new = set_field(remove_field(prefix .. "x" .. rest, CANCELLED), DONE, today_str)
            end
            vim.api.nvim_buf_set_lines(0, lnum - 1, lnum, false, { new })
        elseif line:match("%S") then
            local ok, actions = pcall(require, "obsidian.actions")
            if ok and Obsidian then
                actions._toggle_checkbox(Obsidian.opts.checkbox.order, lnum)
            end
        end
    end
end

--- Set (date string) or remove (false) the scheduled date on lines [first, last] of buf.
local function set_scheduled(buf, first, last, date)
    local lines = vim.api.nvim_buf_get_lines(buf, first - 1, last, false)
    local changed = 0
    for i, line in ipairs(lines) do
        local new = set_on_line(line, date)
        if new and new ~= line then
            lines[i] = new
            changed = changed + 1
        end
    end
    if changed == 0 then
        return
    end
    vim.api.nvim_buf_set_lines(buf, first - 1, last, false, lines)
    local msg = date and ("Scheduled " .. date) or "Removed scheduled date"
    if changed > 1 then
        msg = msg .. " (" .. changed .. " tasks)"
    end
    vim.notify(msg, vim.log.levels.INFO, { title = "Tasks" })
end

local function has_open_task(buf, first, last)
    for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, first - 1, last, false)) do
        if line:match(TASK_PATTERN) and not line:match(DONE_PATTERN) then
            return true
        end
    end
    vim.notify("No open task on " .. (first == last and "this line" or "these lines"), vim.log.levels.WARN, { title = "Tasks" })
    return false
end

--- Schedule lines [first, last] of the current buffer from org-style text input (see notes_date.parse).
function M.apply(first, last, input)
    local date = D.parse(input)
    if date == nil then
        vim.notify("Can't parse date: " .. input, vim.log.levels.WARN, { title = "Tasks" })
        return
    end
    if has_open_task(0, first, last) then
        set_scheduled(0, first, last, date and D.format(date))
    end
end

--- Open the date picker for task(s) on lines [first, last] of buf. on_done(date) runs after the
--- lines were updated (date is a date table, or false when the date was removed); not called on cancel.
function M.schedule_lines(buf, first, last, on_done)
    if not has_open_task(buf, first, last) then
        return
    end
    local existing = current_date(vim.api.nvim_buf_get_lines(buf, first - 1, first, false)[1] or "")
    local current = existing and D.parse(existing) or nil
    require("notes_datepicker").open({
        title = first == last and "Schedule" or ("Schedule " .. (last - first + 1) .. " lines"),
        default = current or D.today(),
        current = current,
        on_done = function(date)
            if vim.api.nvim_buf_is_valid(buf) then
                set_scheduled(buf, first, last, date and D.format(date))
                if on_done then
                    on_done(date)
                end
            end
        end,
    })
end

--- Open the date picker and schedule the task(s) in the given range (default: cursor line / selection).
function M.schedule(first, last)
    if not first then
        first, last = cursor_range()
    end
    M.schedule_lines(vim.api.nvim_get_current_buf(), first, last)
end

function M.setup()
    vim.api.nvim_create_user_command("TaskSchedule", function(args)
        if args.args ~= "" then
            M.apply(args.line1, args.line2, args.args)
        else
            M.schedule(args.line1, args.line2)
        end
    end, { range = true, nargs = "?", desc = "Set Obsidian Tasks scheduled date (⏳)" })
    vim.api.nvim_create_user_command("TaskToggle", function(args)
        M.toggle(args.line1, args.line2)
    end, { range = true, desc = "Toggle task done, adding/removing ✅ date" })
end

return M
