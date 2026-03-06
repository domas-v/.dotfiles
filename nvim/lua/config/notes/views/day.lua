local cfg = require("config.notes_config")
local query = require("config.notes.query")
local pane = require("config.notes.pane")
local items = require("config.notes.items")
local M = {}

-- Forward reference set by init.lua
M.openers = {}

function M.open(opts)
    opts = opts or {}
    local expanded_path = vim.fn.expand(cfg.daily_notes_path)
    local today = os.date("%Y-%m-%d")

    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].bufhidden = "wipe"

    local refs = {}
    local win
    local active_filter = opts.filter or nil
    local title = opts.title or "Today"

    ---------------------------------------------------------------------------
    -- Render
    ---------------------------------------------------------------------------

    --- Append a query result to the output, only if it has items.
    local function append_if_nonempty(lines, all_refs, result)
        if not next(result.refs) then return end
        if #lines > 0 then table.insert(lines, "") end
        local offset = #lines
        vim.list_extend(lines, result.lines)
        for idx, ref in pairs(result.refs) do
            all_refs[idx + offset] = ref
        end
        table.insert(lines, "")
        table.insert(lines, "---")
    end

    local function refresh()
        local ctx = { path = expanded_path, selected_date = today, filter = active_filter }

        local overdue = query.run(cfg.presets.overdue, ctx)
        local important = query.run(cfg.presets.important, ctx)
        local in_prog = query.run(cfg.presets.in_progress, ctx)
        local todo = query.run(cfg.presets.todo, ctx)

        local lines = {}
        local all_refs = {}

        append_if_nonempty(lines, all_refs, overdue)
        append_if_nonempty(lines, all_refs, important)
        append_if_nonempty(lines, all_refs, in_prog)

        -- Todo always shown (even if empty)
        if #lines > 0 then table.insert(lines, "") end
        local offset = #lines
        vim.list_extend(lines, todo.lines)
        for idx, ref in pairs(todo.refs) do
            all_refs[idx + offset] = ref
        end

        refs = all_refs
        pane.render(buf, { lines = lines, refs = all_refs })
    end

    ---------------------------------------------------------------------------
    -- Filter
    ---------------------------------------------------------------------------

    local function set_filter()
        vim.ui.input({ prompt = "Filter (@category, #tag, date): ", default = active_filter or "" }, function(input)
            if input == nil then return end
            active_filter = input ~= "" and input or nil
            refresh()
        end)
        items.attach_tag_completion()
    end

    local function clear_filter()
        active_filter = nil
        refresh()
    end

    ---------------------------------------------------------------------------
    -- Layout
    ---------------------------------------------------------------------------

    local layout = pane.centered_layout()

    win = pane.open_float(buf, {
        width = layout.total_width,
        height = layout.total_height,
        row = layout.start_row,
        col = layout.start_col,
        title = title,
        focus = true,
    })

    refresh()
    vim.bo[buf].filetype = "markdown"

    ---------------------------------------------------------------------------
    -- Close
    ---------------------------------------------------------------------------

    local function close()
        pcall(function() vim.bo[buf].filetype = "" end)
        pcall(vim.api.nvim_win_close, win, true)
    end

    ---------------------------------------------------------------------------
    -- Keymaps
    ---------------------------------------------------------------------------

    pane.bind_keys(buf, {
        refs_fn = function() return refs end,
        win_fn = function() return win end,
        base_path = expanded_path,
        refresh_fn = refresh,
        close_fn = close,
        filter_fn = set_filter,
        clear_filter_fn = clear_filter,
    })
    pane.bind_view_switch(buf, close, M.openers)
end

return M
