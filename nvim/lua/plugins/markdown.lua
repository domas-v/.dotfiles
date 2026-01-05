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
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        opts = {
            heading = { sign = false },
            latex = { enabled = false },
            code = { sign = false },
        }
    },
    {
        'Thiago4532/mdmath.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        opts = {
            anticonceal = true,
            dynamic = true,
            hide_on_insert = false,
        }
    },
}
