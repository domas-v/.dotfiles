local cfg = require("config.notes_config")
local query = require("config.notes.query")
local pane = require("config.notes.pane")
local items = require("config.notes.items")
local M = {}

-- Forward reference set by init.lua
M.openers = {}

function M.open()
    local expanded_path = vim.fn.expand(cfg.daily_notes_path)

    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].bufhidden = "wipe"

    local refs = {}
    local win
    local active_filter = nil

    -- Get Monday of the current week
    local today = os.date("*t")
    local wday_offset = (today.wday - 2) % 7
    local monday_time = os.time(today) - wday_offset * 86400

    ---------------------------------------------------------------------------
    -- Render
    ---------------------------------------------------------------------------

    local function refresh()
        local result = query.run(cfg.presets.week, { path = expanded_path, week_monday = monday_time, filter = active_filter })
        refs = result.refs
        pane.render(buf, result)
    end

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
        title = "Week",
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
