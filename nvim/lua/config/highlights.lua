local M = {}

function M.get_highlight_by_name(hl_name)
    local hl = vim.api.nvim_get_hl(0, { name = hl_name })
    return hl
end

M.colors = {
    default_bg = M.get_highlight_by_name("StatusLine").bg, -- 2762559 | #2A273F
    default_fg = M.get_highlight_by_name("NormalNC").bg,   -- 2302262 | #232136

    normal = M.get_highlight_by_name("Comment").fg,       -- 15374999 | #EA9A97
    insert = M.get_highlight_by_name("Special").fg,        -- 10276824 | #9CCFD8
    visual = M.get_highlight_by_name("Define").fg,         -- 12888039 | #C4A7E7
    replace = M.get_highlight_by_name("Keyword").fg,       --  4100016 | #3E8FB0
    command = M.get_highlight_by_name("Error").fg,         -- 15429522 | #EB6F92
}

M.normal_mode_group = {
    MODE = {
        name = "status_line_normal",
        hl = { bg = M.colors.normal, fg = M.colors.default_fg, bold = true }
    },
    MODE_SEP = {
        name = "status_line_mode_separator_normal",
        hl = { bg = M.colors.default_fg, fg = M.colors.normal, bold = true }
    },
    GIT = {
        name = "status_line_git_normal",
        hl = { bg = M.colors.default_bg, fg = M.colors.normal }
    },
    GIT_SEP = {},
    FILE = {},
}

M.insert_mode_group = {
    MODE = {
        name = "status_line_insert",
        hl = { bg = M.colors.insert, fg = M.colors.default_fg, bold = true }
    },
    MODE_SEP = {
        name = "status_line_mode_separator_insert",
        hl = { bg = M.colors.default_fg, fg = M.colors.insert, bold = true }
    },
    GIT = {
        name = "status_line_git_insert",
        hl = { bg = M.colors.default_bg, fg = M.colors.insert }
    },
    GIT_SEP = {},
    FILE = {},
}

M.visual_mode_group = {
    MODE = {
        name = "status_line_visual",
        hl = { bg = M.colors.visual, fg = M.colors.default_fg, bold = true }
    },
    MODE_SEP = {
        name = "status_line_mode_separator_visual",
        hl = { bg = M.colors.default_fg, fg = M.colors.visual, bold = true }
    },
    GIT = {
        name = "status_line_git_visual",
        hl = { bg = M.colors.default_bg, fg = M.colors.visual }
    },
    GIT_SEP = {},
    FILE = {},
}

M.replace_mode_group = {
    MODE = {
        name = "status_line_replace",
        hl = { bg = M.colors.replace, fg = M.colors.default_fg, bold = true }
    },
    MODE_SEP = {
        name = "status_line_mode_separator_replace",
        hl = { bg = M.colors.default_fg, fg = M.colors.replace, bold = true }
    },
    GIT = {
        name = "status_line_git_replace",
        hl = { bg = M.colors.default_bg, fg = M.colors.replace }
    },
    GIT_SEP = {},
    FILE = {},
}

M.command_mode_group = {
    MODE = {
        name = "status_line_command",
        hl = { bg = M.colors.command, fg = M.colors.default_fg, bold = true }
    },
    MODE_SEP = {
        name = "status_line_mode_separator_command",
        hl = { bg = M.colors.default_fg, fg = M.colors.command, bold = true }
    },
    GIT = {
        name = "status_line_git_command",
        hl = { bg = M.colors.default_bg, fg = M.colors.command }
    },
    GIT_SEP = {},
    FILE = {},
}

M.groups = {
    NORMAL = M.normal_mode_group,
    INSERT = M.insert_mode_group,
    TERMINAL = M.insert_mode_group,
    VISUAL = M.visual_mode_group,
    REPLACE = M.replace_mode_group,
    COMMAND = M.command_mode_group,
    PROMPT = M.command_mode_group,
    CONFIRM = M.command_mode_group,
}

for _, mode_hl in pairs(M.groups) do
    for _, hl_def in pairs(mode_hl) do
        if hl_def.name then
            vim.api.nvim_set_hl(0, hl_def.name, hl_def.hl)
        end
    end
end

return M
