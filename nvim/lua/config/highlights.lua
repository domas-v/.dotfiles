local M = {}

M.colors = {
    status_line_bg = "#2A273F",
}

M.groups = {
    NORMAL = {
        MODE = { group = "status_line_normal", hl = { bg = "#EA9A97", bold = true, fg = "#232136", nocombine = true } },
        MODE_SEP = { group = "status_line_mode_separator_normal", hl = { bg = "#232136", bold = true, fg = "#EA9A97", nocombine = true } },
        GIT = { group = "status_line_git_normal", hl = { bg = M.colors.status_line_bg, fg = "#EA9A97", nocombine = true } },
        GIT_SEP = {},
        FILE = {},
    },
    INSERT = {
        MODE = { group = "status_line_insert", hl = { bg = "#9CCFD8", bold = true, fg = "#232136", nocombine = true } },
        MODE_SEP = { group = "status_line_mode_separator_insert", hl = { bg = "#232136", bold = true, fg = "#9CCFD8", nocombine = true } },
        GIT = { group = "status_line_git_insert", hl = { bg = M.colors.status_line_bg, fg = "#9CCFD8", nocombine = true } },
        GIT_SEP = {},
        FILE = {},
    },
    VISUAL = {
        MODE = { group = "status_line_visual", hl = { bg = "#C4A7E7", bold = true, fg = "#232136", nocombine = true } },
        MODE_SEP = { group = "status_line_mode_separator_visual", hl = { bg = "#232136", bold = true, fg = "#C4A7E7", nocombine = true } },
        GIT = { group = "status_line_git_visual", hl = { bg = M.colors.status_line_bg, fg = "#C4A7E7", nocombine = true } },
        GIT_SEP = {},
        FILE = {},
    },
    COMMAND = {
        MODE = { group = "status_line_command", hl = { bg = "#EB6F92", bold = true, fg = "#232136", nocombine = true } },
        MODE_SEP = { group = "status_line_mode_separator_command", hl = { bg = "#232136", bold = true, fg = "#EB6F92", nocombine = true } },
        GIT = { group = "status_line_git_command", hl = { bg = M.colors.status_line_bg, fg = "#EB6F92", nocombine = true } },
        GIT_SEP = {},
        FILE = {},
    },
    REPLACE = {
        MODE = { group = "status_line_replace", hl = { bg = "#3E8FB0", bold = true, fg = "#232136", nocombine = true } },
        MODE_SEP = { group = "status_line_mode_separator_replace", hl = { bg = "#232136", bold = true, fg = "#3E8FB0", nocombine = true } },
        GIT = { group = "status_line_git_replace", hl = { bg = M.colors.status_line_bg, fg = "#3E8FB0", nocombine = true } },
        GIT_SEP = {},
        FILE = {},
    },
}

for _, mode_hl in pairs(M.groups) do
    for _, hl_def in pairs(mode_hl) do
        if hl_def.group then
            vim.api.nvim_set_hl(0, hl_def.group, hl_def.hl)
        end
    end
end

return M
