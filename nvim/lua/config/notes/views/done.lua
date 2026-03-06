local cfg = require("config.notes_config")
local query = require("config.notes.query")
local pane = require("config.notes.pane")
local items = require("config.notes.items")
local M = {}

-- Forward reference set by init.lua
M.openers = {}

function M.open()
    local expanded_path = vim.fn.expand(cfg.daily_notes_path)

    local done_buf = vim.api.nvim_create_buf(false, true)
    vim.bo[done_buf].bufhidden = "wipe"

    local done_refs = {}
    local done_win
    local active_filter = nil

    ---------------------------------------------------------------------------
    -- Render
    ---------------------------------------------------------------------------

    local function refresh()
        local result = query.run(cfg.presets.done, { path = expanded_path, filter = active_filter })
        done_refs = result.refs
        pane.render(done_buf, result)
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

    done_win = pane.open_float(done_buf, {
        width = layout.total_width,
        height = layout.total_height,
        row = layout.start_row,
        col = layout.start_col,
        title = "Done",
        focus = true,
    })

    refresh()
    vim.bo[done_buf].filetype = "markdown"

    ---------------------------------------------------------------------------
    -- Close
    ---------------------------------------------------------------------------

    local function close()
        pcall(function() vim.bo[done_buf].filetype = "" end)
        pcall(vim.api.nvim_win_close, done_win, true)
    end

    ---------------------------------------------------------------------------
    -- Keymaps
    ---------------------------------------------------------------------------

    pane.bind_keys(done_buf, {
        refs_fn = function() return done_refs end,
        win_fn = function() return done_win end,
        base_path = expanded_path,
        refresh_fn = refresh,
        close_fn = close,
        filter_fn = set_filter,
        clear_filter_fn = clear_filter,
    })
    pane.bind_view_switch(done_buf, close, M.openers)
end

return M

