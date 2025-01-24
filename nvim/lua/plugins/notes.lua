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
        after = { "nvim-treesitter" },
        opts = {
            heading = {
                render_modes = { "i" },
                left_pad = { 1, 2, 3, 4, 5 }
            }
        }
    },
    {
        "Snikimonkd/yazmp",
        cmd = { "Zenmode" },
        keys = { { "<leader>zm", ":Zenmode<cr>" } }
    }
}
