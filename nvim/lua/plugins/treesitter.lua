return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        config = function()
            require("nvim-treesitter.configs").setup({
                modules = {},
                sync_install = false,
                ignore_install = {},
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
                        node_decremental = "<BS>",
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
                            ["il"] = "@loop.inner",
                            ["al"] = "@loop.outer",
                            ["ii"] = "@conditional.inner",
                            ["ai"] = "@conditional.outer",
                            ["ir"] = "@return.inner",
                            ["ar"] = "@return.outer",
                            ["i="] = "@assignment.inner",
                            ["a="] = "@assignment.outer",
                            ["i/"] = "@comment.inner",
                            ["a/"] = "@comment.outer",
                            ["is"] = "@statement.outer",
                            ["as"] = "@statement.outer",
                        }
                    },
                    swap = {
                        enabled = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]c"] = "@class.outer",
                            ["]a"] = "@parameter.outer",
                            ["]l"] = "@loop.outer",
                            ["]i"] = "@conditional.outer",
                            ["]r"] = "@return.outer",
                            ["]s"] = "@statement.outer"
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                            ["]C"] = "@class.outer",
                            ["]A"] = "@parameter.outer",
                            ["]L"] = "@loop.outer",
                            ["]I"] = "@conditional.outer",
                            ["]R"] = "@return.outer",
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[c"] = "@class.outer",
                            ["[a"] = "@parameter.outer",
                            ["[l"] = "@loop.outer",
                            ["[i"] = "@conditional.outer",
                            ["[r"] = "@return.outer",
                            ["[s"] = "@statement.outer",
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                            ["[C"] = "@class.outer",
                            ["[A"] = "@parameter.outer",
                            ["[L"] = "@loop.outer",
                            ["[I"] = "@conditional.outer",
                            ["[R"] = "@return.outer",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]c"] = "@class.outer",
                            ["]a"] = "@parameter.outer",
                            ["]l"] = "@loop.outer",
                            ["]i"] = "@conditional.outer",
                            ["]r"] = "@return.outer",
                            ["]s"] = "@statement.outer",
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                            ["]C"] = "@class.outer",
                            ["]A"] = "@parameter.outer",
                            ["]L"] = "@loop.outer",
                            ["]I"] = "@conditional.outer",
                            ["]R"] = "@return.outer",
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[c"] = "@class.outer",
                            ["[a"] = "@parameter.outer",
                            ["[l"] = "@loop.outer",
                            ["[i"] = "@conditional.outer",
                            ["[r"] = "@return.outer",
                            ["[s"] = "@statement.outer",
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                            ["[C"] = "@class.outer",
                            ["[A"] = "@parameter.outer",
                            ["[L"] = "@loop.outer",
                            ["[I"] = "@conditional.outer",
                            ["[R"] = "@return.outer",
                        },
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
