return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            -- extensions
            "nvim-telescope/telescope-live-grep-args.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make", },
            "nvim-telescope/telescope-frecency.nvim",
            "AckslD/nvim-neoclip.lua",
        },
        config = function()
            require('neoclip').setup()
            local actions = require("telescope.actions")
            local action_layout = require("telescope.actions.layout")
            local lga_actions = require("telescope-live-grep-args.actions")
            local telescope = require("telescope")
            local fzf_opts = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
            }

            telescope.setup({
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
                            ["<c-p>"] = action_layout.toggle_preview,
                            ["<c-u>"] = false
                        },
                        n = {
                            ["<j>"] = actions.move_selection_next,
                            ["<k>"] = actions.move_selection_previous,
                            ["<K>"] = actions.results_scrolling_up,
                            ["<J>"] = actions.results_scrolling_down,
                            ["<c-d>"] = actions.delete_buffer,
                            ["<c-l>"] = actions.preview_scrolling_down,
                            ["<c-h>"] = actions.preview_scrolling_up,
                            ["<c-p>"] = action_layout.toggle_preview,
                        }
                    },
                    layout_strategy = "flex",
                    layout_config = {
                        flex = {
                            flip_columns = 300,
                        },
                        horizontal = {
                            height = 0.9,
                            width = 0.65,
                            preview_width = 0.65,
                        },
                        vertical = {
                            height = 0.9,
                            width = 0.65,
                            preview_height = 0.45,
                            preview_cutoff = 34 -- cutoff if not full mac screen
                        }
                    },
                    sort_lastused = true,
                    sorting_strategy = "ascending",
                },
                pickers = {
                    find_files = {
                        follow = true,
                        previewer = true,
                    },
                    lsp_dynamic_workspace_symbols = {
                        sorter = telescope.extensions.fzf.native_fzf_sorter(fzf_opts)
                    },
                    current_buffer_fuzzy_find = {
                        previewer = true,
                    },
                },
                extensions = {
                    fzf = fzf_opts,
                    live_grep_args = {
                        auto_quoting = true,
                        mappings = {
                            i = {
                                ["<C-r>"] = lga_actions.quote_prompt(),
                                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                                ["<C-o>"] = lga_actions.quote_prompt({ postfix = " --hidden " }),
                            },
                        },
                    },
                }
            })

            telescope.load_extension("fzf")
            telescope.load_extension("live_grep_args")
            telescope.load_extension("neoclip")
            telescope.load_extension("frecency")
        end,
        keys = {
            -- shortcuts
            { "<C-e>", "<cmd>Telescope buffers<cr>",                       desc = "Buffers" },
            { "<C-f>", "<cmd>Telescope frecency workspace=CWD<cr>", desc = "Find file" },
            { "<C-y>", "<cmd>Telescope neoclip<cr>",                       desc = "Neoclip" },
            { "<leader>F", "<cmd>Telescope frecency workspace=CWD<cr>", desc = "Find file" },
            { "<leader>s", "<cmd>Telescope current_buffer_fuzzy_find<cr>",     desc = "Current buffer" },
            { "<leader>S", "<cmd>Telescope live_grep_args<cr>",                desc = "Live grep" },
            { "<leader>R", "<cmd>Telescope live_grep_args<cr>",                desc = "Live grep" },
            { "<leader>l",  "<cmd>Telescope lsp_document_symbols<cr>",          desc = "LSP symbols" },
            { "<leader>L",  "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "LSP workspace symbols" },
            { "<leader>D",  "<cmd>Telescope diagnostics<cr>",                   desc = "Diagnostics" },

            -- search
            { "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<cr>",     desc = "Current buffer" },
            { "<leader>fr", "<cmd>Telescope live_grep_args<cr>",                desc = "Live grep" },

            -- file navigation
            { "<leader>ff", "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'fd', '.', '--type', 'file', '--hidden', '--exclude', '.git', '--exclude', 'venv' }})<cr>", desc = "Find files" },
            { "<leader>fg", "<cmd>Telescope git_files<cr>",                     desc = "Git files" },
            { "<leader>fj", "<cmd>Telescope jumplist<cr>",                      desc = "Neoclip" },

            -- utils
            { "<leader>fo", "<cmd>Telescope vim_options<cr>",                   desc = "Options" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>",                     desc = "Help" },
            { "<leader>fk", "<cmd>Telescope keymaps<cr>",                       desc = "Keymaps" },
            { "<leader>fc", "<cmd>Telescope commands<cr>",                      desc = "Commands" },
            { "<leader>fy", "<cmd>Telescope neoclip<cr>",                       desc = "Neoclip" },

            -- lsp
            { "<leader>fl",  "<cmd>Telescope lsp_document_symbols<cr>",          desc = "LSP symbols" },
            { "<leader>fL",  "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "LSP workspace symbols" },
            { "<leader>fd",  "<cmd>Telescope diagnostics<cr>",                   desc = "Diagnostics" },
        },
        cmd = { "Telescope" },
    }
}
