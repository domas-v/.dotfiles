return {
    {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        opts = {
            heading = { sign = false },
            latex = { enabled = false },
            code = { sign = false },
        }
    }
}
