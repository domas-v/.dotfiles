return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make", },
            "nvim-telescope/telescope-dap.nvim",
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
            local cutoff = 190 -- mac window width

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
                            ["<C-f>"] = actions.preview_scrolling_down,
                            ["<C-b>"] = actions.preview_scrolling_up,
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
                    -- layout_strategy = "flex",
                    -- layout_config = {
                    --     flex = {
                    --         flip_columns = cutoff, -- mac screen width
                    --     },
                    --     vertical = {
                    --         mirror = true,
                    --         prompt_position = "top",
                    --         preview_height = 0.4,
                    --         height = window_height,
                    --         width = window_width,
                    --     },
                    --     horizontal = {
                    --         prompt_position = "top",
                    --         preview_width = 0.5,
                    --         height = window_height,
                    --         width = window_width,
                    --     }
                    -- },
                    sort_lastused = true,
                    sorting_strategy = "ascending",
                },
                pickers = {
                    find_files = {
                        follow = true,
                        find_command = { "fd", "--type", "file" },
                        theme = "ivy"
                    },
                    live_grep = { theme = "ivy" },
                    current_buffer_fuzzy_find = { theme = "ivy" },
                    buffers = { theme = "ivy" },
                    help_tags = { theme = "ivy" },
                    lsp_document_symbols = { theme = "ivy" },
                    lsp_dynamic_workspace_symbols = {
                        sorter = telescope.extensions.fzf.native_fzf_sorter(fzf_opts),
                        { theme = "ivy" }
                    },
                },
                extensions = {
                    fzf = fzf_opts,
                }
            })

            require("telescope-all-recent").setup({})
            telescope.load_extension("fzf")
            telescope.load_extension("dap")
        end,
        keys = {
            { "<leader><leader>r", "<cmd>Telescope resume<cr>" },
            { "<leader>H",         "<cmd>Telescope help_tags<cr>" },
            { "<leader>K",         "<cmd>Telescope keymaps<cr>" },
            { "<leader>C",         "<cmd>Telescope quickfix<cr>" },
            { "<leader>J",         "<cmd>Telescope jumplist<cr>" },
            { "<leader>V",         "<cmd>Telescope marks<cr>" },

            -- buffers
            { "<leader>,",         "<cmd>Telescope buffers<cr>" },
            { "<leader>f",         "<cmd>Telescope current_buffer_fuzzy_find previewer=false<cr>" },

            -- search
            { "<leader>r",         "<cmd>Telescope live_grep<cr>" },
            { "<leader>G",         "<cmd>Telescope grep_string<cr>" },
            { "<leader>o",         "<cmd>Telescope find_files<cr>" },
            { "<leader>O",         "<cmd>Telescope find_files hidden=true no_ignore=true<cr>" },

            -- lsp
            { "<leader>s",         "<cmd>Telescope lsp_document_symbols<cr>" },
            { "<leader>S",         "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>" },
            { "<leader>R",         "<cmd>Telescope lsp_references<cr>" },
            { "<leader>D",         "<cmd>Telescope diagnostics<cr>" },

            -- dap
            { "<leader>B",         "<cmd>Telescope dap list_breakpoints<cr>" },

            -- help
            { "<leader>?k",        "<cmd>Telescope keymaps<cr>" },
            { "<leader>?c",        "<cmd>Telescope commands<cr>" },
            { "<leader>?t",        "<cmd>Telescope help_tags<cr>" },
            { "<leader>?o",        "<cmd>Telescope vim_options<cr>" },

            -- git
            { "<leader>gb",        "<cmd>Telescope git_branches<cr>" },
            { "<leader>gs",        "<cmd>Telescope git_status<cr>" },
        },
        cmd = { "Telescope" },
    }
}
