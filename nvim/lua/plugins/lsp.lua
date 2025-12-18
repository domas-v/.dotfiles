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
            map.set("n", "gd", vim.lsp.buf.definition)
            -- map.set('n', 'gD', vim.diagnostic.open_float)
            map.set('n', '[d', vim.diagnostic.goto_prev)
            map.set('n', ']d', vim.diagnostic.goto_next)
            map.set('n', '<leader><leader>d', "<cmd>lua vim.diagnostic.setqflist()<cr>")
            map.set('n', '<leader>D', "<cmd>lua vim.diagnostic.setloclist()<cr>")
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
                    python = function(bufnr)
                        local get_info = require("conform").get_formatter_info
                        local formatters = {}
                        if get_info("ruff_fix", bufnr).available then
                            table.insert(formatters, "ruff_fix")
                        end
                        if get_info("ruff_format", bufnr).available then
                            table.insert(formatters, "ruff_format")
                        elseif get_info("black", bufnr).available then
                            table.insert(formatters, "black")
                        end
                        if get_info("isort", bufnr).available then
                            table.insert(formatters, "isort")
                        elseif get_info("ruff_organize_imports", bufnr).available then
                            table.insert(formatters, "ruff_organize_imports")
                        end
                        return formatters
                    end,
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
