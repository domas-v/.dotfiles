--- blink.cmp source for note tags (#priority, @category, [[date]])
local cfg = require("config.notes_config")

--- @class blink.cmp.NotesTagsSource : blink.cmp.Source
local source = {}

function source.new()
    return setmetatable({}, { __index = source })
end

function source:get_trigger_characters()
    return { "#", "@", "[" }
end

function source:should_show_items(_, items)
    return #items > 0
end

--- Build a textEdit that replaces from `start_col` (0-indexed) to cursor
local function make_edit(ctx, start_col, new_text)
    local line_num = ctx.cursor[1] - 1 -- 0-indexed
    local end_col = ctx.cursor[2]      -- 0-indexed
    return {
        newText = new_text,
        range = {
            start = { line = line_num, character = start_col },
            ["end"] = { line = line_num, character = end_col },
        },
    }
end

function source:get_completions(ctx, callback)
    local line = ctx.line
    local col = ctx.cursor[2]
    local before = line:sub(1, col)

    local items = {}
    local kind_text = require("blink.cmp.types").CompletionItemKind.Text

    -- Date links: triggered by [[
    local bracket_pos = before:find("%[%[[^%]]*$")
    if bracket_pos then
        local start_col = bracket_pos - 1 -- 0-indexed
        local today = os.time()
        local day_names = { "Today", "Tomorrow" }

        for d = 0, 13 do
            local t = today + d * 86400
            local date = os.date("%Y-%m-%d", t)
            local day_name = day_names[d + 1] or os.date("%A", t)

            table.insert(items, {
                label = string.format("%s  %s", date, day_name),
                kind = kind_text,
                filterText = "[[" .. date,
                sortText = string.format("%02d", d),
                textEdit = make_edit(ctx, start_col, "[[" .. date .. "]]"),
            })
        end
        callback({ is_incomplete_forward = false, is_incomplete_backward = false, items = items })
        return
    end

    -- Tags: triggered by # or @
    local trigger_pos = before:find("[#@][^%s]*$")
    if not trigger_pos then
        callback({ is_incomplete_forward = false, is_incomplete_backward = false, items = {} })
        return
    end

    local start_col = trigger_pos - 1 -- 0-indexed
    local trigger = line:sub(trigger_pos, trigger_pos)
    local completions = {}

    if trigger == "#" then
        completions = vim.list_extend(vim.list_extend({}, cfg.priority.tags), cfg.tags)
    elseif trigger == "@" then
        completions = vim.list_extend({}, cfg.categories)
    end

    for _, value in ipairs(completions) do
        table.insert(items, {
            label = value,
            kind = kind_text,
            filterText = value,
            textEdit = make_edit(ctx, start_col, value),
        })
    end

    callback({
        is_incomplete_forward = false,
        is_incomplete_backward = false,
        items = items,
    })
end

return source
