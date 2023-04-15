return {
    {
        "windwp/nvim-autopairs",
        config = function () require("nvim-autopairs").setup() end,
        event = "InsertEnter",
    },
    {
        "kylechui/nvim-surround",
        config = function () require("nvim-surround").setup({ move_cursor = false }) end,
        event = "InsertEnter",
    },
    {
        "numToStr/Comment.nvim",
        config = function () require("Comment").setup() end
    },
    {
        "ggandor/leap.nvim",
        config = function () require("leap").add_default_mappings() end,
        dependencies = "tpope/vim-repeat",
    },
    {
        "ggandor/flit.nvim",
        config = function () require("flit").setup() end
    },
    {
        "Pocco81/auto-save.nvim",
        config = function() require("auto-save").setup({ execution_message = { message = "" } }) end,
    },
    {
        "smjonas/inc-rename.nvim",
        config = function() require("inc_rename").setup() end,
        keys = {
            { "<leader>rn", ":IncRename ", desc = "Incremental rename" }
        }
    },
    {
        "mg979/vim-visual-multi",
        lazy = false,
        keys = { { "<C-n>" } }
    },
    "RRethy/vim-illuminate",
    {
        "natecraddock/sessions.nvim",
        config = function() require("sessions").setup() end,
    }
}
