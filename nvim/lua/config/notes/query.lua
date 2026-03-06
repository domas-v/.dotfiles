local cfg = require("config.notes_config")
local priority = require("config.notes.priority")
local M = {}

---------------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------------

local function parse_rg_results(results, expanded_path)
    local items = {}
    for _, result in ipairs(results) do
        local file, lnum, content = result:match("^(.+):(%d+):(.*)$")
        if file then
            file = file:gsub(vim.pesc(expanded_path), "")
            local trimmed = content:match("^%s*(.-)%s*$") or content
            table.insert(items, { file = file, lnum = tonumber(lnum), text = trimmed })
        end
    end
    return items
end

--- Resolve predefined filter keywords into date-matching functions.
--- Returns a function(text) -> bool, or nil if not a predefined keyword.
local function resolve_date_filter(term)
    local today = os.date("%Y-%m-%d")
    if term == "today" then
        return function(text)
            return text:find(today, 1, true) ~= nil
        end
    elseif term == "this week" then
        local t = os.date("*t")
        local wday_offset = (t.wday - 2) % 7
        local monday = os.time(t) - wday_offset * 86400
        local dates = {}
        for d = 0, 6 do
            dates[os.date("%Y-%m-%d", monday + d * 86400)] = true
        end
        return function(text)
            local date = text:match("%[%[(%d%d%d%d%-%d%d%-%d%d)%]%]")
            return date and dates[date]
        end
    elseif term == "this month" then
        local prefix = os.date("%Y-%m")
        return function(text)
            local date = text:match("%[%[(%d%d%d%d%-%d%d)%-%d%d%]%]")
            return date and date == prefix
        end
    end
    return nil
end

-- Multi-word presets that must be matched as a whole phrase
local multi_word_presets = { "this week", "this month" }

local function filter_by_text(items, filter)
    if not filter then return items end

    -- Replace multi-word presets with single tokens before splitting
    local normalized = filter
    local date_fns = {}
    for _, preset in ipairs(multi_word_presets) do
        if normalized:find(preset, 1, true) then
            local fn = resolve_date_filter(preset)
            if fn then
                table.insert(date_fns, fn)
                normalized = normalized:gsub(preset, "", 1)
            end
        end
    end

    -- Split remaining into single-word terms (! prefix = negation)
    local include_terms = {}
    local exclude_terms = {}
    for term in normalized:gmatch("%S+") do
        local fn = resolve_date_filter(term)
        if fn then
            table.insert(date_fns, fn)
        elseif term:sub(1, 1) == "!" and #term > 1 then
            table.insert(exclude_terms, term:sub(2))
        else
            table.insert(include_terms, term)
        end
    end

    if #include_terms == 0 and #exclude_terms == 0 and #date_fns == 0 then return items end

    local filtered = {}
    for _, item in ipairs(items) do
        local match = true
        -- Check date filter functions
        for _, fn in ipairs(date_fns) do
            if not fn(item.text) then match = false; break end
        end
        -- Check include terms (must contain)
        if match then
            for _, term in ipairs(include_terms) do
                if not item.text:find(term, 1, true) then
                    match = false; break
                end
            end
        end
        -- Check exclude terms (must NOT contain)
        if match then
            for _, term in ipairs(exclude_terms) do
                if item.text:find(term, 1, true) then
                    match = false; break
                end
            end
        end
        if match then table.insert(filtered, item) end
    end
    return filtered
end

local function filter_by_text_match(items, text_match)
    if not text_match then return items end
    local filtered = {}
    for _, item in ipairs(items) do
        if item.text:find(text_match, 1, true) then
            table.insert(filtered, item)
        end
    end
    return filtered
end

local function filter_by_checkbox(items, match)
    if match == "all" then return items end
    local filtered = {}
    for _, item in ipairs(items) do
        if match == "unchecked" and item.text:find("%[ %]") then
            table.insert(filtered, item)
        elseif match == "checked" and item.text:find("%[x%]") then
            table.insert(filtered, item)
        elseif match == "in_progress" and item.text:find("%[%-%]") then
            table.insert(filtered, item)
        elseif match == "open" and (item.text:find("%[ %]") or item.text:find("%[%-%]")) then
            table.insert(filtered, item)
        end
    end
    return filtered
end

local function date_header(date)
    if date == "No date" then return date end
    local y, m, d = date:match("(%d+)-(%d+)-(%d+)")
    local t = os.time({ year = tonumber(y), month = tonumber(m), day = tonumber(d) })
    local wday = os.date("%a", t)
    local header = date .. " " .. wday
    if date == os.date("%Y-%m-%d") then
        header = header .. " ← today"
    end
    return header
end

local function group_by_date(items, sort_order)
    local groups = {}
    local dates = {}
    local seen = {}

    for _, item in ipairs(items) do
        local date = item.text:match("%[%[(%d%d%d%d%-%d%d%-%d%d)%]%]") or "No date"
        if not seen[date] then
            seen[date] = true
            table.insert(dates, date)
        end
        groups[date] = groups[date] or {}
        table.insert(groups[date], item)
    end

    table.sort(dates, function(a, b)
        if a == "No date" then return false end
        if b == "No date" then return true end
        if sort_order == "date_desc" then return a > b end
        return a < b
    end)

    return groups, dates
end

---------------------------------------------------------------------------
-- Search strategies
---------------------------------------------------------------------------

