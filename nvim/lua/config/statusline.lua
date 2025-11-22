vim.o.laststatus = 3
vim.o.statusline = "%!v:lua.require('config.statusline').render()"
vim.o.showmode = false

local M = {}

local highlights = require("config.highlights")
local icons = require("config.icons")
local mode_to_str = {
    ["n"] = "NORMAL",
    ["no"] = "N·OPER",

    ["v"] = "VISUAL",
    ["V"] = "V·LINE",
    ['\22'] = 'V·BLOCK',
    ["s"] = "SELECT",
    ["S"] = "S·LINE",

    ["i"] = "INSERT",
    ["ic"] = "INSERT",

    ["R"] = "REPLACE",
    ["Rv"] = "V·REPLACE",

    ["c"] = "COMMAND",
    ["cv"] = "EX",
    ["ce"] = "EX",

    ["r?"] = "CONFIRM",
    ["r"] = "PROMPT",

    ["rm"] = "MORE",

    ["!"] = "SHELL",
    ["t"] = "TERMINAL",
}
local mode_map = {
    ["NORMAL"] = "NORMAL",
    ["N·OPER"] = "NORMAL",

    ["VISUAL"] = "VISUAL",
    ["V·LINE"] = "VISUAL",
    ["V·BLOCK"] = "VISUAL",
    ["SELECT"] = "VISUAL",
    ["S·LINE"] = "VISUAL",

    ["INSERT"] = "INSERT",

    ["REPLACE"] = "REPLACE",
    ["V·REPLACE"] = "REPLACE",

    ["COMMAND"] = "COMMAND",
    ["EX"] = "COMMAND",

    ["PROMPT"] = "PROMPT",
    ["CONFIRM"] = "PROMPT",

    ["MORE"] = "MORE",
    ["SHELL"] = "SHELL",
    ["TERMINAL"] = "TERMINAL",
}
local buf_type_map = {
    ["help"] = icons.misc.help,
    ["quickfix"] = icons.misc.search,
    ["terminal"] = icons.misc.terminal,
    ["prompt"] = icons.misc.prompt,
}
local special_file_map = {
    ["snacks_picker_input"] = icons.misc.prompt,
    ["help"] = icons.misc.help,
}

local function table_get(table, key, alterantive)
    local val = table[key]
    if val == nil then
        return alterantive
    end
    return val
end

local function highlight_mode(mode)
    local mode_name = table_get(mode_map, mode, mode)
    local hl_name = highlights.groups[mode_name].MODE.group
    return hl_name
end

local function highlight_mode_separator(mode)
    local mode_name = table_get(mode_map, mode, mode)
    local hl_name = highlights.groups[mode_name].MODE_SEP.group
    return hl_name
end

local function highlight_git(mode)
    local mode_name = table_get(mode_map, mode, mode)
    local hl_name = highlights.groups[mode_name].GIT.group
    return hl_name
end

function M.mode_component(mode)
    local separator_highlight_name = highlight_mode_separator(mode)
    local left_separator_component = "%#" .. separator_highlight_name .. "#" .. icons.arrows.left_solid
    local right_separator_component = "%#" .. separator_highlight_name .. "#" .. icons.arrows.right_solid
    local mode_component = "%#" .. highlight_mode(mode) .. "#" .. mode

    local result = "%(" .. left_separator_component .. mode_component .. right_separator_component .. "%)"
    return result
end

local CACHED_HEAD = ""
function M.git_component(mode)
    local head = vim.b.gitsigns_head
    if not head or head == "" then
        if CACHED_HEAD == "" then
            local result = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null")
            if result and result ~= "" then
                CACHED_HEAD = vim.fn.trim(result)
            end
        end
        head = CACHED_HEAD

    else
        CACHED_HEAD = head
    end

    local branch = " " .. icons.misc.git .. " " .. CACHED_HEAD
    local git_component = "%#" .. highlight_git(mode) .. "#" .. branch

    local result = "%(" .. git_component .. " %)"
    return result
end

function M.dap_component()
    if not package.loaded['dap'] or require('dap').status() == '' then
        return nil
    end
    return string.format('%%#%s#%s  %s', 'Special', icons.misc.bug, require('dap').status())
end

function M.lsp_component()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
        return ''
    end

    local lsp_name = clients[1].name
    if #clients > 1 then
        lsp_name = lsp_name .. ' (+' .. (#clients - 1) .. ')'
    end

    local filetype = vim.bo.filetype
    local webdev_icons = require("nvim-web-devicons")
    local _, color = webdev_icons.get_icon_by_filetype(filetype)
    if color == nil then
        color = "StatusLine"
    end

    local result = string.format('%%#%s#%s', color, lsp_name)
    return result
end

function M.file_type_component()
    local type_, icon
    local icon_color = "StatusLine"

    local filetype = vim.bo.filetype
    if filetype == "" then
        type_ = vim.bo.buftype
        icon = table_get(buf_type_map, type_, icons.symbol_kinds.File)
    elseif special_file_map[filetype] ~= nil then
        type_ = filetype
        icon = special_file_map[filetype]
        if icon == nil then
            icon = "[NO ICON]"
        end
    else
        type_ = filetype
        local webdev_icons = require("nvim-web-devicons")
        icon, icon_color = webdev_icons.get_icon_by_filetype(filetype)
        if icon == nil then
            icon = "[NO ICON]"
        end
        if icon_color == nil then
            icon_color = "StatusLine"
        end
    end

    local content = "%#" .. icon_color .. "#" .. icon .. " " .. "%*" .. "%#" .. icon_color .. "#" .. " " .. type_ .. "%*"
    local result = "%-5(%#StatusLine#" .. content .. "%)"
    return result
end

function M.position_component()
    local line = vim.fn.line(".")
    local column = vim.fn.col(".")
    local result = "%#StatusLineLineColumn#" .. line .. ":" .. column .. "%*"
    return result
end

function M.render()
    local mode = vim.fn.mode()
    local mode_str = table_get(mode_to_str, mode, mode)

    local left_components = {
        M.mode_component(mode_str),
        M.git_component(mode_str),
        "%=",
        M.dap_component(),
    }

    local right_components = {
        "%=",
        M.lsp_component(),
        M.file_type_component(),
        M.position_component(),
    }

    return table.concat(left_components, "") .. " " .. table.concat(right_components, " ")
end

return M
