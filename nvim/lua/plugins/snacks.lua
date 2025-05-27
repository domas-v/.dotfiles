local centered_explorer_options = {
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
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    init = function() _G.Snacks = require("snacks") end,
    config = function()
        require("snacks").setup({
            -- settings
            styles = {
                input = { relative = "cursor" },
                notification = { wo = { wrap = true } },
            },
            -- plugins
            input = { enabled = true, },
            dashboard = {
                enabled = true,
                preset = {
                    keys = {
                        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.smart()" },
                        { icon = " ", key = "e", desc = "Explorer", action = ":lua Snacks.picker.explorer({ layout = { preset = 'vertical' } })" },
                        { icon = " ", key = "r", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                        { icon = "󰊢 ", key = "g", desc = "Git", action = ":Neogit" },
                        { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                        { icon = " ", key = "P", desc = "Projects", action = ":lua Snacks.picker.projects()" },
                        { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
                        { icon = "󱙣 ", key = "H", desc = "Check health", action = ":checkhealth" },
                        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                    },
                },
            },
            image = { enabled = true, },
            indent = {
                enabled = true,
                animate = { enabled = false }
            },
            zen = { enabled = true, },
            bigfile = { enabled = true },
            quickfile = { enabled = true },
            explorer = { enabled = true },
            words = { enabled = true },
            picker = {
                enabled = true,
                layout = {
                    cycle = true,
                    preset = "vscode"
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
                    explorer = { layout = { layout = { width = side_explorer_width } } },
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
                enabled = true,
                timeout = 3000,
            },

        })

        vim.cmd('command Dash lua Snacks.dashboard()')
    end,
    keys = {
        --- ACTIONS ---
        { "<leader>x",     function() Snacks.bufdelete() end,                                desc = "Delete buffer" },
        { "<C-x>",         function() Snacks.bufdelete() end,                                desc = "Delete buffer" },
        { "<leader>Z",     function() Snacks.zen.zoom() end,                                 desc = "Zoom" },
        { "<leader>go",    function() Snacks.gitbrowse() end,                                desc = "Git browse" },
        --- END ACTIONS ---

        --- PICKERS ---
        { "<leader>N",     function() Snacks.picker.notifications() end,                     desc = "Notifications" },
        { "<leader><TAB>", function() Snacks.explorer() end,                                 desc = "Side explorer" },
        { "<leader>P",     function() Snacks.picker.projects() end,                          desc = "Projects" },
        { "<leader>C",     function() Snacks.picker.qflist() end,                            desc = "Quickfix list" },

        -- help
        { "<leader>?",     function() Snacks.picker() end,                                   desc = "All pickers" },
        { "<leader>K",     function() Snacks.picker.keymaps() end,                           desc = "Keymaps" },
        { "<leader>H",     function() Snacks.picker.help() end,                              desc = "Help" },
        { "<leader>.",     function() Snacks.picker.resume() end,                            desc = "Resume last picker" },

        -- buffers
        { "<leader>e",     function() Snacks.picker.explorer(centered_explorer_options) end, desc = "Center explorer" },
        { "<leader>,",     function() Snacks.picker.buffers() end,                           desc = "Show buffers" },
        { "<leader>/",     function() Snacks.picker.lines() end,                             desc = "Search in buffer" },

        -- search
        { "<leader>f",     function() Snacks.picker.smart() end,                             desc = "Find files" },
        { "<leader>r",     function() Snacks.picker.grep() end,                              desc = "Grep" },
        { "<leader>R",     function() Snacks.picker.grep_word() end,                         desc = "Grep current word" },

        -- lsp
        { "<leader>s",     function() Snacks.picker.lsp_symbols() end,                       desc = "LSP symbols" },
        { "<leader>S",     function() Snacks.picker.lsp_workspace_symbols() end,             desc = "LSP workspace symbols" },
        { "<leader>D",     function() Snacks.picker.diagnostics() end,                       desc = "Diagnostics" },

        --- END PICKERS ---
    }
}
