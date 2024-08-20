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
            { "<C-e>", "<cmd>FzfLua buffers<cr>" },
            { "<C-f>", "<cmd>FzfLua lgrep_curbuf<cr>" },

            -- search inside file
            { "<leader>e", "<cmd>FzfLua buffers<cr>" },
            { "<leader>r", "<cmd>FzfLua live_grep_glob<cr>" },
            { "<leader>W", "<cmd>FzfLua grep_cword<cr>" },

            -- search for files
            { "<leader>f", "<cmd>FzfLua files cwd_only=true<cr>" },
            { "<leader>F", "<cmd>FzfLua files<cr>" },
            { "<leader>o", "<cmd>FzfLua oldfiles cwd_only=true<cr>" },
            { "<leader>O", "<cmd>FzfLua oldfiles<cr>" },

            -- lsp
            { "<leader>s", "<cmd>FzfLua lsp_document_symbols<cr>" },
            { "<leader>S", "<cmd>FzfLua lsp_live_workspace_symbols<cr>" },
            { "<leader>D", "<cmd>FzfLua diagnostics_document<cr>" },
            { "<leader>B", "<cmd>FzfLua dap_breakpoints<cr>" },

            -- utils
            { "<leader>:", "<cmd>FzfLua command_history<cr>" },
            { "<leader>hk", "<cmd>FzfLua keymaps<cr>" },
            { "<leader>hc", "<cmd>FzfLua command<cr>" },
            { "<leader>ht", "<cmd>FzfLua help_tags<cr>" },

            -- git
            { "<leader>gB", "<cmd>FzfLua git_branches<cr>" },
            { "<leader>gS", "<cmd>FzfLua git_status<cr>" },
        } 
}
