local cfg = require("config.notes_config")
local undo = require("config.notes.undo")
local priority = require("config.notes.priority")
local M = {}

-- Build cycle map from config checkboxes (each row is an ordered cycle)
local function build_cycle_map()
    local map = {}
    for _, row in ipairs(cfg.checkboxes) do
        for i, state in ipairs(row) do
            map[state] = row[i % #row + 1]
        end
    end
    return map
end

local checkbox_cycle = build_cycle_map()

-- Reload an open buffer from disk
local function reload_buf(filepath)
    local buf = vim.fn.bufnr(filepath)
    if buf ~= -1 then
        vim.api.nvim_buf_call(buf, function() vim.cmd("edit!") end)
    end
end

---------------------------------------------------------------------------
-- Low-level line operations
---------------------------------------------------------------------------

function M.cycle_checkbox(file_lines, lnum)
    local line = file_lines[lnum]
    for pattern, replacement in pairs(checkbox_cycle) do
        if line:find(pattern, 1, true) then
            file_lines[lnum] = line:gsub(vim.pesc(pattern), replacement, 1)
            if replacement:find("[x]", 1, true) then
                file_lines[lnum] = priority.strip_tags(file_lines[lnum])
            end
            break
        end
    end
end

--- Set a checkbox to a specific state (any checkbox pattern → target state)
--- @param target string  The target state, e.g. "- [x]"
function M.set_checkbox(file_lines, lnum, target)
    local line = file_lines[lnum]
    for _, row in ipairs(cfg.checkboxes) do
        for _, state in ipairs(row) do
            if line:find(state, 1, true) then
                file_lines[lnum] = line:gsub(vim.pesc(state), target, 1)
                if target:find("[x]", 1, true) then
                    file_lines[lnum] = priority.strip_tags(file_lines[lnum])
                end
                return
            end
        end
    end
end

function M.mark_done(file_lines, lnum) M.set_checkbox(file_lines, lnum, "- [x]") end
function M.mark_in_progress(file_lines, lnum) M.set_checkbox(file_lines, lnum, "- [-]") end
function M.mark_todo(file_lines, lnum) M.set_checkbox(file_lines, lnum, "- [ ]") end

function M.delete_with_children(file_lines, lnum)
    if lnum > #file_lines then return end
    local base_indent = file_lines[lnum]:match("^(%s*)"):len()
    local count = 1
    while lnum + count <= #file_lines do
        local next_indent = file_lines[lnum + count]:match("^(%s*)"):len()
        if next_indent > base_indent then
            count = count + 1
        else
            break
        end
    end
    for _ = 1, count do
        table.remove(file_lines, lnum)
    end
end

---------------------------------------------------------------------------
-- Generic cursor-ref helper (replaces 3x duplicated wrappers)
---------------------------------------------------------------------------

function M.with_ref(refs, win, base_path, mutate_fn, refresh_fn)
    local cursor_line = vim.api.nvim_win_get_cursor(win)[1] - 1
    local ref = refs[cursor_line]
    if not ref then return end

    local filepath = base_path .. ref.file
    local file_lines = vim.fn.readfile(filepath)
    if not file_lines or ref.lnum > #file_lines then return end

    mutate_fn(file_lines, ref.lnum)
    undo.write(filepath, file_lines)
    reload_buf(filepath)
    if refresh_fn then refresh_fn() end
end

---------------------------------------------------------------------------
-- Single-item operations (prompt-based)
---------------------------------------------------------------------------

function M.set_tag(refs, win, base_path, refresh_fn)
    local cursor_line = vim.api.nvim_win_get_cursor(win)[1] - 1
    local ref = refs[cursor_line]
    if not ref then return end

    local choices = vim.list_extend({ "(none)" }, cfg.priority.tags)
    local orig = vim.ui.select
    vim.ui.select = vim.ui._original_select or vim.ui.select
    vim.ui.select(choices, { prompt = "Priority:" }, function(choice)
        vim.ui.select = orig
        if not choice then return end

        local filepath = base_path .. ref.file
        local file_lines = vim.fn.readfile(filepath)
        if not file_lines or ref.lnum > #file_lines then return end

        -- Remove all existing priority tags
        file_lines[ref.lnum] = priority.strip_tags(file_lines[ref.lnum])
        -- Add the selected one (unless "(none)")
        if choice ~= "(none)" then
            file_lines[ref.lnum] = file_lines[ref.lnum] .. " " .. choice
        end
        undo.write(filepath, file_lines)
        reload_buf(filepath)
        if refresh_fn then refresh_fn() end
    end)
end

function M.set_category(refs, win, base_path, refresh_fn)
    local cursor_line = vim.api.nvim_win_get_cursor(win)[1] - 1
    local ref = refs[cursor_line]
    if not ref then return end

    local choices = vim.list_extend({ "(none)" }, cfg.categories)
    local orig = vim.ui.select
    vim.ui.select = vim.ui._original_select or vim.ui.select
    vim.ui.select(choices, { prompt = "Category:" }, function(choice)
        vim.ui.select = orig
        if not choice then return end

        local filepath = base_path .. ref.file
        local file_lines = vim.fn.readfile(filepath)
        if not file_lines or ref.lnum > #file_lines then return end

        -- Remove all existing categories
        for _, c in ipairs(cfg.categories) do
            file_lines[ref.lnum] = file_lines[ref.lnum]:gsub("%s?" .. vim.pesc(c), "", 1)
        end
        -- Add the selected one (unless "(none)")
        if choice ~= "(none)" then
            file_lines[ref.lnum] = file_lines[ref.lnum] .. " " .. choice
        end
        undo.write(filepath, file_lines)
        reload_buf(filepath)
        if refresh_fn then refresh_fn() end
    end)
end

function M.set_date(refs, win, base_path, refresh_fn)
    local cursor_line = vim.api.nvim_win_get_cursor(win)[1] - 1
    local ref = refs[cursor_line]
    if not ref then return end

    vim.ui.input({ prompt = "Date (YYYY-MM-DD, empty to remove): ", default = os.date("%Y-%m-%d") }, function(date)
        if date == nil then return end -- cancelled

        local filepath = base_path .. ref.file
        local file_lines = vim.fn.readfile(filepath)
        if not file_lines or ref.lnum > #file_lines then return end

        -- Remove existing date link
        file_lines[ref.lnum] = file_lines[ref.lnum]:gsub("%s?%[%[%d%d%d%d%-%d%d%-%d%d%]%]", "")
        -- Add new one if not empty
        if date ~= "" then
            file_lines[ref.lnum] = file_lines[ref.lnum] .. " [[" .. date .. "]]"
        end
        undo.write(filepath, file_lines)
        reload_buf(filepath)
        if refresh_fn then refresh_fn() end
    end)
end

function M.edit_item(refs, win, base_path, refresh_fn)
    local cursor_line = vim.api.nvim_win_get_cursor(win)[1] - 1
    local ref = refs[cursor_line]
    if not ref then return end

    local filepath = base_path .. ref.file
    local file_lines = vim.fn.readfile(filepath)
    if not file_lines or ref.lnum > #file_lines then return end

    local current = file_lines[ref.lnum]
    vim.ui.input({ prompt = "Edit: ", default = current }, function(new_text)
        if not new_text or new_text == current then return end
        file_lines[ref.lnum] = new_text
        undo.write(filepath, file_lines)
        reload_buf(filepath)
        if refresh_fn then refresh_fn() end
    end)
end

--- Attach #/@ completion to the current buffer (for vim.ui.input prompts).
--- Call via vim.schedule after vim.ui.input to attach to the input buffer.
local filter_presets = { "today", "this week", "this month" }

function M.attach_tag_completion()
    vim.schedule(function()
        local buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_create_autocmd("TextChangedI", {
            buffer = buf,
            callback = function()
                local col = vim.api.nvim_win_get_cursor(0)[2]
                local line = vim.api.nvim_get_current_line()
                local before = line:sub(1, col)

                -- #tag completion
                local trigger_pos = before:find("[#@][^%s]*$")
                if trigger_pos then
                    local trigger = line:sub(trigger_pos, trigger_pos)
                    if trigger == "#" then
                        local tags = vim.list_extend(vim.list_extend({}, cfg.priority.tags), cfg.tags)
                        vim.fn.complete(trigger_pos, tags)
                    elseif trigger == "@" then
                        vim.fn.complete(trigger_pos, cfg.categories)
                    end
                    return
                end

                -- Predefined filter completion (match last word being typed)
                local last_word_start = before:find("%S+$")
                local last_word = last_word_start and before:sub(last_word_start)
                if last_word then
                    local matches = {}
                    for _, preset in ipairs(filter_presets) do
                        if preset:sub(1, #last_word) == last_word then
                            table.insert(matches, preset)
                        end
                    end
                    if #matches > 0 then
                        vim.fn.complete(last_word_start, matches)
                    end
                end
            end,
        })
    end)
end

--- Find the date from the nearest heading above the cursor in a view buffer.
--- Scans upward for a ## heading containing YYYY-MM-DD.
function M.get_context_date(view_buf, view_win)
    local cursor = vim.api.nvim_win_get_cursor(view_win)[1] -- 1-indexed
    local lines = vim.api.nvim_buf_get_lines(view_buf, 0, cursor, false)
    for i = #lines, 1, -1 do
        local date = lines[i]:match("(%d%d%d%d%-%d%d%-%d%d)")
        if date then return date end
    end
    return nil
end

function M.quick_capture(base_path, refresh_fn, opts)
    opts = opts or {}
    local default_date = opts.date

    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].filetype = "markdown"
    vim.b[buf].completion = true

    -- Pre-fill with date link if provided
    local initial = default_date and ("[[" .. default_date .. "]]") or ""
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { initial })

    local width = math.min(80, math.floor(vim.o.columns * 0.6))
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = 1,
        row = math.floor(vim.o.lines / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
        title = " - [ ] ",
        title_pos = "center",
    })

    -- Ensure cursor is visible
    local saved_guicursor = vim.o.guicursor
    vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

    -- Place cursor at the start (before any pre-filled date) and enter insert
    vim.api.nvim_win_set_cursor(win, { 1, 0 })
    vim.cmd("startinsert")

    local closed = false
    local function close()
        if closed then return end
        closed = true
        vim.o.guicursor = saved_guicursor
        pcall(vim.api.nvim_win_close, win, true)
    end

    local function submit()
        local text = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]
        close()

        if not text or text:match("^%s*$") then return end

        local line = "- [ ] " .. text
        local today = os.date("%Y-%m-%d")
        local path = base_path .. today .. ".md"
        local file_lines = {}
        if vim.fn.filereadable(path) == 1 then
            file_lines = vim.fn.readfile(path)
        else
            file_lines = { "# " .. today, "" }
        end
        table.insert(file_lines, line)
        undo.write(path, file_lines)
        reload_buf(path)
        if refresh_fn then refresh_fn() end
    end

    local kopts = { buffer = buf, nowait = true }
    vim.keymap.set("i", "<CR>", submit, kopts)
    vim.keymap.set("n", "<CR>", submit, kopts)
    vim.keymap.set("n", "q", close, kopts)
    vim.keymap.set("n", "<Esc>", close, kopts)

    -- Close if the window loses focus
    vim.api.nvim_create_autocmd("WinLeave", {
        buffer = buf,
        once = true,
        callback = close,
    })
