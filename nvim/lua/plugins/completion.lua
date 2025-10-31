return {
    {
        "saghen/blink.cmp",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "rcarriga/cmp-dap",
            {
                'saghen/blink.compat',
                version = '*',
                lazy = true,
                opts = {
                    debug = true,
                },
            }
        },
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
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
                per_filetype = {
                    sql = { "dadbod", "snippets", "buffer" },
                    mysql = { "dadbod", "snippets", "buffer" },
                    ["dap-repl"] = { "dap", "snippets", "buffer" },
                    codecompanion = { "codecompanion" },
                },
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
