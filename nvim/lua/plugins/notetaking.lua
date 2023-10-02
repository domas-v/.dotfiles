return {
    {
        "folke/zen-mode.nvim",
    },
    {
        "jbyuki/nabla.nvim",
        lazy = false,
        keys = {
            { "<leader>vv", "<cmd>lua require('nabla').popup()<CR>" },
            { "<leader>ve", "<cmd>lua require('nabla').enable_virt()<CR>" },
            { "<leader>vd", "<cmd>lua require('nabla').disable_virt()<CR>" },
        },

    }
}
