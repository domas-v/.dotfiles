return {
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            require("bufferline").setup()
            vim.keymap.set("n", "<C-n>", "<cmd>BufferLineCycleNext<CR>")
            vim.keymap.set("n", "<C-p>", "<cmd>BufferLineCyclePrev<CR>")
            vim.keymap.set("n", "<C-1>", "<cmd>BufferLineGoToBuffer 1<CR>")
            vim.keymap.set("n", "<C-2>", "<cmd>BufferLineGoToBuffer 2<CR>")
            vim.keymap.set("n", "<C-3>", "<cmd>BufferLineGoToBuffer 3<CR>")
            vim.keymap.set("n", "<C-4>", "<cmd>BufferLineGoToBuffer 4<CR>")
            vim.keymap.set("n", "<C-5>", "<cmd>BufferLineGoToBuffer 5<CR>")
            vim.keymap.set("n", "<C-6>", "<cmd>BufferLineGoToBuffer 6<CR>")
            vim.keymap.set("n", "<C-7>", "<cmd>BufferLineGoToBuffer 7<CR>")
            vim.keymap.set("n", "<C-8>", "<cmd>BufferLineGoToBuffer 8<CR>")
            vim.keymap.set("n", "<C-9>", "<cmd>BufferLineGoToBuffer 9<CR>")
            vim.keymap.set("n", "<C-]>", "<cmd>BufferLineMoveNext<CR>")
            vim.keymap.set("n", "<C-[>", "<cmd>BufferLineMovePrev<CR>")
            vim.keymap.set("n", "<leader>*", "<cmd>BufferLineTogglePin<CR>")
        end
    }
}
