-- Org-mode style date picker: a text prompt with live natural-language parsing,
-- plus a three-month calendar that follows the input and can be navigated directly.
--
--   require("notes_datepicker").open({
--       default = date,          -- initial selection and base for "++N" (default: today)
--       current = date,          -- date to mark as the existing value (optional)
--       title = "Schedule",
--       on_done = function(date) end,  -- date table, or false to remove the date; not called on cancel
--   })
local D = require("notes_date")

local M = {}

local ns = vim.api.nvim_create_namespace("notes_datepicker")

local MONTH_W, GAP, CAL_H = 20, 3, 8
local WIDTH = MONTH_W * 3 + GAP * 2
local MONTH_NAMES = { "January", "February", "March", "April", "May", "June", "July",
    "August", "September", "October", "November", "December" }

local function set_highlights()
    local function hl(name, opts)
        opts.default = true
        vim.api.nvim_set_hl(0, name, opts)
    end
    hl("NotesCalSelected", { link = "IncSearch" })
    hl("NotesCalToday", { link = "Special" })
    hl("NotesCalCurrent", { link = "DiagnosticUnderlineWarn" })
    hl("NotesCalMonth", { link = "Title" })
    hl("NotesCalHeader", { link = "Comment" })
    hl("NotesCalWeekend", { link = "Comment" })
    hl("NotesCalPreview", { link = "Comment" })
    hl("NotesCalError", { link = "DiagnosticError" })
end

