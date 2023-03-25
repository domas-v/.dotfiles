return {
    'ThePrimeagen/harpoon',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    keys = {
        { "<leader>em", "<cmd>lua require('harpoon.mark').add_file()<CR>", desc = "Harpoon add file" },
        { "<leader>ee", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", desc = "Harpoon quick menu" },
        { "<leader>e1", "<cmd>lua require('harpoon.ui').nav_file(1)<CR>", desc = "Harpoon go to file 1" },
        { "<leader>e2", "<cmd>lua require('harpoon.ui').nav_file(2)<CR>", desc = "Harpoon go to file 2" },
        { "<leader>e3", "<cmd>lua require('harpoon.ui').nav_file(3)<CR>", desc = "Harpoon go to file 3" },
        { "<leader>e4", "<cmd>lua require('harpoon.ui').nav_file(4)<CR>", desc = "Harpoon go to file 4" },
        { "<leader>e5", "<cmd>lua require('harpoon.ui').nav_file(5)<CR>", desc = "Harpoon go to file 5" },
        { "<leader>ek", "<cmd>lua require('harpoon.ui').nav_next()<CR>", desc = "Harpoon next file" },
        { "<leader>ej", "<cmd>lua require{'harpoon.ui'}.nav_prev()<CR>", desc = "Harpoon prev file" },
    }
}
