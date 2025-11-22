return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            local map = vim.keymap
            local lsp = vim.lsp

            lsp.enable("pyright")
            lsp.enable("clangd")
            lsp.enable("marksman")
            lsp.enable("lua_ls")

            map.set('n', '<leader>dv', vim.diagnostic.open_float, { desc = "Open diagnostic float" })
            map.set('n', '<leader>dk', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
            map.set('n', '<leader>dj', vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf }
                    map.set('n', 'gd', lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
                    map.set('n', 'gD', lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
                    map.set('n', 'gi', lsp.buf.implementation,
                        vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
                    map.set('n', 'K', lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show hover information" }))
                    map.set('n', 'gn', lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
                    map.set({ 'n', 'v' }, 'ga', lsp.buf.code_action,
                        vim.tbl_extend("force", opts, { desc = "Code action" }))
                    map.set('n', 'gr', lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Find references" }))
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
