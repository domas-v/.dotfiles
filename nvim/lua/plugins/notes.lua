return {
    {
        "vhyrro/luarocks.nvim",
        priority = 1001,
        opts = {
            rocks = { "magick" },
        },
    },
    {
        "3rd/image.nvim",
        event = "VeryLazy",
        opts = {
            backend = "kitty",
            integrations = {
                markdown = {
                    enabled = true,
                    clear_in_insert_mode = false,
                    download_remote_images = true,
                    only_render_image_at_cursor = false,
                    filetypes = { "markdown", "vimwiki", "quarto" },
                },
                neorg = {
                    enabled = true,
                    clear_in_insert_mode = false,
                    download_remote_images = true,
                    only_render_image_at_cursor = false,
                    filetypes = { "norg" },
                },
            },
            max_width = nil,
            max_height = nil,
            max_width_window_percentage = nil,
            max_height_window_percentage = 50,
            kitty_method = "normal",
        },
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        -- enabled = false,
        after = { "nvim-treesitter" },
        opts = {
            heading = {
                render_modes = { "i" },
                left_pad = { 1, 2, 3, 4, 5 }
            }
        }
    },
    {
        "OXY2DEV/markview.nvim",
        enabled = false,
        lazy = false,
        opts = {
            preview = {
                modes = { "n", "no", "c", "i" },
                hybrid_modes = { "i", },
                linewise_hybrid_mode = true
            },
            markdown = {
                headings = {
                    shift_width = 0,
                    org_indent = false,
                    org_indent_wrap = false
                },
                list_items = {
                    marker_minus = { text = "•" },
                },
                code_blocks = { sign = false }
            }
        },
    },
    {
        "Snikimonkd/yazmp",
        cmd = { "Zenmode" },
        keys = { { "<leader>zm", ":Zenmode<cr>" } }
    }
}
