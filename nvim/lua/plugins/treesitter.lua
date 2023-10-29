return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
            -- "p00f/nvim-ts-rainbow",
            "nvim-treesitter/playground",
            "nvim-treesitter/nvim-treesitter-textobjects"
        },
        config = function ()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {
                    "help",
                    "python",
                    "lua",
                    "vim",
                    "json",
                    "http"
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
                            ["i#"] = "@comment.inner",
                            ["a#"] = "@comment.outer",
                            ["is"] = "@statement.inner",
                            ["as"] = "@statement.outer",
                            ["ii"] = "@conditional.inner",
                            ["ai"] = "@conditional.outer",
                            ["il"] = "@loop.inner",
                            ["al"] = "@loop.outer",
                            ["ib"] = "@block.inner",
                            ["ab"] = "@block.outer",
                        }
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]c"] = "@class.outer",
                            ["]b"] = "@block.outer",
                            ["]s"] = "@statement.outer"
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                            ["]C"] = "@class.outer",
                            ["]B"] = "@block.outer",
                            ["]S"] = "@statement.outer"
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[c"] = "@class.outer",
                            ["[b"] = "@block.outer",
                            ["[s"] = "@statement.outer"
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                            ["[C"] = "@class.outer",
                            ["[B"] = "@block.outer",
                            ["[S"] = "@statement.outer"
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
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function ()
            vim.keymap.set("n", "<C-y>", function()
                require("treesitter-context").go_to_context()
            end, { silent = true })
            vim.keymap.set("n", "<C-c><C-t>", "<cmd>TSContextToggle<cr>", { silent = true })
            vim.keymap.set("n", "<leader>ct", "<cmd>TSContextToggle<cr>", { silent = true })
        end
    }
}
