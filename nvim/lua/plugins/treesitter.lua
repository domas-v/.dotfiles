return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "python",
                    "lua",
                    "c",
                    "markdown",
                    "markdown_inline",
                    "vimdoc",
                    "json",
                    "http",
                },
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
                            ["ia"] = "@parameter.inner",
                            ["aa"] = "@parameter.outer",
                            ["ir"] = "@return.inner",
                            ["ar"] = "@return.outer",
                            ["ii"] = "@conditional.inner",
                            ["ai"] = "@conditional.outer",
                            ["il"] = "@loop.inner",
                            ["al"] = "@loop.outer",
                            ["ib"] = "@block.inner",
                            ["ab"] = "@block.outer",
                            ["i/"] = "@comment.inner",
                            ["a/"] = "@comment.outer",

                        }
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]c"] = "@class.outer",
                            ["]a"] = "@parameter.outer",
                            ["]r"] = "@return.outer",
                            ["]i"] = "@conditional.outer",
                            ["]l"] = "@loop.outer",
                            ["]x"] = "@statement.outer",
                            ["]/"] = "@comment.outer",
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                            ["]C"] = "@class.outer",
                            ["]A"] = "@parameter.outer",
                            ["]R"] = "@return.outer",
                            ["]I"] = "@conditional.outer",
                            ["]L"] = "@loop.outer",
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[c"] = "@class.outer",
                            ["[a"] = "@parameter.outer",
                            ["[r"] = "@return.outer",
                            ["[i"] = "@conditional.outer",
                            ["[l"] = "@loop.outer",
                            ["[/"] = "@comment.outer",
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                            ["[C"] = "@class.outer",
                            ["[A"] = "@parameter.outer",
                            ["[R"] = "@return.outer",
                            ["[I"] = "@conditional.outer",
                            ["[L"] = "@loop.outer",
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
            })
        end,
    }
}
