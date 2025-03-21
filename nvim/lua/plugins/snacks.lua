return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        bigfile = { enabled = true },
        dashboard = { enabled = true },
        explorer = { enabled = true },
        indent = {
            enabled = true,
            animate = { enabled = false }
        },
        picker = {
            enabled = true,
            layout = {
                cycle = true,
                preset = "ivy_split"
            },
            sources = {
                commands = { layout = { preview = false } },
                keymaps = { layout = { preview = false } },
                help = { layout = { preview = false } },
            }
        },
        bufdelete = { enabled = true },
        --     input = { enabled = true },
        --     notifier = {
        --         enabled = true,
        --         timeout = 3000,
        --     },
        --     quickfile = { enabled = true },
        --     scope = { enabled = true },
        --     statuscolumn = { enabled = true },
        --     words = { enabled = true },
        --     styles = {
        --         notification = {
        --             wo = { wrap = true }
        --         }
        --     }
    },
    keys = {
        --- PICKERS ---
        -- help
        { "<leader>?",  function() Snacks.picker() end },
        { "<leader>;",  function() Snacks.picker.commands() end },
        { "<leader>K",  function() Snacks.picker.keymaps() end },
        { "<leader>H",  function() Snacks.picker.help() end },
        { "<leader>.",  function() Snacks.picker.resume() end },

        -- explorer
        { "<leader>e",  function() Snacks.explorer() end, },

        -- buffers
        { "<leader>,",  function() Snacks.picker.buffers({ sort_lastused = true }) end, },
        { "<leader>/",  function() Snacks.picker.lines() end, },

        -- search
        { "<leader>r",  function() Snacks.picker.grep() end, },
        { "<leader>o",  function() Snacks.picker.smart() end, },
        { "<leader>O",  function() Snacks.picker.smart({ hidden = true, no_ignore = true }) end, },

        -- lsp
        { "<leader>s",  function() Snacks.picker.lsp_symbols() end },
        { "<leader>S",  function() Snacks.picker.lsp_workspace_symbols() end },
        { "<leader>R",  function() Snacks.picker.lsp_references() end },
        -- { "<leader>d",  function() Snacks.picker.diagnostics_buffer() end },
        { "<leader>D",  function() Snacks.picker.diagnostics() end },

        -- git
        { "<leader>gs", function() Snacks.picker.git_status() end },
        { "<leader>gb", function() Snacks.picker.git_branches() end },
        { "<leader>gz", function() Snacks.picker.git_stash() end },
        --- END PICKERS ---

        --- BUFDELETE ---
        { "<leader>x",  function() Snacks.bufdelete() end },
        { "<C-x>",      function() Snacks.bufdelete() end }
        --- END BUFDELETE ---
    }
}
