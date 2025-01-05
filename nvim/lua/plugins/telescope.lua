return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make", },
            "nvim-telescope/telescope-dap.nvim",
            "LukasPietzschmann/telescope-tabs",
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

            local window_width = 0.7
            local window_height = 0.8
            local cutoff = 200 -- mac window width

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
                            ["<C-s>"] = actions.select_horizontal,
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
                            ["<C-s>"] = actions.select_horizontal,
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
                    layout_strategy = "flex",
                    layout_config = {
                        flex = {
                            flip_columns = cutoff, -- mac screen width
                        },
                        vertical = {
                            mirror = true,
                            prompt_position = "top",
                            preview_height = 0.4,
                            height = window_height,
                            width = window_width,
                        },
                        horizontal = {
                            prompt_position = "top",
                            preview_width = 0.5,
                            height = window_height,
                            width = window_width,
                        }
                    },
                    sort_lastused = true,
                    sorting_strategy = "ascending",
                },
                pickers = {
                    find_files = {
                        follow = true,
                        find_command = { "fd", "--type", "file" }
                    },
                    lsp_dynamic_workspace_symbols = {
                        sorter = telescope.extensions.fzf.native_fzf_sorter(fzf_opts)
                    },
                },
                extensions = {
                    fzf = fzf_opts,
                }
            })

            require("telescope-all-recent").setup({})
            telescope.load_extension("fzf")
            telescope.load_extension("dap")
            require("telescope-tabs").setup({})
        end,
        keys = {

            -- { "<C-;>",      "<cmd>Telescope builtin previewer=false<cr>",                   desc = "Telescope" },
            { "<leader>H",  "<cmd>Telescope help_tags<cr>",                                 desc = "Telescope" },
            { "<leader>K",  "<cmd>Telescope keymaps<cr>",                                   desc = "Telescope" },

            -- tabs
            { "<leader>T",  "<cmd>lua require('telescope-tabs').list_tabs()<cr>",           desc = "Tabs" },

            -- buffers
            { "<C-e>",      "<cmd>Telescope buffers<cr>",                                   desc = "Buffers" },
            { "<leader>e",  "<cmd>Telescope buffers<cr>",                                   desc = "Buffers" },
            { "<leader>f",  "<cmd>Telescope current_buffer_fuzzy_find previewer=false<cr>", desc = "Find files" },

            -- file search
            { "<leader>r",  "<cmd>Telescope live_grep<cr>",                                 desc = "Live grep" },
            { "<leader>o",  "<cmd>Telescope find_files<cr>",                                desc = "Current buffer" },
            { "<leader>O",  "<cmd>Telescope find_files hidden=true no_ignore=true<cr>",     desc = "Find files, including hidden" },

            -- lsp
            { "<leader>s",  "<cmd>Telescope lsp_document_symbols<cr>",                      desc = "LSP symbols" },
            { "<leader>S",  "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",             desc = "LSP workspace symbols" },
            { "<leader>xr", "<cmd>Telescope lsp_references<cr>",                            desc = "LSP references" },
            { "<leader>X",  "<cmd>Telescope diagnostics<cr>",                               desc = "Diagnostics list" },

            -- dap
            { "<leader>B",  "<cmd>Telescope dap list_breakpoints<cr>",                      desc = "Breakpoints" },

            -- help
            { "<leader>?k", "<cmd>Telescope keymaps<cr>",                                   desc = "Keymaps" },
            { "<leader>?c", "<cmd>Telescope commands<cr>",                                  desc = "Commands" },
            { "<leader>?t", "<cmd>Telescope help_tags<cr>",                                 desc = "Help" },
            { "<leader>?o", "<cmd>Telescope vim_options<cr>",                               desc = "Options" },

            -- git
            { "<leader>gB", "<cmd>Telescope git_branches<cr>",                              desc = "Git branches" },
            { "<leader>gS", "<cmd>Telescope git_status<cr>",                                desc = "Git status" },
        },
        cmd = { "Telescope" },
    }
}
