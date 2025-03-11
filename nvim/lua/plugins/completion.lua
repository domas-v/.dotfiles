local function is_dap_buffer()
    return require("cmp_dap").is_dap_buffer()
end
return {
    {
        'saghen/blink.compat',
        version = '*',
        lazy = true,
        opts = {},
    },
    {
        "saghen/blink.cmp",
        enabled = true,
        dependencies = { "rafamadriz/friendly-snippets", "rcarriga/cmp-dap" },
        version = "*",
        opts = {
            cmdline = {
                enabled = true,
                keymap = {
                    ["<CR>"] = { "accept", "fallback" },
                    ["<C-j>"] = { "select_next" },
                    ["<C-k>"] = { "select_prev" },
                    ["<C-n>"] = { "select_next" },
                    ["<C-p>"] = { "select_prev" },
                    ["<TAB>"] = { "select_and_accept" }
                },
                completion = {
                    list = {
                        selection = {
                            preselect = false,
                        },
                    },
                    menu = { auto_show = true },
                }
            },
            keymap = {
                preset = "default",
                ["<CR>"] = { "accept", "fallback" },
                ["<C-j>"] = { "select_next" },
                ["<C-k>"] = { "select_prev" },
            },
            enabled = function()
                return vim.bo.buftype ~= "prompt" or is_dap_buffer()
            end,
            sources = {
                default = function(_)
                    local sql_filetypes = { mysql = true, sql = true }
                    if sql_filetypes[vim.bo.filetype] ~= nil then
                        return { "dadbod", "snippets", "buffer" }
                    elseif is_dap_buffer() then
                        return { "dap", "snippets", "buffer" }
                    else
                        return { "lsp", "path", "snippets", "buffer" }
                    end
                end,
                providers = {
                    dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
                    dap = { name = "dap", module = "blink.compat.source" },
                },
            },
            completion = {
                accept = { auto_brackets = { enabled = true } },
                list = {
                    selection = {
                        preselect = true,
                        auto_insert = true
                    }
                },
            },
        },
        opts_extend = { "sources.default" },
    },
}
