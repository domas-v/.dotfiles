return {
    {
        "neovim/nvim-lspconfig",
        -- TODO: lua neovim LSP
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.pyright.setup {
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = "off",
                        },
                    },
                },
            }
            lspconfig.clangd.setup {
                cmd = { "clangd",
                    "--offset-encoding=utf-16" }
            }
            lspconfig.marksman.setup {}
            lspconfig.lua_ls.setup {}

            vim.keymap.set('n', '<leader>dv', vim.diagnostic.open_float)
            vim.keymap.set('n', '<leader>dk', vim.diagnostic.goto_prev)
            vim.keymap.set('n', '<leader>dj', vim.diagnostic.goto_next)
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf }
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    -- vim.keymap.set('n', '<space>n', vim.lsp.buf.type_definition, opts)
                    vim.keymap.set('n', '<leader>dR', vim.lsp.buf.rename, opts)
                    vim.keymap.set({ 'n', 'v' }, '<leader>dA', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)
                    -- vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, opts)
                    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                end,
            })
        end
    },
    {
        "mfussenegger/nvim-lint",
        config = function()
            local linting = require("lint")
            linting.linters_by_ft = {
                python = { 'flake8' },
            }

            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                callback = function()
                    linting.try_lint()
                end,
            })
        end
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
        dependencies = { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    },
    {
        "hrsh7th/nvim-cmp",
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
                        { name = "lazydev", group_index = 0 }, -- set group index to 0 to skip loading LuaLS completions
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
    },
    {
        "stevearc/conform.nvim",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    python = { "black", "isort" },
                    c = { "clang-format" },
                    json = { "jq" }
                },
                formatters = {
                    jq = {
                        args = { "--indent", "4" },
                    }
                }
            })

            vim.api.nvim_create_user_command("Format", function(args)
                local range = nil
                if args.count ~= -1 then
                    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                    range = {
                        start = { args.line1, 0 },
                        ["end"] = { args.line2, end_line:len() },
                    }
                end
                require("conform").format({ async = true, lsp_fallback = true, range = range })
            end, { range = true })
        end,
        keys = {
            { "<leader>F", ":Format<CR>", desc = "Format the current buffer", silent = true },
            { "<leader>F", ":Format<CR>", desc = "Format selection",          silent = true, mode = "v", }
        }
    },
}
