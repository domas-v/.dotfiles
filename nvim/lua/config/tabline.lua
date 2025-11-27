vim.o.showtabline = 1
vim.o.tabline = "%!v:lua.require('config.tabline').render()"

local M = {}

local function get_buf_name(bufnr, index)
    local bufname = vim.fn.bufname(bufnr)
    if bufname == "" then
        return "[No Name]"
    end
    bufname = vim.fn.fnamemodify(bufname, ":t")

    local highlight = "TabLine"
    if index == vim.fn.tabpagenr() then
        highlight = "TabLineSel"
    end

    local result = "%#" .. highlight .. "# " .. bufname .. " %*"
    return result
end


local function get_modified(bufnr)
    local modified = vim.fn.getbufvar(bufnr, "&mod")
    if modified == 1 then
        local highlight = "TabLine"
        local is_active = bufnr == vim.fn.bufnr("%")
        if is_active then
            highlight = "TabLineSel"
        end
        return "%#" .. highlight .. "#●%* "
    end
    return ""
end

local function get_index(index)
    local highlight = "TabLine"
    if index == vim.fn.tabpagenr() then
        highlight = "TabLineSel"
    end
    return "%#" .. highlight .. "# " .. index .. " %*"
end

function M.render()
    local result = ""

    for index = 1, vim.fn.tabpagenr("$") do
        local winnr = vim.fn.tabpagewinnr(index)
        local buflist = vim.fn.tabpagebuflist(index)
        local bufnr = buflist[winnr]

        local bufname = get_buf_name(bufnr, index)
        local bufmodified = get_modified(bufnr)
        local index_res = get_index(index)

        result = result .. index_res .. bufmodified .. bufname
    end

    return result
end

return M
