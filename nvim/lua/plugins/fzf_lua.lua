return {
    "ibhagwan/fzf-lua",
    enabled = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("fzf-lua").setup({
            winopts = {
                height = 0.6,
                width = 0.8,
                border = "|",
            },
            keymap = {
                builtin = {
                    false,
                    ["<C-.>"] = "toggle-help",
                    ["<C-p>"] = "toggle-preview",
                    ["<C-l>"] = "preview-page-down",
                    ["<C-h>"] = "preview-page-up",
                },
                fzf = {
                    false,
                    ["ctrl-q"] = "select-all+accept",
                    ["ctrl-z"] = "abort",
                    ["ctrl-u"] = "unix-line-discard",
                    ["ctrl-a"] = "beginning-of-line",
                    ["ctrl-e"] = "end-of-line",
                }
            },
            previewers = {
                builtin = {
                    extensions = {
                        ["png"] = { "viu", "-b" },
                        ["svg"] = { "viu", "-b" },
                        ["jpg"] = { "viu", "-b" },
                    }
                }
            },
            files = { formatter = "path.filename_first" },
            buffers = { formatter = "path.filename_first" },
            grep = { formatter = "path.filename_first" }
        })
    end,
    keys = {
        -- shortcuts
        { "<C-e>",      "<cmd>FzfLua buffers<cr>" },
        { "<C-f>",      "<cmd>FzfLua lgrep_curbuf<cr>" },
        { "<C-s>",      "<cmd>FzfLua lines<cr>" },

        -- search inside file
        { "<leader>e",  "<cmd>FzfLua buffers<cr>" },
        { "<leader>r",  "<cmd>FzfLua live_grep_glob<cr>" },
        { "<leader>W",  "<cmd>FzfLua grep_cword<cr>" },
        { "<leader>W",  "<cmd>FzfLua grep_visual<cr>",               mode = { "v" } },

        -- search for files
        { "<leader>f",  "<cmd>FzfLua files cwd_only=true<cr>" },
        { "<leader>o",  "<cmd>FzfLua oldfiles cwd_only=true<cr>" },

        -- lsp
        { "<leader>s",  "<cmd>FzfLua lsp_document_symbols<cr>" },
        { "<leader>S",  "<cmd>FzfLua lsp_live_workspace_symbols<cr>" },
        { "<leader>D",  "<cmd>FzfLua diagnostics_document<cr>" },
        { "<leader>B",  "<cmd>FzfLua dap_breakpoints<cr>" },

        -- utils
        { "<C-space>",  "<cmd>FzfLua command_history<cr>" },
        { "<leader>?k", "<cmd>FzfLua keymaps<cr>" },
        { "<leader>?c", "<cmd>FzfLua commands<cr>" },
        { "<leader>?h", "<cmd>FzfLua help_tags<cr>" },

        -- git
        { "<leader>gB", "<cmd>FzfLua git_branches<cr>" },
        { "<leader>gS", "<cmd>FzfLua git_status<cr>" },
    }
}
