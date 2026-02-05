return {
    {
        "MunsMan/kitty-navigator.nvim",
        build = {
            "cp navigate_kitty.py ~/.config/kitty",
            "cp pass_keys.py ~/.config/kitty",
        },
        opts = { keybindings = {} },
    },
    {
        'mikesmithgh/kitty-scrollback.nvim',
        lazy = true,
        cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth', 'KittyScrollbackGenerateCommandLineEditing' },
        event = { 'User KittyScrollbackLaunch' },
        config = function()
            require('kitty-scrollback').setup()
        end,
    }
}
