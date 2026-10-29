local M = {}

local groups = {
    { tag = "active", title = "Active" },
    { tag = "next",   title = "Next" },
}

local config

local function frontmatter_tags(lines)
    local tags = {}
    if lines[1] ~= "---" then
        return tags, 0
    end
    local in_tags = false
    for i = 2, #lines do
        local line = lines[i]
        if line == "---" then
            return tags, i
        end
        local inline = line:match("^tags:%s*(.*)$")
        if inline then
            in_tags = inline == ""
            for tag in inline:gsub("[%[%]]", ""):gmatch("[^,%s]+") do
                tags[tag:gsub("^#", ""):lower()] = true
            end
        elseif in_tags and line:match("^%s+%-") then
            local tag = vim.trim(line:match("^%s+%-%s*(.*)$"))
            tags[tag:gsub("^#", ""):lower()] = true
        else
            in_tags = false
        end
    end
    return tags, 0
end

local function has_tag(line, tag)
    return line:lower():match("#" .. tag .. "%f[^%w_/-]") ~= nil
end

local function strip_tags(line)
    local text = line:gsub("^%s*[-+*]%s+", ""):gsub("^%s*%d+[.)]%s+", "")
    for _, group in ipairs(groups) do
        text = text:gsub("%s*#" .. group.tag .. "%f[^%w_/-]", "")
    end
    return vim.trim(text)
end

local function collect()
    local entries = {}
    for _, group in ipairs(groups) do
        entries[group.tag] = {}
    end

    for name, kind in vim.fs.dir(config.vault, { depth = 10 }) do
        if kind == "file" and name:match("%.md$") and not name:match("^templates/") and not name:match("^%.") then
            local path = vim.fs.joinpath(config.vault, name)
            local ok, lines = pcall(vim.fn.readfile, path)
            if ok then
                local tags, body_start = frontmatter_tags(lines)
                for _, group in ipairs(groups) do
                    local list = entries[group.tag]
                    if tags[group.tag] then
                        table.insert(list, { path = path, rel = name, lnum = 1, text = "[[" .. vim.fn.fnamemodify(name, ":t:r") .. "]]" })
                    end
                    for lnum = body_start + 1, #lines do
                        local line = lines[lnum]
                        if has_tag(line, group.tag) and not line:match("^%s*[-+*]%s+%[[xX-]%]") then
                            table.insert(list, { path = path, rel = name, lnum = lnum, text = strip_tags(line) })
                        end
                    end
                end
            end
        end
    end

    for _, list in pairs(entries) do
        table.sort(list, function(a, b)
            if a.rel ~= b.rel then
                return a.rel < b.rel
            end
            return a.lnum < b.lnum
        end)
    end
    return entries
end

local function inbox()
    local list = {}
    local ok, lines = pcall(vim.fn.readfile, config.inbox)
    if not ok then
        return list
    end
    local _, body_start = frontmatter_tags(lines)
    for lnum = body_start + 1, #lines do
        local line = lines[lnum]
        if line:match("^[-+*]%s+") and not line:match("^[-+*]%s+%[[xX-]%]") then
            table.insert(list, { path = config.inbox, lnum = lnum, text = strip_tags(line) })
        end
    end
    return list
end

local function render(buf)
    local entries = collect()
    local sections = { { title = "Inbox", list = inbox() } }
    for _, group in ipairs(groups) do
        table.insert(sections, { title = group.title, list = entries[group.tag] })
    end

    local lines = { "# Agenda" }
    local targets = {}
    for _, section in ipairs(sections) do
        vim.list_extend(lines, { "", "## " .. section.title, "" })
        local list = section.list
        if #list == 0 then
            table.insert(lines, "_nothing_")
        end
        for _, entry in ipairs(list) do
            table.insert(lines, "- " .. entry.text)
            targets[#lines] = entry
        end
    end

    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.b[buf].agenda_targets = targets
end

local function jump(buf)
    local entry = vim.b[buf].agenda_targets[vim.api.nvim_win_get_cursor(0)[1]]
    if not entry then
        return
    end
    vim.cmd.edit(vim.fn.fnameescape(entry.path))
    vim.api.nvim_win_set_cursor(0, { entry.lnum, 0 })
    vim.cmd("normal! zv")
end

function M.open()
    local buf = vim.fn.bufnr("notes://agenda")
    -- bdelete (e.g. Snacks.bufdelete) leaves an unloaded buffer without its maps and filetype
    if buf ~= -1 and not vim.api.nvim_buf_is_loaded(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
        buf = -1
    end
    if buf == -1 then
        buf = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_buf_set_name(buf, "notes://agenda")
        vim.bo[buf].bufhidden = "hide"
        vim.bo[buf].filetype = "markdown"
        vim.keymap.set("n", "<cr>", function() jump(buf) end, { buffer = buf, desc = "Open agenda item" })
        vim.keymap.set("n", "r", function() render(buf) end, { buffer = buf, desc = "Refresh agenda" })
        vim.keymap.set("n", "q", "<cmd>bwipeout<cr>", { buffer = buf, desc = "Close agenda" })
    end
    render(buf)
    vim.api.nvim_win_set_buf(0, buf)
end

function M.setup(opts)
    config = opts
    vim.api.nvim_create_user_command("Agenda", M.open, { desc = "Open notes agenda" })
end

return M
