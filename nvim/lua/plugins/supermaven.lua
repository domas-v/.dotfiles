return {
    {
        "supermaven-inc/supermaven-nvim",
        lazy = false,
        config = function()
            require("supermaven-nvim").setup({})
        end,
        keys = {
            { "<leader>L", "<cmd>SupermavenToggle<cr>", desc = "SuperMaven" },
        }
    },
}
