return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local map = vim.keymap
            local lsp = vim.lsp

            lspconfig.pyright.setup({})
            lspconfig.lua_ls.setup({ settings = { Lua = { diagnostics = { disable = { "missing-fields" } } } } })
            lspconfig.clangd.setup({})
            lspconfig.marksman.setup({})

            map.set('n', '<leader>dv', vim.diagnostic.open_float)
            map.set('n', '<leader>dk', vim.diagnostic.goto_prev)
            map.set('n', '<leader>dj', vim.diagnostic.goto_next)
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf }
                    map.set('n', 'gd', lsp.buf.definition, opts)
                    map.set('n', 'gD', lsp.buf.declaration, opts)
                    map.set('n', 'gi', lsp.buf.implementation, opts)
                    map.set('n', 'K', lsp.buf.hover, opts)
                    map.set('n', 'R', lsp.buf.rename, opts)
                    map.set({ 'n', 'v' }, 'ga', lsp.buf.code_action, opts)
                    map.set('n', 'gr', lsp.buf.references, opts)
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
        ft = "lua",
        opts = { library = { { path = "luvit-meta/library", words = { "vim%.uv" } } } },
        dependencies = { "Bilal2453/luvit-meta", lazy = true }
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
