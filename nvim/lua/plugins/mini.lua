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
                add = "cs",
                delete = "cd",
                find = "cf",
                find_left = "cF",
                highlight = "ch",
                replace = "cr",
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
        opts = {
            mappings = {
                apply = 'ga',
                reset = 'gA',
                goto_first = '[G',
                goto_prev = '[g',
                goto_next = ']g',
                goto_last = ']G',
            }
        }
    },
    {
        'nvim-mini/mini-git',
        version = false,
        main = "mini.git",
        opts = {},
    },
}
