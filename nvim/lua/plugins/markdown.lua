return {
    {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "<leader>p", "<cmd>PasteImage<cr>" }
        }
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        ft = "markdown",
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        opts = {
            heading = { sign = false },
            latex = { enabled = false },
            code = { sign = false },
        }
    },
    {
        'Thiago4532/mdmath.nvim',
        ft = "markdown",
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        opts = {
            anticonceal = true,
            dynamic = true,
            hide_on_insert = false,
        }
    },
    {
        "yousefhadder/markdown-plus.nvim",
        ft = "markdown",
        opts = {},
        config = function(_, opts)
            require("markdown-plus").setup(opts)

            local function remove_markdown_plus_gd(bufnr)
                vim.api.nvim_buf_call(bufnr, function()
                    local map = vim.fn.maparg("gd", "n", false, true)
                    if type(map) == "table" and map.buffer == 1 and map.rhs == "<Plug>(MarkdownPlusFollowLink)" then
                        pcall(vim.keymap.del, "n", "gd", { buffer = bufnr })
                    end
                end)
            end

            remove_markdown_plus_gd(vim.api.nvim_get_current_buf())

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "markdown",
                callback = function(args)
                    remove_markdown_plus_gd(args.buf)
                end,
            })

            local function set_table_keymaps(bufnr)
                local nmap = function(lhs, rhs, desc)
                    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
                end
                local imap = function(lhs, rhs, desc)
                    vim.keymap.set("i", lhs, function()
                        vim.api.nvim_feedkeys(
                            vim.api.nvim_replace_termcodes("<Esc>" .. rhs .. "i", true, false, true),
                            "m",
                            false
                        )
                    end, { buffer = bufnr, desc = desc })
                end

                nmap("<A-S-j>", "<Plug>(MarkdownPlusTableInsertRowBelow)", "Insert table row below")
                nmap("<A-S-k>", "<Plug>(MarkdownPlusTableInsertRowAbove)", "Insert table row above")
                nmap("<A-S-l>", "<Plug>(MarkdownPlusTableInsertColumnRight)", "Insert table column right")
                nmap("<A-S-h>", "<Plug>(MarkdownPlusTableInsertColumnLeft)", "Insert table column left")

                imap("<A-S-j>", "<Plug>(MarkdownPlusTableInsertRowBelow)", "Insert table row below")
                imap("<A-S-k>", "<Plug>(MarkdownPlusTableInsertRowAbove)", "Insert table row above")
                imap("<A-S-l>", "<Plug>(MarkdownPlusTableInsertColumnRight)", "Insert table column right")
                imap("<A-S-h>", "<Plug>(MarkdownPlusTableInsertColumnLeft)", "Insert table column left")

                nmap("<A-j>", "<Plug>(MarkdownPlusTableMoveRowDown)", "Move table row down")
                nmap("<A-k>", "<Plug>(MarkdownPlusTableMoveRowUp)", "Move table row up")
                nmap("<A-l>", "<Plug>(MarkdownPlusTableMoveColumnRight)", "Move table column right")
                nmap("<A-h>", "<Plug>(MarkdownPlusTableMoveColumnLeft)", "Move table column left")

                nmap("<A-S-t>", "<Plug>(MarkdownPlusTableFormat)", "Format table")
            end

            vim.api.nvim_create_user_command("MarkdownCreateTable", function()
                vim.api.nvim_feedkeys(
                    vim.api.nvim_replace_termcodes("<Plug>(MarkdownPlusTableCreate)", true, false, true),
                    "m",
                    false
                )
            end, { desc = "Create markdown table" })

            set_table_keymaps(vim.api.nvim_get_current_buf())

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "markdown",
                callback = function(args)
                    set_table_keymaps(args.buf)
                end,
            })
        end,
    }
}