end

---------------------------------------------------------------------------
-- Batch (visual-mode) operations
---------------------------------------------------------------------------

function M.get_visual_refs(refs)
    local start_line = vim.fn.line("'<") - 1
    local end_line = vim.fn.line("'>") - 1
    local collected = {}
    for line = start_line, end_line do
        if refs[line] then
            table.insert(collected, refs[line])
        end
    end
    return collected
end

local function batch_file_op(refs_list, base_path, line_fn, refresh_fn)
    local by_file = {}
    for _, ref in ipairs(refs_list) do
        by_file[ref.file] = by_file[ref.file] or {}
        table.insert(by_file[ref.file], ref)
    end
    for file, file_refs in pairs(by_file) do
        local filepath = base_path .. file
        local file_lines = vim.fn.readfile(filepath)
        if file_lines then
            table.sort(file_refs, function(a, b) return a.lnum > b.lnum end)
            for _, ref in ipairs(file_refs) do
                if ref.lnum <= #file_lines then
                    line_fn(file_lines, ref.lnum)
                end
            end
            undo.write(filepath, file_lines)
            reload_buf(filepath)
        end
    end
    if refresh_fn then refresh_fn() end
end

function M.batch_cycle(refs_list, base_path, refresh_fn)
    batch_file_op(refs_list, base_path, function(file_lines, lnum)
        M.cycle_checkbox(file_lines, lnum)
    end, refresh_fn)
