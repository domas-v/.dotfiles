return {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    opts = {
        styles = { transparency = false }
    },
    {
        "shortcuts/no-neck-pain.nvim",
        enabled = true,
        version = "*",
        cmd = { "NoNeckPain" },
        keys = { { "<leader>|", "<cmd>NoNeckPain<cr>" } }
    }
}
