return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        -- calling `setup` is optional for customization
        require("fzf-lua").setup({
            keymap = {
                builtin = {
                    true,
                    ["<C-p>"] = "toggle-preview",
                    ["<C-l>"] = "preview-page-down",
                    ["<C-h>"] = "preview-page-up",
                },
            },
            previewers = {
                builtin = {
                    extensions = {
                        ["png"] = { "viu", "-b" },
                        ["svg"] = { "viu", "-b" },
                        ["jpg"] = { "viu", "-b" },
                    }
                }
            }
        })
    end,
    keys = {
            -- shortcuts
            { "<C-e>", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
            { "<C-f>", "<cmd>FzfLua lgrep_curbuf<cr>", desc = "Current buffer" },

            { "<leader>e", "<cmd>FzfLua buffers<cr>",                   desc = "Buffers" },
            { "<leader>f", "<cmd>FzfLua lgrep_curbuf<cr>",     desc = "Current buffer" },
            { "<leader>f", "<cmd>FzfLua files cwd_only=true<cr>", desc = "Find files" },
            { "<leader>F", "<cmd>FzfLua files<cr>", desc = "Find files" },
            { "<leader>o", "<cmd>FzfLua oldfiles cwd_only=true<cr>", desc = "Find files" },
            { "<leader>O", "<cmd>FzfLua oldfiles<cr>", desc = "Files" },
            { "<leader>R", "<cmd>FzfLua live_grep_glob<cr>",       desc = "Live grep" },
            { "<leader>W", "<cmd>FzfLua grep_cword<cr>",       desc = "Live grep" },
            { "<leader>s", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "LSP symbols" },
            { "<leader>S", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", desc = "LSP workspace symbols" },
            { "<leader>D", "<cmd>FzfLua diagnostics_document<cr>", desc = "Diagnostics" },

            -- utils
            { "<leader>hk", "<cmd>FzfLua keymaps<cr>",                       desc = "Keymaps" },
            { "<leader>hc", "<cmd>FzfLua command<cr>",                      desc = "Commands" },
            { "<leader>ht", "<cmd>FzfLua help_tags<cr>",                     desc = "Help" },
            { "<leader>gB", "<cmd>FzfLua git_branches<cr>",                     desc = "Help" },
            { "<leader>gS", "<cmd>FzfLua git_status<cr>",                     desc = "Help" },
            { "<leader>dB", "<cmd>FzfLua dap_breakpoints<cr>",                     desc = "Help" },
        } 
}
