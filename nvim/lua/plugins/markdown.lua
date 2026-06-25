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
        end,
    }
}
