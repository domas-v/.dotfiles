return {
    {
        "saghen/blink.cmp",
        enabled = true,
        dependencies = {
            "rafamadriz/friendly-snippets",
            "MahanRahmati/blink-nerdfont.nvim",
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
                    markdown = { "lsp", "path", "snippets", "buffer", "nerdfont" }
                },
                providers = {
                    dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
                    dap = { name = "dap", module = "blink.compat.source" },
                    nerdfont = {
                        module = "blink-nerdfont",
                        name = "Nerd Fonts",
                        score_offset = 15,
                        opts = { insert = true },
                    }
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
    {
        "hrsh7th/nvim-cmp",
        enabled = false,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "rcarriga/cmp-dap",
            { "L3MON4D3/LuaSnip", build = "make install_jsregexp" }
        },
        config = function()
            local cmp = require("cmp")
            local cmp_select = { behavior = cmp.SelectBehavior.Select }
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
                    ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
                    ["<CR>"]  = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources(
                    {
                        { name = "nvim_lsp" },
                        { name = "nvim_lua" },
                        { name = "luasnip" },
                        { name = "lazydev", group_index = 0 },
                    },
                    {
                        { name = "buffer" },
                        { name = "path" },
                    })
            })
            cmp.setup({
                enabled = function()
                    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
                        or require("cmp_dap").is_dap_buffer()
                end
            })
            cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
                sources = {
                    { name = "dap" },
                },
            })

            local special_next_item = cmp.mapping({
                c = function(fallback)
                    if cmp.visible() then
                        return cmp.select_next_item()
                    end

                    fallback()
                end
            })
            local special_prev_item = cmp.mapping({
                c = function(fallback)
                    if cmp.visible() then
                        return cmp.select_prev_item()
                    end

                    fallback()
                end
            })
            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline({
                    ['<C-j>'] = special_next_item,
                    ['<C-k>'] = special_prev_item
                }),
                sources = {
                    { name = 'buffer' }
                }
            })

            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline({
                    ['<C-j>'] = special_next_item,
                    ['<C-k>'] = special_prev_item
                }),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                })
            })

            cmp.setup.filetype({ "sql", "mysql" }, {
                sources = {
                    { name = "vim-dadbod-completion" },
                    { name = "buffer" },
                },
            })
        end
    }
}
