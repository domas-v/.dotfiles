local cfg = require("config.notes_config")
local M = {}

function M.setup_highlights()
    local tags = cfg.priority.tags
    local hls = cfg.priority.hls
    for i, _ in ipairs(tags) do
        local source = hls[i] or hls[#hls]
        local hl = vim.api.nvim_get_hl(0, { name = source })
        vim.api.nvim_set_hl(0, "NotePriority" .. i, { fg = hl.fg, bold = true })
    end
end

function M.apply_highlights(win)
    local tags = cfg.priority.tags
    vim.api.nvim_win_call(win, function()
        for i, tag in ipairs(tags) do
            vim.fn.matchadd("NotePriority" .. i, vim.fn.escape(tag, "#"))
        end
    end)
end

function M.get_rank(text)
    local tags = cfg.priority.tags
    for i, tag in ipairs(tags) do
        if text:find(tag, 1, true) then return i * 2 end
    end
    return 3 -- untagged sits between 1st (2) and 2nd (4) priority
end

function M.get_date_rank(text)
    local date = text:match("%[%[(%d%d%d%d%-%d%d%-%d%d)%]%]")
    if date then return date end
    return "9999-99-99"
end

function M.sort_items(items)
    table.sort(items, function(a, b)
        local pa, pb = M.get_rank(a.text), M.get_rank(b.text)
        if pa ~= pb then return pa < pb end
        return M.get_date_rank(a.text) < M.get_date_rank(b.text)
    end)
    return items
end

function M.strip_tags(line)
    local tags = cfg.priority.tags
    for _, tag in ipairs(tags) do
        line = line:gsub("%s?" .. vim.pesc(tag), "")
    end
    return line
end

-- Priority tags are mutually exclusive: adding one removes the others
function M.remove_exclusive(line, tag)
    local tags = cfg.priority.tags
    local is_priority = false
    for _, t in ipairs(tags) do
        if t == tag then is_priority = true; break end
    end
    if not is_priority then return line end
    for _, t in ipairs(tags) do
        if t ~= tag then
            line = line:gsub("%s?" .. vim.pesc(t), "", 1)
        end
    end
    return line
end

return M

