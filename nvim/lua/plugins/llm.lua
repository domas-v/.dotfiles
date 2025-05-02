return {
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        enabled = false,
        build = "make",
        version = false,
        opts = {
            providers = {
                {
                    name = "Claude",
                    provider = "claude",
                    model = "claude-3-7-sonnet-20240229",
                },
                {
                    name = "Claude Haiku",
                    provider = "claude",
                    model = "claude-3-haiku-20240307",
                },
            },
            default_provider = "Claude",
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
    },
}
