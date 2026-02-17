local M = {}

local _items = nil
local _loaded_key = nil

DATA_DIR = vim.fn.stdpath("data") .. "/pinned"

local function project_key()
    local cwd = vim.fn.getcwd()
    return vim.base64.encode(cwd):gsub("/", "_") .. ".json"
end

local function project_path()
    return DATA_DIR .. "/" .. project_key()
end

local function load_from_disk()
    local path = project_path()
    local fd = io.open(path, "r")
    if not fd then
        return {}
    end
    local raw = fd:read("*a")
    fd:close()
    if not raw or raw == "" then
        return {}
    end
    local ok, data = pcall(vim.fn.json_decode, raw)
    if ok and type(data) == "table" then
        return data
    end
    return {}
end

local function save_to_disk()
    vim.fn.mkdir(DATA_DIR, "p")
    local path = project_path()
    local fd = io.open(path, "w")
    if not fd then
        vim.notify("pinned: failed to open path " .. path, vim.log.levels.ERROR)
        return
    end
    fd:write(vim.fn.json_encode(_items or {}))
    fd:close()
end

local function ensure_loaded()
    local key = project_key()
    if _items ~= nil and _loaded_key == key then
        return
    end
    _items = load_from_disk()
    _loaded_key = key
end

-- ---------------------------------------------------------------------------
-- Public API
-- ---------------------------------------------------------------------------

function items()
    ensure_loaded()
    return _items
end

-- example mutation:
function pin()
    ensure_loaded()
    local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~:.")
    if path == "" then return end

    for _, v in ipairs(_items) do
        if v == path then return end
    end
    table.insert(_items, path)
    save_to_disk()
    vim.cmd("redrawtabline")
end

function M.remove(buff)

end

function M.go_to(buff)

end

function M.move(from, to)

end

return M
