return {
    {
        "nvim-telescope/telescope.nvim",
        enabled = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            -- extensions
            "nvim-telescope/telescope-live-grep-args.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make", },
            {
                "danielfalk/smart-open.nvim",
                branch = "0.2.x",
                dependencies = { "kkharji/sqlite.lua" },
            }
        },
        config = function()
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
                    live_grep_args = {
                        auto_quoting = true,
                        mappings = {
                            i = {
                                ["<C-f>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                                ["<C-h>"] = lga_actions.quote_prompt({ postfix = " --hidden " }),
                            },
                        },
                    },
                }
            })

            telescope.load_extension("fzf")
            telescope.load_extension("live_grep_args")
            telescope.load_extension("smart_open")
        end,
        keys = {
            -- shortcuts
            { "<C-e>",      "<cmd>Telescope buffers<cr>",                       desc = "Buffers" },
            { "<C-f>",      "<cmd>Telescope current_buffer_fuzzy_find<cr>",     desc = "Find files" },

            -- file search
            { "<leader>e",  "<cmd>Telescope buffers<cr>",                       desc = "Options" },
            { "<leader>r",  "<cmd>Telescope live_grep_args<cr>",                desc = "Live grep" },
            { "<leader>f",  "<cmd>Telescope smart_open<cr>",                    desc = "Current buffer" },
            { "<leader>o",  "<cmd>Telescope find_files<cr>",                    desc = "Current buffer" },

            { "<leader>s",  "<cmd>Telescope lsp_document_symbols<cr>",          desc = "LSP symbols" },
            { "<leader>S",  "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "LSP workspace symbols" },
            { "<leader>D",  "<cmd>Telescope diagnostics<cr>",                   desc = "Diagnostics" },
            { "<leader>B",  "<cmd>Telescope breakpoints<cr>",                   desc = "Breakpoints" },

            -- utils
            { "<leader>?k", "<cmd>Telescope keymaps<cr>",                       desc = "Keymaps" },
            { "<leader>?c", "<cmd>Telescope commands<cr>",                      desc = "Commands" },
            { "<leader>?t", "<cmd>Telescope help_tags<cr>",                     desc = "Help" },
            { "<leader>?o", "<cmd>Telescope vim_options<cr>",                   desc = "Options" },
        },
        cmd = { "Telescope" },
    }
}
