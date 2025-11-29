return {
    -- telescope
    {},
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
                -- settings
                styles = {
                    input = { relative = "cursor" },
                    notification = { wo = { wrap = true } },
                },
                -- plugins
                bigfile = { enabled = true },
                dim = { enabled = true, },
                explorer = { enabled = true },
                image = { enabled = true, },
                indent = { enabled = true, animate = { enabled = false } },
                quickfile = { enabled = true },
                gitbrowse = { enabled = true },
                bufdelete = { enabled = true },
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
                        notifications = { layout = { preview = false } },
                        grep = { layout = { preset = "ivy" } },
                        grep_word = { layout = { preset = "ivy" } },
                        git_status = { layout = { preset = "ivy" } },
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
