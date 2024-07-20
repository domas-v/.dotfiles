return {
    {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup() end,
        event = "InsertEnter",
    },
    {
        "kylechui/nvim-surround",
        config = function() require("nvim-surround").setup({ move_cursor = false }) end,
        event = "InsertEnter",
    },
    {
        "numToStr/Comment.nvim",
        config = function() require("Comment").setup() end
    },
    {
        "ggandor/leap.nvim",
        config = function() require("leap").add_default_mappings() end,
        dependencies = "tpope/vim-repeat",
    },
    {
        "ggandor/flit.nvim",
        config = function()
            require("flit").setup({
                keys = { f = 'f', F = 'F', t = 't', T = '-' },
            })
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("ibl").setup({
                scope = { enabled = false },
            })
        end
    },
    {
        -- remembers where in file I was
        "vladdoster/remember.nvim",
        config = function()
            require('remember')
        end
    },
    {
        -- -- remembers which files were open
        -- "EricDriussi/remember-me.nvim",
        -- config = function()
        --     require("remember_me").setup({
        --         ignore_ft = { "man", "gitignore", "gitcommit" },
        --         session_store = "~/.cache/remember-me/",
        --         ext = ".r.vim",
        --         project_roots = { ".git", ".svn" },
        --     })
        -- end
    },
    { "RRethy/vim-illuminate" },
    -- {
    --     "vhyrro/luarocks.nvim",
    --     priority = 1001, -- this plugin needs to run before anything else
    --     opts = {
    --         rocks = { "magick" },
    --     },
    -- }
}