local function put(line, col, text)
    return line:sub(1, col) .. text .. line:sub(col + #text + 1)
end

local function render(st)
    local sel = st.selected
    local today = D.today()
    local lines = {}
    for i = 1, CAL_H do
        lines[i] = string.rep(" ", WIDTH)
    end
    local marks = {}
    local function mark(row, col, len, group, priority)
        table.insert(marks, { row, col, col + len, group, priority or 100 })
    end

    st.cells, st.pos = {}, {}
    for k = -1, 1 do
        local first = D.add_months({ year = sel.year, month = sel.month, day = 1 }, k)
        local x = (k + 1) * (MONTH_W + GAP)
        local title = MONTH_NAMES[first.month] .. " " .. first.year
        local tx = x + math.floor((MONTH_W - #title) / 2)
        lines[1] = put(lines[1], tx, title)
        mark(1, tx, #title, "NotesCalMonth")
        lines[2] = put(lines[2], x, "Mo Tu We Th Fr Sa Su")
        mark(2, x, MONTH_W, "NotesCalHeader")

        local offset = D.weekday(first) - 1
        for day = 1, D.days_in_month(first.year, first.month) do
            local idx = offset + day - 1
            local row, col = 3 + math.floor(idx / 7), x + (idx % 7) * 3
            local date = { year = first.year, month = first.month, day = day }
            lines[row] = put(lines[row], col, string.format("%2d", day))
            local cell = { row = row, col = col, date = date }
            table.insert(st.cells, cell)
            st.pos[D.ordinal(date)] = cell
            if idx % 7 >= 5 then mark(row, col, 2, "NotesCalWeekend", 101) end
            if D.equal(date, today) then mark(row, col, 2, "NotesCalToday", 102) end
            if D.equal(date, st.current) then mark(row, col, 2, "NotesCalCurrent", 103) end
            if D.equal(date, sel) then mark(row, col, 2, "NotesCalSelected", 110) end
        end
    end

    local buf = st.cal_buf
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    for _, m in ipairs(marks) do
        vim.api.nvim_buf_set_extmark(buf, ns, m[1] - 1, m[2], { end_col = m[3], hl_group = m[4], priority = m[5] })
    end

    local cell = st.pos[D.ordinal(sel)]
    if cell and vim.api.nvim_win_is_valid(st.cal_win) then
        vim.api.nvim_win_set_cursor(st.cal_win, { cell.row, cell.col + 1 })
    end
end

local function describe(date)
    local diff = D.days_between(D.today(), date)
    local rel = diff == 0 and "today"
        or diff == 1 and "tomorrow"
        or diff == -1 and "yesterday"
        or diff > 0 and ("in " .. diff .. " days")
        or (-diff .. " days ago")
    return D.format(date, "%a %Y-%m-%d") .. " (" .. rel .. ")"
end

local function update_preview(st)
    local text, group
    if st.state == "invalid" then
        text, group = "?", "NotesCalError"
    elseif st.state == "clear" then
        text, group = "→ remove date", "NotesCalError"
    else
        text, group = "→ " .. describe(st.selected), "NotesCalPreview"
    end
    vim.api.nvim_buf_clear_namespace(st.input_buf, ns, 0, -1)
    vim.api.nvim_buf_set_extmark(st.input_buf, ns, 0, 0, {
        virt_text = { { text, group } },
        virt_text_pos = "right_align",
    })
end

local function input_text(st)
    return vim.api.nvim_buf_get_lines(st.input_buf, 0, 1, false)[1] or ""
end

--- Select a date from the calendar side: clears any typed text so the calendar wins.
local function select(st, date)
    st.selected = date
    st.state = "date"
    if input_text(st) ~= "" then
        vim.api.nvim_buf_set_lines(st.input_buf, 0, -1, false, { "" })
    end
    render(st)
    update_preview(st)
end

local function on_input(st)
    local text = input_text(st)
    if vim.trim(text) == "" then
        st.state = "date"
    else
        local parsed = D.parse(text, st.default)
        if parsed == nil then
            st.state = "invalid"
        elseif parsed == false then
            st.state = "clear"
        else
            st.state = "date"
            st.selected = parsed
            render(st)
        end
    end
    update_preview(st)
end

local function finish(st, result, restore)
    if st.closed then
        return
    end
    st.closed = true
    pcall(vim.api.nvim_del_augroup_by_id, st.group)
    for _, win in ipairs({ st.input_win, st.cal_win }) do
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end
    if restore ~= false and vim.api.nvim_win_is_valid(st.orig_win) then
        vim.api.nvim_set_current_win(st.orig_win)
    end
    vim.cmd.stopinsert()
    if result ~= nil and st.on_done then
        st.on_done(result)
    end
end

local function accept(st)
    -- TextChangedI doesn't fire while typeahead is pending ("tom<CR>" typed fast), so re-parse now
    if input_text(st) ~= "" then
        on_input(st)
    end
    if st.state == "invalid" then
        vim.notify("Can't parse date: " .. vim.trim(input_text(st)), vim.log.levels.WARN, { title = "Date" })
        return
    end
    finish(st, st.state == "clear" and false or st.selected)
end

local function focus_calendar(st)
    vim.cmd.stopinsert()
    vim.api.nvim_set_current_win(st.cal_win)
end

local function focus_input(st)
    vim.api.nvim_set_current_win(st.input_win)
    vim.cmd("startinsert!")
end

local function create_buf()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.b[buf].completion = false -- blink.cmp
    vim.b[buf].minipairs_disable = true
    return buf
end

local function set_keymaps(st)
    local function map(buf, modes, lhs, fn, desc)
        vim.keymap.set(modes, lhs, fn, { buffer = buf, nowait = true, desc = desc })
    end
    local function mover(fn)
        return function() select(st, fn(st.selected)) end
    end
    local moves = {
        { "<C-h>",       function(d) return D.add_days(d, -1) end },
        { "<C-l>",       function(d) return D.add_days(d, 1) end },
        { "<C-k>",       function(d) return D.add_days(d, -7) end },
        { "<C-j>",       function(d) return D.add_days(d, 7) end },
        { "<M-S-Left>",  function(d) return D.add_months(d, -1) end },
        { "<M-S-Right>", function(d) return D.add_months(d, 1) end },
        { "<M-S-Up>",    function(d) return D.add_months(d, -12) end },
        { "<M-S-Down>",  function(d) return D.add_months(d, 12) end },
    }
    local today = function() return D.today() end

    -- input prompt (org-read-date minibuffer keys)
    local ib = st.input_buf
    for _, m in ipairs(moves) do
        map(ib, { "i", "n" }, m[1], mover(m[2]))
    end
    map(ib, "i", "<lt>", mover(moves[5][2]), "Previous month")
    map(ib, "i", ">", mover(moves[6][2]), "Next month")
    -- org: "." jumps to today on an empty prompt, otherwise types a dot (24.12.)
    vim.keymap.set("i", ".", function()
        if input_text(st) ~= "" then
            return "."
        end
        vim.schedule(function() select(st, D.today()) end)
        return ""
    end, { buffer = ib, expr = true, nowait = true, desc = "Today" })
    map(ib, { "i", "n" }, "<CR>", function() accept(st) end, "Accept date")
    map(ib, { "i", "n" }, "<C-d>", function() finish(st, false) end, "Remove date")
    map(ib, { "i", "n" }, "<Tab>", function() focus_calendar(st) end, "Focus calendar")
    map(ib, { "i", "n" }, "<C-c>", function() finish(st) end, "Cancel")
    map(ib, "i", "<Esc>", function() finish(st) end, "Cancel")
    map(ib, "n", "<Esc>", function() finish(st) end, "Cancel")
    map(ib, "n", "q", function() finish(st) end, "Cancel")

    -- calendar
    local cb = st.cal_buf
    for _, m in ipairs(moves) do
        map(cb, "n", m[1], mover(m[2]))
    end
    local cal_moves = {
        { { "h", "<Left>" },  -1 },
        { { "l", "<Right>" }, 1 },
        { { "k", "<Up>" },    -7 },
        { { "j", "<Down>" },  7 },
    }
    for _, m in ipairs(cal_moves) do
        for _, lhs in ipairs(m[1]) do
            map(cb, "n", lhs, mover(function(d) return D.add_days(d, m[2]) end))
        end
    end
    for _, lhs in ipairs({ "H", "<lt>" }) do map(cb, "n", lhs, mover(moves[5][2]), "Previous month") end
    for _, lhs in ipairs({ "L", ">" }) do map(cb, "n", lhs, mover(moves[6][2]), "Next month") end
    map(cb, "n", "K", mover(moves[7][2]), "Previous year")
    map(cb, "n", "J", mover(moves[8][2]), "Next year")
    for _, lhs in ipairs({ "0", "^" }) do
        map(cb, "n", lhs, mover(function(d) return D.add_days(d, 1 - D.weekday(d)) end), "Start of week")
    end
    map(cb, "n", "$", mover(function(d) return D.add_days(d, 7 - D.weekday(d)) end), "End of week")
    for _, lhs in ipairs({ ".", "t" }) do map(cb, "n", lhs, mover(today), "Today") end
    for _, lhs in ipairs({ "<CR>", "<Space>", "<2-LeftMouse>" }) do
        map(cb, "n", lhs, function() accept(st) end, "Accept date")
    end
    map(cb, "n", "x", function() finish(st, false) end, "Remove date")
    for _, lhs in ipairs({ "<Tab>", "i", "a", "/" }) do
        map(cb, "n", lhs, function() focus_input(st) end, "Type a date")
    end
    for _, lhs in ipairs({ "q", "<Esc>", "<C-c>" }) do
        map(cb, "n", lhs, function() finish(st) end, "Cancel")
    end
end

local function set_autocmds(st)
    local group = vim.api.nvim_create_augroup("notes_datepicker_" .. st.input_buf, { clear = true })
    st.group = group
    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        group = group,
        buffer = st.input_buf,
        callback = function() on_input(st) end,
    })
    -- any motion (or mouse click) that lands on a day selects it; elsewhere snaps back
    vim.api.nvim_create_autocmd("CursorMoved", {
        group = group,
        buffer = st.cal_buf,
        callback = function()
            local row, col = unpack(vim.api.nvim_win_get_cursor(st.cal_win))
            for _, cell in ipairs(st.cells) do
                if cell.row == row and col >= cell.col and col <= cell.col + 2 then
                    if not D.equal(cell.date, st.selected) then
                        select(st, cell.date)
                    end
                    return
                end
            end
            render(st)
        end,
    })
    vim.api.nvim_create_autocmd("WinEnter", {
        group = group,
        callback = function()
            vim.schedule(function()
                if st.closed then
                    return
                end
                local win = vim.api.nvim_get_current_win()
                if win == st.cal_win then
                    vim.cmd.stopinsert()
                elseif win ~= st.input_win then
                    finish(st, nil, false) -- focus moved elsewhere: cancel
                end
            end)
        end,
    })
end

function M.open(opts)
    opts = opts or {}
    set_highlights()
    local default = opts.default or D.today()
    local st = {
        default = default,
        current = opts.current,
        selected = default,
        state = "date",
        on_done = opts.on_done,
        orig_win = vim.api.nvim_get_current_win(),
    }

    -- place below the cursor if there's room, otherwise above
    local total_h = 3 + CAL_H + 2
    -- screenpos() of the buffer cursor (screenrow() would report the cmdline when run from ":")
    local spos = vim.fn.screenpos(0, vim.fn.line("."), vim.fn.col("."))
    local srow, scol = spos.row, spos.col
    if srow == 0 then
        srow, scol = math.floor(vim.o.lines / 2), 1
    end
    local top = srow
    if vim.o.lines - vim.o.cmdheight - srow < total_h then
        top = math.max(0, srow - 1 - total_h)
    end
    local left = math.max(0, math.min(scol - 1, vim.o.columns - WIDTH - 2))

    st.input_buf, st.cal_buf = create_buf(), create_buf()
    st.input_win = vim.api.nvim_open_win(st.input_buf, true, {
        relative = "editor", row = top, col = left, width = WIDTH, height = 1,
        style = "minimal", border = "rounded", zindex = 60,
        title = " " .. (opts.title or "Date") .. " ", title_pos = "left",
        footer = " ⏎ accept  C-hjkl move  Tab calendar  C-d remove  Esc cancel ", footer_pos = "right",
    })
    st.cal_win = vim.api.nvim_open_win(st.cal_buf, false, {
        relative = "editor", row = top + 3, col = left, width = WIDTH, height = CAL_H,
        style = "minimal", border = "rounded", zindex = 60,
        footer = " hjkl day/week  H/L month  K/J year  . today  x remove  Tab type ", footer_pos = "right",
    })
    vim.wo[st.cal_win].wrap = false

    set_keymaps(st)
    set_autocmds(st)
    render(st)
    update_preview(st)
    vim.cmd("startinsert")
    return st
end

return M