end

function M.batch_mark_done(refs_list, base_path, refresh_fn)
    batch_file_op(refs_list, base_path, function(file_lines, lnum)
        M.mark_done(file_lines, lnum)
    end, refresh_fn)
end

function M.batch_mark_in_progress(refs_list, base_path, refresh_fn)
    batch_file_op(refs_list, base_path, function(file_lines, lnum)
        M.mark_in_progress(file_lines, lnum)
    end, refresh_fn)
end

function M.batch_mark_todo(refs_list, base_path, refresh_fn)
    batch_file_op(refs_list, base_path, function(file_lines, lnum)
        M.mark_todo(file_lines, lnum)
    end, refresh_fn)
end

function M.batch_delete(refs_list, base_path, refresh_fn)
    batch_file_op(refs_list, base_path, function(file_lines, lnum)
        M.delete_with_children(file_lines, lnum)
    end, refresh_fn)
end

function M.batch_set_tag(refs_list, base_path, refresh_fn)
    local choices = vim.list_extend({ "(none)" }, cfg.priority.tags)
    vim.ui.select(choices, { prompt = "Priority:" }, function(choice)
        if not choice then return end
        batch_file_op(refs_list, base_path, function(file_lines, lnum)
            file_lines[lnum] = priority.strip_tags(file_lines[lnum])
            if choice ~= "(none)" then
                file_lines[lnum] = file_lines[lnum] .. " " .. choice
            end
        end, refresh_fn)
    end)
end

function M.batch_set_category(refs_list, base_path, refresh_fn)
    local choices = vim.list_extend({ "(none)" }, cfg.categories)
    vim.ui.select(choices, { prompt = "Category:" }, function(choice)
        if not choice then return end
        batch_file_op(refs_list, base_path, function(file_lines, lnum)
            for _, c in ipairs(cfg.categories) do
                file_lines[lnum] = file_lines[lnum]:gsub("%s?" .. vim.pesc(c), "", 1)
            end
            if choice ~= "(none)" then
                file_lines[lnum] = file_lines[lnum] .. " " .. choice
            end
        end, refresh_fn)
    end)
end

function M.batch_set_date(refs_list, base_path, refresh_fn)
    local date = vim.fn.input("Date (YYYY-MM-DD, empty to remove): ", os.date("%Y-%m-%d"))
    if date == nil then return end -- cancelled

    batch_file_op(refs_list, base_path, function(file_lines, lnum)
        file_lines[lnum] = file_lines[lnum]:gsub("%s?%[%[%d%d%d%d%-%d%d%-%d%d%]%]", "")
        if date ~= "" then
            file_lines[lnum] = file_lines[lnum] .. " [[" .. date .. "]]"
        end
    end, refresh_fn)
end

return M

