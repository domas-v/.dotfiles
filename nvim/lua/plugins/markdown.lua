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
        enabled = true,
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

                nmap("<A-C-j>", "<Plug>(MarkdownPlusTableInsertRowBelow)", "Insert table row below")
                nmap("<A-C-k>", "<Plug>(MarkdownPlusTableInsertRowAbove)", "Insert table row above")
                nmap("<A-C-l>", "<Plug>(MarkdownPlusTableInsertColumnRight)", "Insert table column right")
                nmap("<A-C-h>", "<Plug>(MarkdownPlusTableInsertColumnLeft)", "Insert table column left")

                local moves = {
                    { "<A-S-j>", "TableMoveRowDown", "Move table row down" },
                    { "<A-S-k>", "TableMoveRowUp", "Move table row up" },
                    { "<A-S-l>", "TableMoveColumnRight", "Move table column right" },
                    { "<A-S-h>", "TableMoveColumnLeft", "Move table column left" },
                }
                for _, move in ipairs(moves) do
                    local lhs, plug, desc = unpack(move)
                    nmap(lhs, "<Plug>(MarkdownPlus" .. plug .. ")", desc)
                    imap(lhs, "<Plug>(MarkdownPlus" .. plug .. ")", desc)
                end

                local navs = {
                    { "<A-h>", "left", "h", "TableNavLeft" },
                    { "<A-j>", "down", "j", "TableNavDown" },
                    { "<A-k>", "up", "k", "TableNavUp" },
                    { "<A-l>", "right", "l", "TableNavRight" },
                }
                for _, nav in ipairs(navs) do
                    local lhs, direction, fallback, plug = unpack(nav)
                    nmap(lhs, function()
                        if not require("markdown-plus.table.navigation")["move_" .. direction]() then
                            vim.cmd.normal({ args = { vim.v.count1 .. fallback }, bang = true })
                        end
                    end, "Navigate to table cell " .. direction)
                    vim.keymap.set("i", lhs, "<Plug>(MarkdownPlus" .. plug .. ")",
                        { buffer = bufnr, desc = "Navigate to table cell " .. direction })
                end

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