local function search_by_checkbox(match, expanded_path)
    local pattern
    if match == "unchecked" then
        pattern = "[-+] \\[ \\]"
    elseif match == "checked" then
        pattern = "[-+] \\[x\\]"
    elseif match == "in_progress" then
        pattern = "[-+] \\[-\\]"
    elseif match == "open" then
        pattern = "[-+] \\[[ -]\\]"
    else
        pattern = "[-+] \\[.\\]"
    end
    return vim.fn.systemlist({
        "rg", "--no-heading", "-n", "--color=never",
        pattern, expanded_path,
    })
end
local function search_by_date(date, expanded_path)
    return vim.fn.systemlist({
        "rg", "--no-heading", "-n", "--color=never", "-F",
        "[[" .. date .. "]]", expanded_path,
    })
end

---------------------------------------------------------------------------
-- Public API
---------------------------------------------------------------------------

--- Run a preset query and return formatted lines + reference map.
--- @param preset table  A preset spec from cfg.presets
--- @param ctx table     { path = expanded_path, selected_date = "YYYY-MM-DD", week_monday = os.time }
--- @return table  { lines = string[], refs = table<int, {file:string, lnum:int}> }
function M.run(preset, ctx)
    local lines = {}
    local refs = {}

    if preset.heading then
        table.insert(lines, preset.heading)
        table.insert(lines, "")
    end

    -- Weekday grouping: iterate over each day of the week
    if preset.group_by == "weekday" then
        local today = os.date("*t")
        for d = 0, 6 do
            local day_time = ctx.week_monday + d * 86400
            local day = os.date("*t", day_time)
            local day_date = string.format("%04d-%02d-%02d", day.year, day.month, day.day)
            local day_name = os.date("%A", day_time)
            local is_today = day.day == today.day and day.month == today.month and day.year == today.year

            local header = "## " .. day_name .. " " .. day_date
            if is_today then header = header .. " ← today" end
            table.insert(lines, header)
            table.insert(lines, "")

            local results = search_by_date(day_date, ctx.path)
            local items = parse_rg_results(results, ctx.path)
            items = filter_by_checkbox(items, preset.match)
            items = filter_by_text_match(items, preset.text_match)
            items = filter_by_text(items, ctx.filter)

            if #items > 0 then
                priority.sort_items(items)
                for _, item in ipairs(items) do
                    table.insert(lines, item.text)
                    refs[#lines - 1] = { file = item.file, lnum = item.lnum }
                end
            end

            table.insert(lines, "")
        end
        return { lines = lines, refs = refs }
    end

    -- Date-based search (selected date)
    if preset.date_match == "selected" then
        local results = search_by_date(ctx.selected_date, ctx.path)
        local items = parse_rg_results(results, ctx.path)
        items = filter_by_checkbox(items, preset.match)
        items = filter_by_text_match(items, preset.text_match)
        items = filter_by_text(items, ctx.filter)

        if #items == 0 then
            table.insert(lines, "*Nothing due*")
        else
            priority.sort_items(items)
            for _, item in ipairs(items) do
                table.insert(lines, item.text)
                refs[#lines - 1] = { file = item.file, lnum = item.lnum }
            end
        end
        return { lines = lines, refs = refs }
    end

    -- Overdue: unchecked items with dates before the selected date
    if preset.date_match == "before_selected" then
        local results = search_by_checkbox(preset.match, ctx.path)
        local items = parse_rg_results(results, ctx.path)
        items = filter_by_text_match(items, preset.text_match)
        items = filter_by_text(items, ctx.filter)
        local filtered = {}
        for _, item in ipairs(items) do
            local item_date = item.text:match("%[%[(%d%d%d%d%-%d%d%-%d%d)%]%]")
            if item_date and item_date < ctx.selected_date then
                table.insert(filtered, item)
            end
        end

        if #filtered == 0 then
            table.insert(lines, "*Nothing overdue*")
        else
            priority.sort_items(filtered)
            for _, item in ipairs(filtered) do
                table.insert(lines, item.text)
                refs[#lines - 1] = { file = item.file, lnum = item.lnum }
            end
        end
        return { lines = lines, refs = refs }
    end

    -- Checkbox-based search (all dates)
    local results = search_by_checkbox(preset.match, ctx.path)
    local items = parse_rg_results(results, ctx.path)
    items = filter_by_text_match(items, preset.text_match)
    items = filter_by_text(items, ctx.filter)

    if #items == 0 then
        table.insert(lines, "*None*")
        return { lines = lines, refs = refs }
    end

    -- Flat list (no grouping)
    if not preset.group_by then
        priority.sort_items(items)
        for _, item in ipairs(items) do
            table.insert(lines, item.text)
            refs[#lines - 1] = { file = item.file, lnum = item.lnum }
        end
        return { lines = lines, refs = refs }
    end

    -- Group by date
    if preset.group_by == "date" then
        local groups, dates = group_by_date(items, preset.sort)

        for _, date in ipairs(dates) do
            table.insert(lines, "## " .. date_header(date))
            table.insert(lines, "")
            priority.sort_items(groups[date])
            for _, item in ipairs(groups[date]) do
                table.insert(lines, item.text)
                refs[#lines - 1] = { file = item.file, lnum = item.lnum }
            end
            table.insert(lines, "")
        end
    end

    return { lines = lines, refs = refs }
end

return M

