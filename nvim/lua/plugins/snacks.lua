local centered_explorer_options = {
    focus = "list",
    layout = { preset = "vertical" },
    auto_close = true,
}

local MAC_SCREEN_SIZE = 190

local function side_explorer_width()
    if vim.o.columns <= MAC_SCREEN_SIZE then
        return 0.15
    end

    return 30
end


return {
    {},
    {
        "folke/snacks.nvim",
        priority = 1000,
        enabled = true,
        lazy = false,
        init = function() _G.Snacks = require("snacks") end,
        config = function()
            _G.Snacks.setup({
                -- settings
                styles = {
                    input = { relative = "cursor" },
                    notification = { wo = { wrap = true } },
                },
                -- plugins
                image = { enabled = true, },
                input = { enabled = true, },
                indent = {
                    enabled = true,
                    animate = { enabled = false }
                },
                zen = { enabled = false, },
                bigfile = { enabled = true },
                quickfile = { enabled = true },
                explorer = { enabled = true },
                words = { enabled = true },
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
                        smart =  { layout = { preset = "vscode" } } ,
                        explorer =  { layout = { width = side_explorer_width } },
                        commands = { layout = { preview = false, preset = "vertical" } },
                        keymaps = { layout = { preview = false, preset = "vertical" } },
                        help = { layout = { preview = false, preset = "vertical" } },
                        notifications = { layout = { preview = false, preset = "vertical" } },
                        qflist = { layout = { preview = true, preset = "vertical" } },
                        grep = { layout = { preset = "ivy" } },
                        grep_word = { layout = { preset = "ivy" } },
                        git_status = { layout = { preset = "ivy" } },
                        lsp_symbols = { layout = { preset = "ivy" } },
                        lsp_workspace_symbols = { layout = { preset = "ivy" } },
                    }
                },
                gitbrowse = { enabled = true },
                bufdelete = { enabled = true },
                notifier = {
                    enabled = false,
                    timeout = 3000,
                },
                notifications = { enabled = false },
            })
            vim.api.nvim_create_user_command("X", function() Snacks.bufdelete() end, {})
        end,
        keys = {
            { "<C-x>",         function() Snacks.bufdelete() end,                                desc = "Delete buffer" },
            { "<leader>x",     function() Snacks.bufdelete() end,                                desc = "Delete buffer" },
            { "<leader>go",    function() Snacks.gitbrowse() end,                                desc = "Git browse" },
            { "<leader>?",     function() Snacks.picker() end,                                   desc = "All pickers" },

            -- buffers
            { ",",             function() Snacks.picker.buffers({ focus = "list" }) end,         desc = "Show buffers" },
            { "<C-,>",         function() Snacks.picker.buffers() end,                           desc = "Show buffers" },
            { "<leader>,",     function() Snacks.picker.buffers() end,                           desc = "Show buffers" },
            { "<leader>e",     function() Snacks.picker.explorer(centered_explorer_options) end, desc = "Center explorer" },
            { "<leader><tab>", function() Snacks.picker.explorer({ focus = "list" }) end,        desc = "Center explorer" },
            { "<leader>/",     function() Snacks.picker.lines() end,                             desc = "Search in buffer" },

            -- search
            { "<",             function() Snacks.picker.smart({ focus = "input" }) end,          desc = "Find files" },
            { "<leader>f",     function() Snacks.picker.smart({ focus = "input" }) end,          desc = "Find files" },
            { "<leader>r",     function() Snacks.picker.grep() end,                              desc = "Grep" },
            { "<leader>R",     function() Snacks.picker.grep_word() end,                         desc = "Grep current word" },

            -- lsp
            { "<leader>s",     function() Snacks.picker.lsp_symbols() end,                       desc = "LSP symbols" },
            { "<leader>S",     function() Snacks.picker.lsp_workspace_symbols() end,             desc = "LSP workspace symbols" },
            { "<leader>D",     function() Snacks.picker.diagnostics() end,                       desc = "Diagnostics" },
            --- END PICKERS ---
        }
    },
}
