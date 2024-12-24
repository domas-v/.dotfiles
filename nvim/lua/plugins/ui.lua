return {
    {
        'sindrets/winshift.nvim',
        config = function() require('winshift').setup() end,
        cmd = { "WinShift" },
        keys = {
            { "<leader>wm", "<cmd>WinShift<cr>",       desc = "WinShift mode" },
            { "<leader>wh", "<cmd>WinShift left<cr>",  desc = "Winshift left" },
            { "<leader>wk", "<cmd>WinShift up<cr>",    desc = "WinShift up" },
            { "<leader>wj", "<cmd>WinShift down<cr>",  desc = "WinShift down" },
            { "<leader>wl", "<cmd>WinShift right<cr>", desc = "WinShift right" },
        }
    },
    {
        'stevearc/oil.nvim',
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = { "Oil" },
        opts = {
            columns = {
                "icon",
                "permissions",
                "size",
                "mtime"
            },
            view_options = {
                show_hidden = true
            },
            use_default_keymaps = false,
            keymaps = {
                ["g?"] = { "actions.show_help", mode = "n" },
                ["<CR>"] = "actions.select",
                ["<C-v>"] = { "actions.select", opts = { vertical = true } },
                ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
                ["<C-t>"] = { "actions.select", opts = { tab = true } },
                ["<leader>p"] = "actions.preview",
                ["q"] = { "actions.close", mode = "n" },
                ["<C-l>"] = "actions.refresh",
                ["-"] = { "actions.parent", mode = "n" },
                ["_"] = { "actions.open_cwd", mode = "n" },
                ["`"] = { "actions.cd", mode = "n" },
                ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
                ["gs"] = { "actions.change_sort", mode = "n" },
                ["gx"] = "actions.open_external",
                ["g."] = { "actions.toggle_hidden", mode = "n" },
                ["g\\"] = { "actions.toggle_trash", mode = "n" },
            },
        },
        keys = { { "<leader>.", "<cmd>Oil<cr>" } }
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            require('lualine').setup({
                options = { globalstatus = true },
                show_filename_only = false,
                sections = {
                    lualine_x = { 'filetype' }
                },
                tabline = {
                    lualine_a = { 'buffers' },
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = { 'tabs' },
                }
            })

            vim.keymap.set("n", "<C-1>", "<cmd>LualineBuffersJump! 1<cr>", { noremap = true })
            vim.keymap.set("n", "<C-2>", "<cmd>LualineBuffersJump! 2<cr>", { noremap = true })
            vim.keymap.set("n", "<C-3>", "<cmd>LualineBuffersJump! 3<cr>", { noremap = true })
            vim.keymap.set("n", "<C-4>", "<cmd>LualineBuffersJump! 4<cr>", { noremap = true })
            vim.keymap.set("n", "<C-5>", "<cmd>LualineBuffersJump! 5<cr>", { noremap = true })
            vim.keymap.set("n", "<C-6>", "<cmd>LualineBuffersJump! 6<cr>", { noremap = true })
            vim.keymap.set("n", "<C-7>", "<cmd>LualineBuffersJump! 7<cr>", { noremap = true })
            vim.keymap.set("n", "<C-8>", "<cmd>LualineBuffersJump! 8<cr>", { noremap = true })
            vim.keymap.set("n", "<C-9>", "<cmd>LualineBuffersJump! 9<cr>", { noremap = true })
            vim.keymap.set("n", "<C-0>", "<cmd>LualineBuffersJump $<cr>", { noremap = true })
        end,
    },
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {},
    }
}
