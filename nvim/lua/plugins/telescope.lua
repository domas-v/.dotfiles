return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "kyazdani42/nvim-web-devicons",
            "nvim-telescope/telescope-live-grep-args.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make", },
        },
        config = function()
            local actions = require("telescope.actions")
            local lga_actions = require("telescope-live-grep-args.actions")

            require("telescope").setup({
                defaults = {
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--trim",
                    },
                    mappings = {
                        i = {
                            ["<c-j>"] = actions.move_selection_next,
                            ["<c-k>"] = actions.move_selection_previous,
                            ["<c-d>"] = actions.delete_buffer,
                            ["<c-l>"] = actions.preview_scrolling_down,
                            ["<c-h>"] = actions.preview_scrolling_up,
                        },
                        n = {
                            ["<j>"] = actions.move_selection_next,
                            ["<k>"] = actions.move_selection_previous,
                            ["<c-d>"] = actions.delete_buffer,
                            ["<c-l>"] = actions.preview_scrolling_down,
                            ["<c-h>"] = actions.preview_scrolling_up,
                        }
                    },
                    layout_strategy = "flex",
                    layout_config = {
                        flex = {
                            flip_columns = 150,
                        },
                        horizontal = {
                            height = 0.99,
                            width = 0.99,
                            preview_width = 0.65,
                        },
                        vertical = {
                            height = 0.9,
                            width = 0.8,
                            preview_height = 0.4,
                            preview_cutoff = 34 -- cutoff if not full mac screen
                        }
                    },
                    sort_lastused = true,
                    sorting_strategy = "ascending",
                },
                pickers = {
                    current_buffer_fuzzy_find = {
                        theme = "ivy"
                    },
                    lsp_document_symbols = {
                        theme = "ivy"
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                    live_grep_args = {
                        auto_quoting = true,
                        mappings = {
                            i = {
                                ["<C-e>"] = lga_actions.quote_prompt(),
                                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                                ["<C-h>"] = lga_actions.quote_prompt({ postfix = " --hidden " }),
                            },
                        },
                    },
                }
            })

            require("telescope").load_extension("fzf")
            require("telescope").load_extension("live_grep_args")
        end,
        keys = {
            -- buffers
            { "<C-e>",      "<cmd>Telescope buffers<cr>",                       desc = "Buffers" },
            { "<leader>e",  "<cmd>Telescope buffers<cr>",                       desc = "Buffers" },
            { "<leader>j",  "<cmd>Telescope buffers<cr>",                       desc = "Buffers" },
            { "<leader>s",  "<cmd>Telescope current_buffer_fuzzy_find<cr>",     desc = "Current buffer" },
            { "<leader>S",  "<cmd>Telescope live_grep_args<cr>",                desc = "Live grep" },

            -- file searching
            { "<C-f>", "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'fd', '.', '-t', 'f', '-H', '-E', '.git', '-E', 'venv' }})<cr>", desc = "Find files" },
            { "<leader>J",  "<cmd>Telescope find_files<cr>",                    desc = "Find files" },
            { "<leader>ff", "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'fd', '.', '-t', 'f', '-H', '-E', '.git', '-E', 'venv' }})<cr>", desc = "Find files" },
            { "<leader>fg", "<cmd>Telescope git_files<cr>",                     desc = "Git files" },
            { "<leader>fo", "<cmd>Telescope oldfiles<cr>",                      desc = "Old files" },

            -- utils
            { "<leader>f,", "<cmd>Telescope vim_options<cr>",                   desc = "Options" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>",                     desc = "Help" },
            { "<leader>fk", "<cmd>Telescope keymaps<cr>",                       desc = "Keymaps" },
            { "<leader>fc", "<cmd>Telescope commands<cr>",                      desc = "Commands" },

            -- lsp
            { "<leader>l",  "<cmd>Telescope lsp_document_symbols<cr>",          desc = "LSP symbols" },
            { "<leader>L",  "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "LSP workspace symbols" },
            { "<leader>fr", "<cmd>Telescope lsp_references<cr>",                desc = "LSP references" },
            { "<leader>fd", "<cmd>Telescope diagnostics<cr>",                   desc = "Diagnostics" },
        },
        cmd = { "Telescope" },
    }
}
