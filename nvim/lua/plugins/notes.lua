return {
    {
        "jbyuki/nabla.nvim",
        keys = { { "<leader>nm", "<cmd>lua require('nabla').toggle_virt()<cr>", desc = "Enable math" } }
    },
    {
        "toppair/peek.nvim",
        build = 'deno task --quiet build:fast',
        config = function() require("peek").setup({ app = "browser" }) end,
        keys = {
            { "<leader>no", "<cmd>lua require('peek').open()<cr>",  desc = "Open markdown preview" },
            { "<leader>nc", "<cmd>lua require('peek').close()<cr>", desc = "Close markdown preview" }
        }
    },
    -- {
    --     "jubnzv/mdeval.nvim",
    --     config = function ()
    --         require("mdeval").setup({
    --
    --         })
    --     end
    -- }
}
