return {
    'nvim-telescope/telescope.nvim',
    enabled = false,
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

        local select_one_or_multi = function(prompt_bufnr)
            local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
            local multi = picker:get_multi_selection()
            if not vim.tbl_isempty(multi) then
                require('telescope.actions').close(prompt_bufnr)
                for _, j in pairs(multi) do
                    if j.path ~= nil then
                        if j.lnum ~= nil then
                            vim.cmd(string.format("%s +%s %s", "edit", j.lnum, j.path))
                        else
                            vim.cmd(string.format("%s %s", "edit", j.path))
                        end
                    end
                end
            else
                require('telescope.actions').select_default(prompt_bufnr)
            end
        end

        telescope.setup {
            defaults = {
                layout_strategy = strategy,
                layout_config = config,
                mappings = {
                    i = {
                        ["<CR>"] = select_one_or_multi,
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
                        ["<CR>"] = select_one_or_multi,
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

        -- buffers
        map("n", "<leader>,", function() builtin.buffers(small_prev) end)
        map('n', '<leader>/', function() builtin.current_buffer_fuzzy_find(ivy) end)
        map('n', '<leader>r', function() builtin.live_grep(ivy) end)
        map('n', '<leader>f', function() telescope.extensions['recent-files'].recent_files(small_prev) end)
        map("n", "<leader>e", function() telescope.extensions.file_browser.file_browser() end)

        map("n", "<leader>?", function() builtin.builtin({ previewer = false }) end)
        map("n", "<leader>h", function() builtin.help_tags({ previewer = false }) end)
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
}
