return {
    {
        "knubie/vim-kitty-navigator",
        build = "cp ./*.py ~/.config/kitty/",
    },
    {
        'mrjones2014/smart-splits.nvim',
        enabled = false,
        lazy = false,
        build = './kitty/install-kittens.bash',
        config = function()
            vim.keymap.set('n', '<C-h>', require("smart-splits").move_cursor_down)
            vim.keymap.set('n', '<C-j>', require("smart-splits").move_cursor_down)
            vim.keymap.set('n', '<C-k>', require("smart-splits").move_cursor_down)
            vim.keymap.set('n', '<C-l>', require("smart-splits").move_cursor_down)
            vim.keymap.set('n', '<C-\\>', require("smart-splits").move_cursor_previous)

            vim.keymap.set('n', '<A-h>', "<cmd>lua require('smart-splits').resize_left(10)<cr>")
            vim.keymap.set('n', '<A-j>', "<cmd>lua require('smart-splits').resize_down(7)<cr>")
            vim.keymap.set('n', '<A-k>', "<cmd>lua require('smart-splits').resize_up(7)<cr>")
            vim.keymap.set('n', '<A-l>', "<cmd>lua require('smart-splits').resize_right(10)<cr>")
        end
    }
}
