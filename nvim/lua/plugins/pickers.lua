return {
    {
        'nvim-telescope/telescope.nvim',
        enabled = true,
        tag = 'v0.2.0',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'ronandalton/telescope-recent-files.nvim',
            "nvim-telescope/telescope-file-browser.nvim",
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build =
                'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install'
            }
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            local action_layout = require("telescope.actions.layout")
            local strategy = "vertical"
            local config = {
                width = 0.6,
                height = 0.9,
                preview_cutoff = 30,
            }

            telescope.setup {
                defaults = {
                    layout_strategy = strategy,
                    layout_config = config,
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-f>"] = actions.preview_scrolling_down,
                            ["<C-b>"] = actions.preview_scrolling_up,
                            ["<C-a>"] = actions.toggle_all,
                            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                            ["<M-p>"] = action_layout.toggle_preview,
                            ["<C-d>"] = actions.delete_buffer + actions.move_to_top,
                        },
                        n = {
                            ["j"] = actions.move_selection_next,
                            ["k"] = actions.move_selection_previous,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-f>"] = actions.preview_scrolling_down,
                            ["<C-b>"] = actions.preview_scrolling_up,
                            ["<C-a>"] = actions.toggle_all,
                            ["<C-S-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                            ["<M-p>"] = action_layout.toggle_preview,
                            ["<C-d>"] = actions.delete_buffer + actions.move_to_top,
                        },
                    },
                },
                pickers = {
                    current_buffer_fuzzy_find = { previewer = false, }
                },
                extensions = {
                    file_browser = {
                        display_stat = false,
                        preview = { ls_short = true, }
                    },
                },
            }
            telescope.load_extension('fzf')
            telescope.load_extension('recent-files')
            telescope.load_extension('file_browser')

            local builtin = require('telescope.builtin')
            local ivy = require('telescope.themes').get_ivy()
            local map = vim.keymap.set
            local small_prev = {
                layout_strategy = strategy,
                layout_config = {
                    width = config.width,
                    height = config.height,
                    preview_cutoff = config.preview_cutoff,
                    preview_height = 0.3
                }
            }

            map("n", "<leader>h", function() builtin.help_tags({ previewer = false }) end)
            map('n', '<leader>/', function() builtin.current_buffer_fuzzy_find(ivy) end)
            map('n', '<leader>f', function() telescope.extensions['recent-files'].recent_files(small_prev) end)
            map('n', '<leader>r', function() builtin.live_grep(ivy) end)
            vim.keymap.set("n", "<leader>e", function()
                require("telescope").extensions.file_browser.file_browser(
                    {
                        layout_strategy = "horizontal",
                        layout_config = {
                            width = config.width,
                            height = config.height,
                            preview_width = 0.7,
                        }
                    }
                )
            end)
            -- git
            map("n", "<leader>gg", "<cmd>Telescope git_status<cr>")
            map("n", "<leader>gb", "<cmd>Telescope git_branches<cr>")
            map("n", "<leader>gz", "<cmd>Telescope git_stash<cr>")
            map("n", "<leader>gc", "<cmd>Telescope git_commits<cr>")
            -- lsp
            map("n", "<leader>s", function() builtin.lsp_document_symbols(ivy) end)
            map("n", "<leader>S", function() builtin.lsp_dynamic_workspace_symbols(ivy) end)
            map("n", "<leader>D", function() builtin.diagnostics(ivy) end)
        end,
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        enabled = true,
        lazy = false,
        init = function() _G.Snacks = require("snacks") end,
        config = function()
            local MAC_SCREEN_SIZE = 190

            local function side_explorer_width()
                if vim.o.columns <= MAC_SCREEN_SIZE then
                    return 0.15
                end
                return 30
            end

            _G.Snacks.setup({
                -- plugins
                bigfile = { enabled = true },
                image = { enabled = true, },
                indent = { enabled = true, animate = { enabled = false } },
                quickfile = { enabled = true },
                gitbrowse = { enabled = true },
                bufdelete = { enabled = true },
                explorer = { enabled = false },
                picker = {
                    enabled = false,
                    layout = {
                        cycle = true,
                        preset = "vertical"
                    },
                    matcher = {
                        fuzzy = true,
                        smartcase = true,
                        ignorecase = true,
                        sort_empty = false,
                        filename_bonus = true,
                        file_pos = true,
                        cwd_bonus = true,
                        frecency = true,
                        history_bonus = true,
                    },
                    sources = {
                        explorer = { layout = { width = side_explorer_width } },
                        commands = { layout = { preview = false } },
                        keymaps = { layout = { preview = false } },
                        help = { layout = { preview = false } },
                        grep = { layout = { preset = "ivy" } },
                        grep_word = { layout = { preset = "ivy" } },
                        lsp_symbols = { layout = { preset = "ivy" } },
                        lsp_workspace_symbols = { layout = { preset = "ivy" } },
                    }
                },
            })
        end,
        keys = {
            { "<C-x>",      function() Snacks.bufdelete() end },
            { "<leader>x",  function() Snacks.bufdelete() end },
            { "<leader>go", function() Snacks.gitbrowse() end },
            { "<leader>?",  function() Snacks.picker() end },

            -- buffers
            { ",",          function() Snacks.picker.buffers({ focus = "list" }) end },
            { "<C-,>",      function() Snacks.picker.buffers() end },
            { "<leader>,",  function() Snacks.picker.buffers() end },
            {
                "<leader>e",
                function()
                    Snacks.picker.explorer({ focus = "list", layout = { preset = "vertical" }, auto_close = true, })
                end
            },
            { "<leader><tab>", function() Snacks.picker.explorer({ focus = "list" }) end },
            { "<leader>/",     function() Snacks.picker.lines() end },

            -- search
            { "<",             function() Snacks.picker.smart({ focus = "input" }) end },
            { "<leader>f",     function() Snacks.picker.smart({ focus = "input" }) end },
            { "<leader>r",     function() Snacks.picker.grep() end },
            { "<leader>R",     function() Snacks.picker.grep_word() end,                 mode = { "n", "v" } },

            -- lsp
            { "<leader>s",     function() Snacks.picker.lsp_symbols() end },
            { "<leader>S",     function() Snacks.picker.lsp_workspace_symbols() end },
            { "<leader>D",     function() Snacks.picker.diagnostics() end },
        }
    },
}
