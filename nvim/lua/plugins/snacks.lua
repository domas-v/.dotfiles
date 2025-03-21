return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        -- ui
        styles = {
            input = { relative = "cursor" },
            notification = { wo = { wrap = true } }
        },
        input = { enabled = true, },
        dashboard = { enabled = true },
        image = {
            enabled = true,
            math = { latex = { font_size = "Large" } }
        },
        indent = {
            enabled = true,
            animate = { enabled = false }
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
        --- PICKERS ---
        -- help
        { "<leader>?",  function() Snacks.picker() end },
        { "<leader>;",  function() Snacks.picker.commands() end },
        { "<leader>K",  function() Snacks.picker.keymaps() end },
        { "<leader>H",  function() Snacks.picker.help() end },
        { "<leader>N",  function() Snacks.picker.notifications() end },
        { "<leader>.",  function() Snacks.picker.resume() end },

        -- explorer
        { "<leader>e",  function() Snacks.explorer() end, },

        -- buffers
        { "<leader>,",  function() Snacks.picker.buffers({ sort_lastused = true }) end, },
        { "<leader>/",  function() Snacks.picker.lines() end, },

        -- search
        { "<leader>r",  function() Snacks.picker.grep() end, },
        { "<leader>G",  function() Snacks.picker.grep_word() end, },
        { "<leader>f",  function() Snacks.picker.files() end, },
        { "<leader>o",  function() Snacks.picker.smart() end, },
        { "<leader>O",  function() Snacks.picker.smart({ hidden = true, no_ignore = true }) end, },

        -- lsp
        { "<leader>s",  function() Snacks.picker.lsp_symbols() end },
        { "<leader>S",  function() Snacks.picker.lsp_workspace_symbols() end },
        { "<leader>R",  function() Snacks.picker.lsp_references() end },
        { "<leader>D",  function() Snacks.picker.diagnostics() end },

        -- git
        { "<leader>gs", function() Snacks.picker.git_status() end },
        { "<leader>gb", function() Snacks.picker.git_branches() end },
        { "<leader>gz", function() Snacks.picker.git_stash() end },
        { "<leader>go", function() Snacks.gitbrowse() end },
        --- END PICKERS ---

        --- BUFDELETE ---
        { "<leader>x",  function() Snacks.bufdelete() end },
        { "<C-x>",      function() Snacks.bufdelete() end },
        --- END BUFDELETE ---
    }
}
