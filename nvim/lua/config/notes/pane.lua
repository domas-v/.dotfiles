local cfg = require("config.notes_config")
local undo = require("config.notes.undo")
local priority = require("config.notes.priority")
local items = require("config.notes.items")
local M = {}

--- Create a centered floating window with common defaults.
--- @param buf number  buffer handle
--- @param opts table  { width, height, row, col, title?, focus? }
--- @return number win handle
function M.open_float(buf, opts)
    local win = vim.api.nvim_open_win(buf, opts.focus or false, {
        relative = "editor",
        width = opts.width,
        height = opts.height,
        row = opts.row,
        col = opts.col,
        style = "minimal",
        border = "rounded",
        title = opts.title and (" " .. opts.title .. " ") or nil,
        title_pos = opts.title and "center" or nil,
    })
    vim.wo[win].wrap = false
    priority.apply_highlights(win)
    return win
end

--- Compute the standard centered layout dimensions.
--- @return table { total_width, total_height, start_row, start_col }
function M.centered_layout()
    local total_width = math.min(math.floor(vim.o.columns * 0.9), 140)
    local total_height = math.min(math.floor(vim.o.lines * 0.85), 50)
    local start_row = math.floor((vim.o.lines - total_height) / 2)
    local start_col = math.floor((vim.o.columns - total_width) / 2)
    return {
        total_width = total_width,
        total_height = total_height,
        start_row = start_row,
        start_col = start_col,
    }
end

--- Render query results into a buffer.
--- @param buf number  buffer handle
--- @param result table  { lines, refs } from query.run()
function M.render(buf, result)
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, result.lines)
    vim.bo[buf].modifiable = false
    vim.api.nvim_exec_autocmds("TextChanged", { buffer = buf })
end

--- Bind the full item-pane keyset to a buffer.
--- @param buf number  buffer handle
--- @param opts table  {
---   refs_fn: fun(): table,      -- returns current refs map
---   win_fn: fun(): number,       -- returns current window handle
---   base_path: string,           -- expanded notes path
---   refresh_fn: fun(),           -- called after mutations
---   close_fn: fun(),             -- close the entire view
---   goto_fn: fun()?,             -- custom goto (default: jump to ref)
---   focus_next_fn: fun()?,       -- Tab action
---   focus_prev_fn: fun()?,       -- S-Tab action
--- }
function M.bind_keys(buf, opts)
    local kopts = { buffer = buf, nowait = true }

    -- Navigation
    vim.keymap.set("n", "q", opts.close_fn, kopts)
    vim.keymap.set("n", "<Esc>", opts.close_fn, kopts)

    if opts.focus_next_fn then
        vim.keymap.set("n", "<Tab>", opts.focus_next_fn, kopts)
    end
    if opts.focus_prev_fn then
        vim.keymap.set("n", "<S-Tab>", opts.focus_prev_fn, kopts)
    end

    -- Go to source
    local goto_fn = opts.goto_fn or function()
        local cursor_line = vim.api.nvim_win_get_cursor(opts.win_fn())[1] - 1
        local ref = opts.refs_fn()[cursor_line]
        if ref then
            opts.close_fn()
            vim.cmd("edit " .. cfg.daily_notes_path .. ref.file)
            vim.api.nvim_win_set_cursor(0, { ref.lnum, 0 })
        end
    end
    vim.keymap.set("n", "<CR>", goto_fn, kopts)

    -- Single-item state changes
    vim.keymap.set("n", "x", function()
        items.with_ref(opts.refs_fn(), opts.win_fn(), opts.base_path, items.mark_done, opts.refresh_fn)
    end, kopts)
    vim.keymap.set("n", "i", function()
        items.with_ref(opts.refs_fn(), opts.win_fn(), opts.base_path, items.mark_in_progress, opts.refresh_fn)
    end, kopts)
    vim.keymap.set("n", "o", function()
        items.with_ref(opts.refs_fn(), opts.win_fn(), opts.base_path, items.mark_todo, opts.refresh_fn)
    end, kopts)
    vim.keymap.set("n", "X", function()
        items.with_ref(opts.refs_fn(), opts.win_fn(), opts.base_path, items.delete_with_children, opts.refresh_fn)
    end, kopts)
    vim.keymap.set("n", "T", function()
        items.set_tag(opts.refs_fn(), opts.win_fn(), opts.base_path, opts.refresh_fn)
    end, kopts)
    vim.keymap.set("n", "C", function()
        items.set_category(opts.refs_fn(), opts.win_fn(), opts.base_path, opts.refresh_fn)
    end, kopts)
    vim.keymap.set("n", "D", function()
        items.set_date(opts.refs_fn(), opts.win_fn(), opts.base_path, opts.refresh_fn)
    end, kopts)
    vim.keymap.set("n", "e", function()
        items.edit_item(opts.refs_fn(), opts.win_fn(), opts.base_path, opts.refresh_fn)
    end, kopts)
    vim.keymap.set("n", "c", function()
        items.quick_capture(opts.base_path, opts.refresh_fn)
    end, kopts)
    vim.keymap.set("n", "u", function()
        undo.undo(opts.refresh_fn)
    end, kopts)

    -- Capture with context date (from nearest heading above cursor)
    vim.keymap.set("n", "a", function()
        local view_buf = vim.api.nvim_win_get_buf(opts.win_fn())
        local date = items.get_context_date(view_buf, opts.win_fn())
        items.quick_capture(opts.base_path, opts.refresh_fn, { date = date })
    end, kopts)

    -- Category filter
    if opts.filter_fn then
        vim.keymap.set("n", "f", opts.filter_fn, kopts)
    end
    if opts.clear_filter_fn then
        vim.keymap.set("n", "F", opts.clear_filter_fn, kopts)
    end

    -- Visual-mode batch operations
    local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
    local function visual_op(batch_fn)
        return function()
            vim.api.nvim_feedkeys(esc, "x", false)
            vim.schedule(function()
                batch_fn(items.get_visual_refs(opts.refs_fn()), opts.base_path, opts.refresh_fn)
            end)
        end
    end

    vim.keymap.set("v", "x", visual_op(items.batch_mark_done), kopts)
    vim.keymap.set("v", "i", visual_op(items.batch_mark_in_progress), kopts)
    vim.keymap.set("v", "o", visual_op(items.batch_mark_todo), kopts)
    vim.keymap.set("v", "X", visual_op(items.batch_delete), kopts)
    vim.keymap.set("v", "T", visual_op(items.batch_set_tag), kopts)
    vim.keymap.set("v", "C", visual_op(items.batch_set_category), kopts)
    vim.keymap.set("v", "D", visual_op(items.batch_set_date), kopts)
end

--- Bind view-switch keymaps to a buffer.
--- @param buf number
--- @param close_fn fun()
--- @param openers table
function M.bind_view_switch(buf, close_fn, openers)
    local kopts = { buffer = buf, nowait = true }
    vim.keymap.set("n", "<leader>a", function() close_fn(); openers.day() end, kopts)
    vim.keymap.set("n", "<leader>w", function() close_fn(); openers.work() end, kopts)
    vim.keymap.set("n", "<leader>p", function() close_fn(); openers.personal() end, kopts)
    vim.keymap.set("n", "<leader>W", function() close_fn(); openers.week() end, kopts)
    vim.keymap.set("n", "<leader>x", function() close_fn(); openers.done() end, kopts)
end

return M

