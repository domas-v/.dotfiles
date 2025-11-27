
local M = {}

M.mode_to_str = {
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
M.mode_map = {
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
    ["CONFIRM"] = "CONFIRM",

    ["MORE"] = "MORE",
    ["SHELL"] = "SHELL",
    ["TERMINAL"] = "TERMINAL",
}

return M
