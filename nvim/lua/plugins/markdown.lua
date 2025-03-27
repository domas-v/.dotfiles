return {
    {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        "OXY2DEV/markview.nvim",
        lazy = false,
        priority = 999,
        config = function()
            local add_padding = false
            local youtube_icon = "󰗃 "
            require("markview").setup({
                preview = {
                    modes = { "n", "no", "c", "i" },
                    hybrid_modes = { "i", "n" },
                    linewise_hybrid_mode = true,
                    icon_provider = "devicons",
                },
                latex = { enable = false },
                markdown = {
                    list_items = {
                        marker_minus = {
                            add_padding = add_padding,
                            text = "󰧞",
                        },
                        marker_plus = {
                            add_padding = add_padding,
                            text = "󰐕",
                        },
                        marker_star = {
                            add_padding = add_padding,
                            text = "󰨐",
                        },
                        marker_dot = { add_padding = add_padding, },
                        marker_parenthesis = { add_padding = add_padding },
                    },
                    block_quotes = {
                        ["PROOF"] = {
                            preview = "󱉫 Proof",
                            hl = "MarkviewBlockQuoteNote",
                            title = true,
                            icon = "󱉫",
                            border = "▋"
                        },
                        ["INTUITION"] = {
                            preview = " Intuition",
                            hl = "MarkviewBlockQuoteNote",
                            title = true,
                            icon = "",
                            border = "▋"
                        },
                    },
                },
                markdown_inline = {
                    internal_links = { default = { icon = "" } },
                    hyperlinks = {
                        ["youtube%.com/"] = { icon = youtube_icon, },
                        ["youtu%.be/"] = { icon = youtube_icon, }
                    },
                    inline_codes = { padding_left = "", padding_right = "", }
                }
            })
            -- HACK: doesn't apply the colorscheme,
            -- so we have to do it manually, after the setup
            vim.cmd("colorscheme kanagawa")
        end
    },
}
