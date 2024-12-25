return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make", },
            { "nvim-telescope/telescope-fzy-native.nvim", enabled = false },
            "nvim-telescope/telescope-dap.nvim",
            'LukasPietzschmann/telescope-tabs',
            { "prochri/telescope-all-recent.nvim",        dependencies = { "kkharji/sqlite.lua" } },
        },
        config = function()
            local actions = require("telescope.actions")
            local action_layout = require("telescope.actions.layout")
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
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-d>"] = actions.delete_buffer,
                            ["<C-l>"] = actions.preview_scrolling_down,
                            ["<C-h>"] = actions.preview_scrolling_up,
                            ["<C-q>"] = function(prompt_bufnr)
                                actions.smart_send_to_qflist(prompt_bufnr)
                                vim.cmd("copen")
                            end,
                            ["<C-p>"] = action_layout.toggle_preview,
                            ["<C-u>"] = false
                        },
                        n = {
                            ["<j>"] = actions.move_selection_next,
                            ["<J>"] = actions.results_scrolling_down,
                            ["<k>"] = actions.move_selection_previous,
                            ["<K>"] = actions.results_scrolling_up,
                            ["<C-d>"] = actions.delete_buffer,
                            ["<C-l>"] = actions.preview_scrolling_down,
                            ["<C-h>"] = actions.preview_scrolling_up,
                            ["<C-q>"] = function(prompt_bufnr)
                                actions.smart_send_to_qflist(prompt_bufnr)
                                vim.cmd("copen")
                            end,
                            ["<C-p>"] = action_layout.toggle_preview,
                        }
                    },
                    theme = "dropdown",
                    layout_strategy = "bottom_pane",
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
                }
            })

            require("telescope-all-recent").setup({})
            telescope.load_extension("fzf")
            telescope.load_extension("dap")
            require('telescope-tabs').setup({})
        end,
        keys = {
            { "<C-;>",      "<cmd>Telescope<cr>",                                                      desc = "Telescope" },

            -- tabs
            { "<leader>T",  "<cmd>lua require('telescope-tabs').list_tabs()<cr>",                      desc = "Tabs" },

            -- buffers
            { "<C-e>",      "<cmd>Telescope buffers<cr>",                                              desc = "Buffers" },
            { "<leader>e",  "<cmd>Telescope buffers<cr>",                                              desc = "Buffers" },
            { "<leader>f",  "<cmd>Telescope current_buffer_fuzzy_find<cr>",                            desc = "Find files" },

            -- file search
            { "<leader>r",  "<cmd>Telescope live_grep<cr>",                                            desc = "Live grep" },
            { "<leader>o",  "<cmd>Telescope find_files<cr>",                                           desc = "Current buffer" },
            { "<leader>O",  '<cmd>lua require("telescope.builtin").find_files({ hidden = true })<cr>', desc = "Find files, including hidden" },

            -- lsp
            { "<leader>s",  "<cmd>Telescope lsp_document_symbols<cr>",                                 desc = "LSP symbols" },
            { "<leader>S",  "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",                        desc = "LSP workspace symbols" },

            -- dap & diagnostics
            { "<leader>db", "<cmd>Telescope dap list_breakpoints<cr>",                                 desc = "Breakpoints" },
            { "<leader>dl", "<cmd>Telescope diagnostics<cr>",                                          desc = "Diagnostics list" },

            -- help
            { "<leader>?k", "<cmd>Telescope keymaps<cr>",                                              desc = "Keymaps" },
            { "<leader>?c", "<cmd>Telescope commands<cr>",                                             desc = "Commands" },
            { "<leader>?t", "<cmd>Telescope help_tags<cr>",                                            desc = "Help" },
            { "<leader>?o", "<cmd>Telescope vim_options<cr>",                                          desc = "Options" },

            -- git
            { "<leader>gB", "<cmd>Telescope git_branches<cr>",                                         desc = "Git branches" },
            { "<leader>gS", "<cmd>Telescope git_status<cr>",                                           desc = "Git status" },
        },
        cmd = { "Telescope" },
    }
}
