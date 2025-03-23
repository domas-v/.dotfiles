return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    init = function() _G.Snacks = require("snacks") end,
    opts = {
        -- ui
        styles = {
            input = { relative = "cursor" },
            notification = { wo = { wrap = true } },
            zen = { backdrop = { transparent = false }, }
        },
        input = { enabled = true, },
        dashboard = {
            enabled = true,
            preset = {
                keys = {
                    { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                    { icon = " ", key = "o", desc = "Smart File Picker", action = ":lua Snacks.picker.smart()" },
                    { icon = " ", key = "r", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                    { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                    { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                    { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
            },
        },
        image = { enabled = true, },
        indent = {
            enabled = true,
            animate = { enabled = false }
        },
        zen = {
            enabled = true,
            toggles = { dim = false, }
        },
        -- files
        bigfile = { enabled = true },
        quickfile = { enabled = true },
        explorer = { enabled = true },
        -- search
        words = { enabled = true },
        picker = {
            enabled = true,
            layout = {
                cycle = true,
                preset = "ivy"
            },
            sources = {
                commands = { layout = { preview = false } },
                keymaps = { layout = { preview = false } },
                help = { layout = { preview = false } },
                notifications = { layout = { preview = false } },
            }
        },
        -- git
        gitbrowse = { enabled = true },
        -- misc
        bufdelete = { enabled = true },
        notifier = {
            enabled = true,
            timeout = 3000,
        },
    },
    keys = {
        --- MISC ---
        { "<leader>x",     function() Snacks.bufdelete() end,                                       desc = "Delete buffer" },
        { "<C-x>",         function() Snacks.bufdelete() end,                                       desc = "Delete buffer" },
        { "<leader>N",     function() Snacks.notifier.show_history() end,                           desc = "Show notification history" },
        { "<leader><TAB>", function() Snacks.explorer() end,                                        desc = "Explorer" },
        { "<leader>|",     function() Snacks.zen.zen() end,                                         desc = "Explorer" },
        { "<leader>zz",    function() Snacks.zen.zoom() end,                                        desc = "Explorer" },
        --- END MISC ---

        --- PICKERS ---
        -- help
        { "<leader>?",     function() Snacks.picker() end,                                          desc = "Show all pickers" },
        { "<leader>;",     function() Snacks.picker.commands() end,                                 desc = "Show all commands" },
        { "<leader>K",     function() Snacks.picker.keymaps() end,                                  desc = "Show all keymaps" },
        { "<leader>H",     function() Snacks.picker.help() end,                                     desc = "Show all help" },
        { "<leader>.",     function() Snacks.picker.resume() end,                                   desc = "Resume last picker" },

        -- buffers
        { "<leader>e",     function() Snacks.picker.buffers({ sort_lastused = true }) end,          desc = "Show buffers" },
        { "<C-e>",         function() Snacks.picker.buffers({ sort_lastused = true }) end,          desc = "Show buffers" },
        { "<leader>/",     function() Snacks.picker.lines() end,                                    desc = "Search in buffer" },

        -- search
        { "<leader>r",     function() Snacks.picker.grep() end,                                     desc = "Grep search" },
        { "<leader>R",     function() Snacks.picker.grep_word() end,                                desc = "Grep current word" },
        { "<leader>f",     function() Snacks.picker.files() end,                                    desc = "Find files" },
        { "<leader>o",     function() Snacks.picker.smart() end,                                    desc = "Smart search" },
        { "<leader>O",     function() Snacks.picker.smart({ hidden = true, no_ignore = true }) end, desc = "Smart search (all files)" },

        -- lsp
        { "<leader>s",     function() Snacks.picker.lsp_symbols() end,                              desc = "Document symbols" },
        { "<leader>S",     function() Snacks.picker.lsp_workspace_symbols() end,                    desc = "Workspace symbols" },
        { "<leader>D",     function() Snacks.picker.diagnostics() end,                              desc = "Show diagnostics" },

        -- git
        { "<leader>gb",    function() Snacks.picker.git_branches() end,                             desc = "Git branches" },
        { "<leader>gz",    function() Snacks.picker.git_stash() end,                                desc = "Git stash" },
        { "<leader>go",    function() Snacks.gitbrowse() end,                                       desc = "Git browse" },
        --- END PICKERS ---
    }
}
