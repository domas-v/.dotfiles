-- Bufferline (implemented via Neovim's built-in `tabline`)
-- 1) Left side: Harpoon (v2) items
-- 2) Right side: tab count like [1/2]

local M = {}

-- Apply the tabline
vim.o.showtabline = 2
vim.o.tabline = "%!v:lua.require('config.bufferline').render()"

local function normalize_list(t)
    local normalized = {}
    for _, v in pairs(t or {}) do
        if v ~= nil then
            table.insert(normalized, v)
        end
    end
    return normalized
end

local function hl(group, text)
    return "%#" .. group .. "#" .. text .. "%*"
end

local function current_buf_abs()
    local name = vim.api.nvim_buf_get_name(0)
    if not name or name == "" then
        return ""
    end
    return vim.fn.fnamemodify(name, ":p")
end

local function realpath(path)
    if not path or path == "" then
        return nil
    end
    local ok, rp = pcall(vim.loop.fs_realpath, path)
    if ok then
        return rp
    end
    return nil
end

local function is_same_file(a, b)
    if not a or a == "" or not b or b == "" then
        return false
    end

    -- Compare multiple normalized forms to handle Harpoon storing relative / :~:. paths.
    local a_abs = vim.fn.fnamemodify(a, ":p")
    local b_abs = vim.fn.fnamemodify(b, ":p")
    if a_abs == b_abs then
        return true
    end

    local a_rel = vim.fn.fnamemodify(a_abs, ":~:.")
    local b_rel = vim.fn.fnamemodify(b_abs, ":~:.")
    if a_rel == b_rel then
        return true
    end

    local a_rp = realpath(a_abs)
    local b_rp = realpath(b_abs)
    return a_rp ~= nil and b_rp ~= nil and a_rp == b_rp
end

local function get_harpoon_items()
    local ok, harpoon = pcall(require, "harpoon")
    if not ok or not harpoon then
        return {}
    end

    local list = harpoon:list()
    if not list or not list.items then
        return {}
    end

    return normalize_list(list.items)
end

local function render_harpoon_left()
    local items = get_harpoon_items()
    if #items == 0 then
        return ""
    end

    local cur_abs = current_buf_abs()
    local parts = {}

    for idx, item in ipairs(items) do
        local value = item.value or item.file
        if value and value ~= "" then
            local is_active = is_same_file(value, cur_abs)

            local group = is_active and "TabLineSel" or "TabLine"
            local name = vim.fn.fnamemodify(value, ":t")
            if not name or name == "" then
                name = value
            end

            table.insert(parts, hl(group, string.format(" %d:%s ", idx, name)))
        end
    end

    return table.concat(parts, "")
end

local function render_tabcount_right()
    local cur = vim.fn.tabpagenr()
    local total = vim.fn.tabpagenr("$")
    return hl("TabLine", string.format(" [%d/%d] ", cur, total))
end

function M.render()
    local left = render_harpoon_left()
    local right = render_tabcount_right()
    return left .. "%=" .. right .. "%#TabLineFill#%*"
end

return M
