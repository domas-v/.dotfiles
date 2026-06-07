return {
    {
        "nvim-mini/mini.pairs",
        version = false,
        opts = {}
    },
    {
        "nvim-mini/mini.surround",
        version = false,
        opts = {
            mappings = {
                add = "za",
                delete = "ds",
                find = "zf",
                find_left = "zF",
                highlight = "zh",
                replace = "zr",
                suffix_last = "l",
                suffix_next = "n",
            },
        }
    },
    {
        'nvim-mini/mini.comment',
        version = false,
        opts = {},
    },
    {
        'nvim-mini/mini.cursorword',
        version = false,
        opts = {},
    },
    {
        'nvim-mini/mini.diff',
        version = false,
        config = function()
            local diff = require('mini.diff')
            diff.setup(
                {
                    mappings = {
                        apply = 'ga',
                        reset = 'gA',
                        goto_first = '[G',
                        goto_prev = '[g',
                        goto_next = ']g',
                        goto_last = ']G',
                    }

                }
            )
            vim.keymap.set("n", "gt", "<cmd>lua MiniDiff.toggle_overlay()<cr>")
        end
    },
    {
        'nvim-mini/mini-git',
        version = false,
        main = "mini.git",
        opts = {},
    },
}
