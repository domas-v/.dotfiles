return {
    "folke/snacks.nvim",
    priority = 1000,
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

        local function yank_path(_, item)
            vim.fn.setreg("+", item.file)
            vim.notify("Copied path: " .. item.file)
        end

        _G.Snacks.setup({
            -- plugins
            bigfile = { enabled = true },
            image = { enabled = true, math = { enabled = false } },
            indent = { enabled = true, animate = { enabled = false } },
            quickfile = { enabled = true },
            gitbrowse = { enabled = true },
            bufdelete = { enabled = true },
            explorer = { enabled = true },
            input = { enabled = true },
            picker = {
                enabled = true,
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
                },
                actions = { yank_path = yank_path },
                win = {
                    input = {
                        keys = {
                            ["<C-y>"] = { "yank_path", mode = { "n", "i" } },
                            ["y"] = { "yank_path", mode = { "n" } },
                        },
                    },
                    list = {
                        keys = {
                            ["<C-y>"] = { "yank_path", mode = { "n", "i" } },
                            ["y"] = { "yank_path", mode = { "n" } },
                        }
                    }
                },
            },
        })
    end,
    keys = {
        { "<C-x>",     function() Snacks.bufdelete() end },
        { "<leader>?", function() Snacks.picker() end },
        { "<leader>K", function() Snacks.picker.keymaps() end },
        { "<leader><", function() Snacks.picker.resume() end },

        -- buffers
        { "<leader>,", function() Snacks.picker.buffers() end },
        {
            "<leader>e",
            function()
                Snacks.picker.explorer({ focus = "list", layout = { preset = "vertical" }, auto_close = true, })
            end
        },
        { "<leader><TAB>", function() Snacks.picker.explorer() end },

        -- search
        { "<leader>/",     function() Snacks.picker.lines() end },
        { "<leader>f",     function() Snacks.picker.smart({ focus = "input" }) end },
        { "<leader>g",     function() Snacks.picker.grep() end },
        { "<leader>W",     function() Snacks.picker.grep_word() end,               mode = { "n", "v" } },

        -- lsp
        { "gd",            function() Snacks.picker.lsp_definitions() end,         mode = "n" },
        { "<leader>s",     function() Snacks.picker.lsp_symbols() end },
        { "<leader>S",     function() Snacks.picker.lsp_workspace_symbols() end },
        { "<leader>R",     function() Snacks.picker.lsp_references() end },
        { "<leader>D",     function() Snacks.picker.diagnostics_buffer() end },

        -- git
        { "<leader>yg",    function() Snacks.gitbrowse() end,                      mode = { "n", "v" } },
        { "<leader>G",     function() Snacks.picker.git_diff() end,                mode = { "n", "v" } },
    }
}
