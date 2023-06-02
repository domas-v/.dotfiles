return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "kyazdani42/nvim-web-devicons",
            "nvim-telescope/telescope-live-grep-args.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make", },
            { "AckslD/nvim-neoclip.lua",                  config = function() require("neoclip").setup() end, },
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
                    layout_strategy = "vertical",
                    layout_config = {
                        flex = {
                            flip_columns = 200,
                        },
                        horizontal = {
                            height = 0.8,
                            width = 0.8,
                            preview_width = 0.65,
                        },
                        vertical = {
                            height = 0.8,
                            width = 0.6,
                            preview_height = 0.4,
                            preview_cutoff = 34 -- cutoff if not full mac screen
                        }
                    },
                    sort_lastused = true,
                    sorting_strategy = "ascending",
                },
                pickers = {
                    find_files = { theme = "ivy" },
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
                    file_browser = {
                        theme = "ivy",
                        hijack_netrw = true,
                    }
                }
            })

            require("telescope").load_extension("fzf")
            require("telescope").load_extension("neoclip")
            require("telescope").load_extension("live_grep_args")
            require("telescope").load_extension("session-lens")
            require("telescope").load_extension("file_browser")
        end,
        keys = {
            -- file searching
            { "<leader>ff", "<cmd>Telescope find_files<cr>",                                 desc = "Find files" },
            { "<leader>fg", "<cmd>Telescope git_files<cr>",                                  desc = "Git files" },
            { "<leader>fo", "<cmd>Telescope old_files<cr>",                                  desc = "Old files" },
            { "<leader>s",  "<cmd>Telescope current_buffer_fuzzy_find<cr>",                  desc = "Current buffer" },
            { "<leader>S",  "<cmd>Telescope live_grep_args<cr>",                             desc = "Live grep" },
            { "<leader>F",  "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", desc = "File browser" },
            { "<leader>f.", "<cmd>Telescope file_browser<cr>",                               desc = "File browser" },

            -- utils
            { "<leader>f,", "<cmd>Telescope vim_options<cr>",                                desc = "Options" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>",                                  desc = "Help" },
            { "<leader>fk", "<cmd>Telescope keymaps<cr>",                                    desc = "Keymaps" },
            { "<leader>fc", "<cmd>Telescope commands<cr>",                                   desc = "Commands" },

            -- lsp
            { "<leader>l",  "<cmd>Telescope lsp_document_symbols<cr>",                       desc = "LSP symbols" },
            { "<leader>L",  "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",              desc = "LSP workspace symbols" },
            { "<leader>fr", "<cmd>Telescope lsp_references<cr>",                             desc = "LSP references" },
            { "<leader>fd", "<cmd>Telescope diagnostics<cr>",                                desc = "Diagnostics" },
            { "<leader>ft", "<cmd>TodoTelescope<cr>",                                        desc = "Todo" },

            -- misc
            { "<leader>fs", "<cmd>Telescope session-lens search_session<cr>",                desc = "Sessions" },
            { "<leader>fy", "<cmd>Telescope neoclip<cr>",                                    desc = "Clipboard" },
            { "<leader>fj", "<cmd>Telescope jumplist<cr>",                                   desc = "Jumplist" },
            { "<leader>b",  "<cmd>Telescope buffers<cr>",                                    desc = "Buffers" },
        },
        cmd = { "Telescope" },
    }
}
