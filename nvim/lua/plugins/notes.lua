return {
    {
        'toppair/peek.nvim',
        build = 'deno task --quiet build:fast',
        keys = {
            { "<leader>mo", "<cmd>PeekOpen<cr>", desc = "PeekOpen" }
        }
    },
    {
        "jbyuki/nabla.nvim",
        keys = {
            { "<leader>me", "<cmd>require'nabla'.enable_virt({autogen = true})<cr>", desc = "Nabla" },
            { "<leader>md", "<cmd>require'nabla'.disable_virt()<cr>", desc = "Disable Nabla" }
        }
    },
    {
        -- TODO: mdeval
    }
}
