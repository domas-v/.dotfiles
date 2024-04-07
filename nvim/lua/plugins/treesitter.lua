return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        config = function ()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {
                    "vimdoc",
                    "markdown",
                    "python",
                    "lua",
                    "json",
                    "c"
                },
                sync_install = false,
                auto_install = false,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<CR>",
                        node_incremental = "<CR>",
                        scope_incremental = "<TAB>",
                        node_decremental = "<S-Tab>",
                    },
                },
                indent = {
                    enable = false,
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["if"] = "@function.inner",
                            ["af"] = "@function.outer",
                            ["ic"] = "@class.inner",
                            ["ac"] = "@class.outer",
                        }
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]c"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                            ["]C"] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[c"] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                            ["[C"] = "@class.outer",
                        }
                    },
                    lsp_interop = {
                        enable = true,
                        border = "none",
                        floating_preview_opts = {},
                        peek_definition_code = {
                            ["gp"] = "@function.outer",
                            ["gP"] = "@class.outer",
                        },
                    },
                }
            }
        end,
    }
}
