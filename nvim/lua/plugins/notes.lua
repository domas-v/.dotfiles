return {
    {
        "jbyuki/nabla.nvim",
        keys = { { "<leader>mm", "<cmd>lua require('nabla').toggle_virt()<cr>", desc = "Enable math" } }
    },
    {
        "toppair/peek.nvim",
        build = 'deno task --quiet build:fast',
        config = function() require("peek").setup({ app = "browser" }) end,
        keys = {
            { "<leader>mo", "<cmd>lua require('peek').open()<cr>",  desc = "Open markdown preview" },
            { "<leader>mc", "<cmd>lua require('peek').close()<cr>", desc = "Close markdown preview" }
        }
    },
    -- {
    --     "edluffy/hologram.nvim",
    --     config = function()
    --         require('hologram').setup({ auto_display = true })
    --     end
    -- }
    -- {
    -- sniprun
    -- }
}
